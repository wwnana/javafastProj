package com.javafast.modules.hr.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.javafast.modules.hr.entity.HrCheckRule;
import com.javafast.modules.hr.service.HrCheckReportDayService;
import com.javafast.modules.hr.service.HrCheckReportService;
import com.javafast.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrCheckReportDetail;
import com.javafast.modules.hr.service.HrCheckReportDetailService;

/**
 * 每日打卡明细Controller
 *
 * @author javafast
 * @version 2018-07-09
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrCheckReportDetail")
public class HrCheckReportDetailController extends BaseController {

    @Autowired
    private HrCheckReportDetailService hrCheckReportDetailService;

    @ModelAttribute
    public HrCheckReportDetail get(@RequestParam(required = false) String id) {
        HrCheckReportDetail entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = hrCheckReportDetailService.get(id);
        }
        if (entity == null) {
            entity = new HrCheckReportDetail();
        }
        return entity;
    }

    /**
     * 每日打卡明细列表页面
     */
    @RequiresPermissions("hr:hrCheckReport:list")
    @RequestMapping(value = {"list", ""})
    public String list(HrCheckReportDetail hrCheckReportDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<HrCheckReportDetail> page = hrCheckReportDetailService.findPage(new Page<HrCheckReportDetail>(request, response), hrCheckReportDetail);
        model.addAttribute("page", page);
        return "modules/hr/hrCheckReportDetailList";
    }

    /**
     * 编辑每日打卡明细表单页面
     */
    @RequiresPermissions(value = {"hr:hrCheckReport:view", "hr:hrCheckReport:add", "hr:hrCheckReport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(HrCheckReportDetail hrCheckReportDetail, Model model) {
        model.addAttribute("hrCheckReportDetail", hrCheckReportDetail);
        return "modules/hr/hrCheckReportDetailForm";
    }

    /**
     * 查看每日打卡明细页面
     */
    @RequiresPermissions(value = "hr:hrCheckReport:view")
    @RequestMapping(value = "view")
    public String view(HrCheckReportDetail hrCheckReportDetail, Model model) {
        model.addAttribute("hrCheckReportDetail", hrCheckReportDetail);
        return "modules/hr/hrCheckReportDetailView";
    }

    /**
     * 保存每日打卡明细
     */
    @RequiresPermissions(value = {"hr:hrCheckReport:add", "hr:hrCheckReport:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public String save(HrCheckReportDetail hrCheckReportDetail, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrCheckReportDetail)) {
            return form(hrCheckReportDetail, model);
        }

        try {

            if (!hrCheckReportDetail.getIsNewRecord()) {//编辑表单保存
                HrCheckReportDetail t = hrCheckReportDetailService.get(hrCheckReportDetail.getId());//从数据库取出记录的值
                MyBeanUtils.copyBeanNotNull2Bean(hrCheckReportDetail, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
                hrCheckReportDetailService.save(t);//保存
            } else {//新增表单保存
                hrCheckReportDetailService.save(hrCheckReportDetail);//保存
            }
            addMessage(redirectAttributes, "保存每日打卡明细成功");
        } catch (Exception e) {
            e.printStackTrace();
            addMessage(redirectAttributes, "保存每日打卡明细失败");
        } finally {
            return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
        }
    }

    /**
     * 删除每日打卡明细
     */
    @RequiresPermissions("hr:hrCheckReport:del")
    @RequestMapping(value = "delete")
    public String delete(HrCheckReportDetail hrCheckReportDetail, RedirectAttributes redirectAttributes) {
        hrCheckReportDetailService.delete(hrCheckReportDetail);
        addMessage(redirectAttributes, "删除每日打卡明细成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
    }

    /**
     * 批量删除每日打卡明细
     */
    @RequiresPermissions("hr:hrCheckReport:del")
    @RequestMapping(value = "deleteAll")
    public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
        String idArray[] = ids.split(",");
        for (String id : idArray) {
            hrCheckReportDetailService.delete(hrCheckReportDetailService.get(id));
        }
        addMessage(redirectAttributes, "删除每日打卡明细成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
    }

    /**
     * 导出excel文件
     */
    @RequiresPermissions("hr:hrCheckReport:export")
    @RequestMapping(value = "export", method = RequestMethod.POST)
    public String exportFile(HrCheckReportDetail hrCheckReportDetail, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "每日打卡明细" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<HrCheckReportDetail> page = hrCheckReportDetailService.findPage(new Page<HrCheckReportDetail>(request, response, -1), hrCheckReportDetail);
            new ExportExcel("每日打卡明细", HrCheckReportDetail.class).setDataList(page.getList()).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导出每日打卡明细记录失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
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
            List<HrCheckReportDetail> list = ei.getDataList(HrCheckReportDetail.class);
            for (HrCheckReportDetail hrCheckReportDetail : list) {
                try {
                    hrCheckReportDetailService.save(hrCheckReportDetail);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条每日打卡明细记录。");
            }
            addMessage(redirectAttributes, "已成功导入 " + successNum + " 条每日打卡明细记录" + failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入每日打卡明细失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
    }

    /**
     * 下载导入每日打卡明细数据模板
     */
    @RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "每日打卡明细数据导入模板.xlsx";
            List<HrCheckReportDetail> list = Lists.newArrayList();
            new ExportExcel("每日打卡明细数据", HrCheckReportDetail.class, 2).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDetail/?repage";
    }

    /**
     * 每日打卡明细列表选择器
     */
    @RequestMapping(value = "selectList")
    public String selectList(HrCheckReportDetail hrCheckReportDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
        list(hrCheckReportDetail, request, response, model);
        return "modules/hr/hrCheckReportDetailSelectList";
    }

    /**
     *
     * 手动触发同步打卡数据
     * @param redirectAttributes
     * @param model
     * @return
     */
    @RequestMapping(value = "synch")
    public String synch(RedirectAttributes redirectAttributes, Model model) {

        try {
            String accountId = UserUtils.getUser().getAccountId();
            Date startDate = DateUtils.getBeginDayOfMonth();
            Date endDate = DateUtils.getEndDayOfMonth();

            hrCheckReportDetailService.synchCorpWechatCheckAll(accountId, startDate, endDate);
        } catch (Exception e) {
            addMessage(redirectAttributes, "失败" + e.getMessage());
        }
        addMessage(redirectAttributes, "同步成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrCheckReportDay/?repage";
    }


}