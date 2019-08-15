package com.javafast.modules.hr.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrResumeLog;
import com.javafast.modules.hr.service.HrResumeLogService;

/**
 * HR日志Controller
 * @author javafast
 * @version 2018-06-29
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrResumeLog")
public class HrResumeLogController extends BaseController {

	@Autowired
	private HrResumeLogService hrResumeLogService;
	
	@ModelAttribute
	public HrResumeLog get(@RequestParam(required=false) String id) {
		HrResumeLog entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrResumeLogService.get(id);
		}
		if (entity == null){
			entity = new HrResumeLog();
		}
		return entity;
	}
	
	/**
	 * HR日志列表页面
	 */
	@RequiresPermissions("hr:hrResumeLog:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrResumeLog hrResumeLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrResumeLog> page = hrResumeLogService.findPage(new Page<HrResumeLog>(request, response), hrResumeLog); 
		model.addAttribute("page", page);
		return "modules/hr/hrResumeLogList";
	}

	/**
	 * 编辑HR日志表单页面
	 */
	@RequiresPermissions(value={"hr:hrResumeLog:view","hr:hrResumeLog:add","hr:hrResumeLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrResumeLog hrResumeLog, Model model) {
		model.addAttribute("hrResumeLog", hrResumeLog);
		return "modules/hr/hrResumeLogForm";
	}
	
	/**
	 * 查看HR日志页面
	 */
	@RequiresPermissions(value="hr:hrResumeLog:view")
	@RequestMapping(value = "view")
	public String view(HrResumeLog hrResumeLog, Model model) {
		model.addAttribute("hrResumeLog", hrResumeLog);
		return "modules/hr/hrResumeLogView";
	}

	/**
	 * 保存HR日志
	 */
	@RequiresPermissions(value={"hr:hrResumeLog:add","hr:hrResumeLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrResumeLog hrResumeLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrResumeLog)){
			return form(hrResumeLog, model);
		}
		
		try{
		
			if(!hrResumeLog.getIsNewRecord()){//编辑表单保存				
				HrResumeLog t = hrResumeLogService.get(hrResumeLog.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrResumeLog, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrResumeLogService.save(t);//保存
			}else{//新增表单保存
				hrResumeLogService.save(hrResumeLog);//保存
			}
			addMessage(redirectAttributes, "保存HR日志成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存HR日志失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
		}
	}
	
	/**
	 * 删除HR日志
	 */
	@RequiresPermissions("hr:hrResumeLog:del")
	@RequestMapping(value = "delete")
	public String delete(HrResumeLog hrResumeLog, RedirectAttributes redirectAttributes) {
		hrResumeLogService.delete(hrResumeLog);
		addMessage(redirectAttributes, "删除HR日志成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
	}
	
	/**
	 * 批量删除HR日志
	 */
	@RequiresPermissions("hr:hrResumeLog:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrResumeLogService.delete(hrResumeLogService.get(id));
		}
		addMessage(redirectAttributes, "删除HR日志成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrResumeLog:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrResumeLog hrResumeLog, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "HR日志"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrResumeLog> page = hrResumeLogService.findPage(new Page<HrResumeLog>(request, response, -1), hrResumeLog);
    		new ExportExcel("HR日志", HrResumeLog.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出HR日志记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrResumeLog:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrResumeLog> list = ei.getDataList(HrResumeLog.class);
			for (HrResumeLog hrResumeLog : list){
				try{
					hrResumeLogService.save(hrResumeLog);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条HR日志记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条HR日志记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入HR日志失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
    }
	
	/**
	 * 下载导入HR日志数据模板
	 */
	@RequiresPermissions("hr:hrResumeLog:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "HR日志数据导入模板.xlsx";
    		List<HrResumeLog> list = Lists.newArrayList(); 
    		new ExportExcel("HR日志数据", HrResumeLog.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResumeLog/?repage";
    }
	
	/**
	 * HR日志列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrResumeLog hrResumeLog, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrResumeLog, request, response, model);
        return "modules/hr/hrResumeLogSelectList";
	}
	
}