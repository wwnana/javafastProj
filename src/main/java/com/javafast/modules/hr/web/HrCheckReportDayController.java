package com.javafast.modules.hr.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.javafast.modules.sys.utils.AccountUtils;
import com.javafast.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysConfig;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrCheckReportDay;
import com.javafast.modules.hr.entity.HrCheckReportDetail;
import com.javafast.modules.hr.service.HrCheckReportDayService;
import com.javafast.modules.hr.service.HrCheckReportDetailService;

/**
 * 每日打卡汇总Controller
 *
 * @author javafast
 * @version 2018-07-10
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrCheckReportDay")
public class HrCheckReportDayController extends BaseController {

    @Autowired
    private HrCheckReportDayService hrCheckReportDayService;
    
    @Autowired
	private HrCheckReportDetailService hrCheckReportDetailService;

    @ModelAttribute
    public HrCheckReportDay get(@RequestParam(required = false) String id) {
        HrCheckReportDay entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = hrCheckReportDayService.get(id);
        }
        if (entity == null) {
            entity = new HrCheckReportDay();
        }
        return entity;
    }

    /**
     * 每日打卡汇总列表页面
     */
    @RequiresPermissions("hr:hrCheckReport:list")
    @RequestMapping(value = {"list", ""})
    public String list(HrCheckReportDay hrCheckReportDay, HttpServletRequest request, HttpServletResponse response, Model model) {
    	
    	//默认查询时间范围为本月开始-本月当日
    	if(hrCheckReportDay.getStartDate() == null || hrCheckReportDay.getEndDate() == null){
    		hrCheckReportDay.setStartDate(DateUtils.getDayAfterN(-7));
    		hrCheckReportDay.setEndDate(DateUtils.getBeginDayOfYesterday());
    	}
    	
        Page<HrCheckReportDay> page = hrCheckReportDayService.findPage(new Page<HrCheckReportDay>(request, response), hrCheckReportDay);
        model.addAttribute("hrCheckReportDay", hrCheckReportDay);
        model.addAttribute("page", page);
        
       //检测是否配置打卡应用的Secret
        if(page.getList() == null || page.getList().size() == 0){
        	
        	SysConfig sysConfig = AccountUtils.getSysConfig(UserUtils.getSysAccount().getId());
    		if(sysConfig == null || StringUtils.isBlank(sysConfig.getWxCorpid()) || StringUtils.isBlank(sysConfig.getCheckinSecret())){
    			model.addAttribute("configMsg", "获取企业微信打卡数据需要配置打卡应用的Secret，请前往进行配置");
    		}
        }
        
        return "modules/hr/hrCheckReportDayList";
    }

    /**
     * 编辑每日打卡汇总表单页面
     */
    @RequiresPermissions(value = {"hr:hrCheckReport:view", "hr:hrCheckReport:add", "hr:hrCheckReport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(HrCheckReportDay hrCheckReportDay, Model model) {
        model.addAttribute("hrCheckReportDay", hrCheckReportDay);
        return "modules/hr/hrCheckReportDayForm";
    }

    /**
     * 查看每日打卡汇总页面
     */
    @RequiresPermissions(value = "hr:hrCheckReport:view")
    @RequestMapping(value = "view")
    public String view(HrCheckReportDay hrCheckReportDay, Model model) {

        model.addAttribute("hrCheckReportDay", hrCheckReportDay);
        
        //查询打卡明细
        List<HrCheckReportDetail> hrCheckReportDetailList = hrCheckReportDetailService.findList(new HrCheckReportDetail(hrCheckReportDay.getUser(), hrCheckReportDay.getCheckinDate()));
        model.addAttribute("hrCheckReportDetailList", hrCheckReportDetailList);
        
        return "modules/hr/hrCheckReportDayView";
    }

    /**
     * 保存每日打卡汇总
     */
    @RequiresPermissions(value = {"hr:hrCheckReport:add", "hr:hrCheckReport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public String save(HrCheckReportDay hrCheckReportDay, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrCheckReportDay)) {
            return form(hrCheckReportDay, model);
        }

        try {

            if (!hrCheckReportDay.getIsNewRecord()) {//编辑表单保存
                HrCheckReportDay t = hrCheckReportDayService.get(hrCheckReportDay.getId());//从数据库取出记录的值
                MyBeanUtils.copyBeanNotNull2Bean(hrCheckReportDay, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
                hrCheckReportDayService.save(t);//保存
            } else {//新增表单保存
                hrCheckReportDayService.save(hrCheckReportDay);//保存
            }
            addMessage(redirectAttributes, "保存每日打卡汇总成功");
        } catch (Exception e) {
            e.printStackTrace();
            addMessage(redirectAttributes, "保存每日打卡汇总失败");
        } finally {
            return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
        }
    }

    /**
     * 删除每日打卡汇总
     */
    @RequiresPermissions("hr:hrCheckReport:del")
    @RequestMapping(value = "delete")
    public String delete(HrCheckReportDay hrCheckReportDay, RedirectAttributes redirectAttributes) {
        hrCheckReportDayService.delete(hrCheckReportDay);
        addMessage(redirectAttributes, "删除每日打卡汇总成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }

    /**
     * 批量删除每日打卡汇总
     */
    @RequiresPermissions("hr:hrCheckReport:del")
    @RequestMapping(value = "deleteAll")
    public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
        String idArray[] = ids.split(",");
        for (String id : idArray) {
            hrCheckReportDayService.delete(hrCheckReportDayService.get(id));
        }
        addMessage(redirectAttributes, "删除每日打卡汇总成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }

    /**
     * 导出excel文件
     */
    @RequiresPermissions("hr:hrCheckReport:export")
    @RequestMapping(value = "export", method = RequestMethod.POST)
    public String exportFile(HrCheckReportDay hrCheckReportDay, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "每日打卡汇总" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<HrCheckReportDay> page = hrCheckReportDayService.findPage(new Page<HrCheckReportDay>(request, response, -1), hrCheckReportDay);
            new ExportExcel("每日打卡汇总", HrCheckReportDay.class).setDataList(page.getList()).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导出每日打卡汇总记录失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }

    /**
     * 导入Excel数据
     */
    @RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import", method = RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<HrCheckReportDay> list = ei.getDataList(HrCheckReportDay.class);
            for (HrCheckReportDay hrCheckReportDay : list) {
                try {
                    hrCheckReportDayService.save(hrCheckReportDay);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条每日打卡汇总记录。");
            }
            addMessage(redirectAttributes, "已成功导入 " + successNum + " 条每日打卡汇总记录" + failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入每日打卡汇总失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }

    /**
     * 下载导入每日打卡汇总数据模板
     */
    @RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "每日打卡汇总数据导入模板.xlsx";
            List<HrCheckReportDay> list = Lists.newArrayList();
            new ExportExcel("每日打卡汇总数据", HrCheckReportDay.class, 2).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }

    /**
     * 每日打卡汇总列表选择器
     */
    @RequestMapping(value = "selectList")
    public String selectList(HrCheckReportDay hrCheckReportDay, HttpServletRequest request, HttpServletResponse response, Model model) {
        list(hrCheckReportDay, request, response, model);
        return "modules/hr/hrCheckReportDaySelectList";
    }

    @RequiresPermissions("hr:hrCheckReport:list")
    @RequestMapping(value = {"synch"})
    public String synch(HrCheckReportDay hrCheckReportDay, HttpServletRequest request, HttpServletResponse response, Model model) {


        int count = hrCheckReportDayService.generateDayReportAndMonth(DateUtils.getBeginDayOfMonth(),DateUtils.getBeginDayOfYesterday()
                ,UserUtils.getUser().getAccountId(),null);
       // model.addAttribute("count", count);
        return "modules/hr/hrCheckReportDayList";
    }


}