package com.javafast.modules.hr.web;

import java.util.Date;
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

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysConfig;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrCheckReport;
import com.javafast.modules.hr.service.HrCheckReportService;

/**
 * 月度打卡汇总Controller
 * @author javafast
 * @version 2018-07-09
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrCheckReport")
public class HrCheckReportController extends BaseController {

	@Autowired
	private HrCheckReportService hrCheckReportService;
	
	@ModelAttribute
	public HrCheckReport get(@RequestParam(required=false) String id) {
		HrCheckReport entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrCheckReportService.get(id);
		}
		if (entity == null){
			entity = new HrCheckReport();
		}
		return entity;
	}
	
	/**
	 * 月度打卡汇总列表页面
	 */
	@RequiresPermissions("hr:hrCheckReport:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrCheckReport hrCheckReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//默认查询时间范围为本月开始-本月当日
    	if(hrCheckReport.getBeginCheckinDate() == null || hrCheckReport.getEndCheckinDate() == null){
    		hrCheckReport.setBeginCheckinDate(DateUtils.getBeginDayOfLastMonth());
    		hrCheckReport.setEndCheckinDate(new Date());
    	}
    	
		Page<HrCheckReport> page = hrCheckReportService.findPage(new Page<HrCheckReport>(request, response), hrCheckReport); 
		model.addAttribute("page", page);
		
	       //检测是否配置打卡应用的Secret
        if(page.getList() == null || page.getList().size() == 0){
        	
        	SysConfig sysConfig = AccountUtils.getSysConfig(UserUtils.getSysAccount().getId());
    		if(sysConfig == null || StringUtils.isBlank(sysConfig.getWxCorpid()) || StringUtils.isBlank(sysConfig.getCheckinSecret())){
    			model.addAttribute("configMsg", "获取企业微信打卡数据需要配置打卡应用的Secret，请前往进行配置");
    		}
        }
        
		return "modules/hr/hrCheckReportList";
	}

	/**
	 * 编辑月度打卡汇总表单页面
	 */
	@RequiresPermissions(value={"hr:hrCheckReport:view","hr:hrCheckReport:add","hr:hrCheckReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrCheckReport hrCheckReport, Model model) {
		model.addAttribute("hrCheckReport", hrCheckReport);
		return "modules/hr/hrCheckReportForm";
	}
	
	/**
	 * 查看月度打卡汇总页面
	 */
	@RequiresPermissions(value="hr:hrCheckReport:view")
	@RequestMapping(value = "view")
	public String view(HrCheckReport hrCheckReport, Model model) {
		model.addAttribute("hrCheckReport", hrCheckReport);
		return "modules/hr/hrCheckReportView";
	}

	/**
	 * 保存月度打卡汇总
	 */
	@RequiresPermissions(value={"hr:hrCheckReport:add","hr:hrCheckReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrCheckReport hrCheckReport, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrCheckReport)){
			return form(hrCheckReport, model);
		}
		
		try{
		
			if(!hrCheckReport.getIsNewRecord()){//编辑表单保存				
				HrCheckReport t = hrCheckReportService.get(hrCheckReport.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrCheckReport, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrCheckReportService.save(t);//保存
			}else{//新增表单保存
				hrCheckReportService.save(hrCheckReport);//保存
			}
			addMessage(redirectAttributes, "保存月度打卡汇总成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存月度打卡汇总失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
		}
	}
	
	/**
	 * 删除月度打卡汇总
	 */
	@RequiresPermissions("hr:hrCheckReport:del")
	@RequestMapping(value = "delete")
	public String delete(HrCheckReport hrCheckReport, RedirectAttributes redirectAttributes) {
		hrCheckReportService.delete(hrCheckReport);
		addMessage(redirectAttributes, "删除月度打卡汇总成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
	}
	
	/**
	 * 批量删除月度打卡汇总
	 */
	@RequiresPermissions("hr:hrCheckReport:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrCheckReportService.delete(hrCheckReportService.get(id));
		}
		addMessage(redirectAttributes, "删除月度打卡汇总成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrCheckReport:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrCheckReport hrCheckReport, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "月度打卡汇总"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrCheckReport> page = hrCheckReportService.findPage(new Page<HrCheckReport>(request, response, -1), hrCheckReport);
    		new ExportExcel("月度打卡汇总", HrCheckReport.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出月度打卡汇总记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrCheckReport> list = ei.getDataList(HrCheckReport.class);
			for (HrCheckReport hrCheckReport : list){
				try{
					hrCheckReportService.save(hrCheckReport);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条月度打卡汇总记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条月度打卡汇总记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入月度打卡汇总失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
    }
	
	/**
	 * 下载导入月度打卡汇总数据模板
	 */
	@RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "月度打卡汇总数据导入模板.xlsx";
    		List<HrCheckReport> list = Lists.newArrayList(); 
    		new ExportExcel("月度打卡汇总数据", HrCheckReport.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
    }
	
	/**
	 * 月度打卡汇总列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrCheckReport hrCheckReport, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrCheckReport, request, response, model);
        return "modules/hr/hrCheckReportSelectList";
	}

	/**
	 * 删除月度打卡汇总
	 */
	@RequiresPermissions("hr:hrCheckReport:edit")
	@RequestMapping(value = "synch")
	public String synch(HrCheckReport hrCheckReport, RedirectAttributes redirectAttributes) {
		hrCheckReport.setAccountId(UserUtils.getUser().getAccountId());
		//hrCheckReportService.generateDayReportButNotAudit(hrCheckReport);
		addMessage(redirectAttributes, "统计一个月的考勤");
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckReport/?repage";
	}


}