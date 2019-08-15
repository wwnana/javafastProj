/**
 * Copyright 2015-2020
 */
package com.javafast.modules.scm.web;

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

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

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
import com.javafast.modules.scm.entity.ScmComplaint;
import com.javafast.modules.scm.service.ScmComplaintService;

/**
 * 客户投诉Controller
 * @author javafast
 * @version 2017-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/scm/scmComplaint")
public class ScmComplaintController extends BaseController {

	@Autowired
	private ScmComplaintService scmComplaintService;
	
	@ModelAttribute
	public ScmComplaint get(@RequestParam(required=false) String id) {
		ScmComplaint entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmComplaintService.get(id);
		}
		if (entity == null){
			entity = new ScmComplaint();
		}
		return entity;
	}
	
	/**
	 * 客户投诉列表页面
	 */
	@RequiresPermissions("scm:scmComplaint:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmComplaint scmComplaint, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScmComplaint> page = scmComplaintService.findPage(new Page<ScmComplaint>(request, response), scmComplaint); 
		model.addAttribute("page", page);
		return "modules/scm/scmComplaintList";
	}

	/**
	 * 编辑客户投诉表单页面
	 */
	@RequiresPermissions(value={"scm:scmComplaint:view","scm:scmComplaint:add","scm:scmComplaint:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmComplaint scmComplaint, Model model) {
		model.addAttribute("scmComplaint", scmComplaint);
		return "modules/scm/scmComplaintForm";
	}
	
	/**
	 * 查看客户投诉页面
	 */
	@RequiresPermissions(value="scm:scmComplaint:view")
	@RequestMapping(value = "view")
	public String view(ScmComplaint scmComplaint, Model model) {
		model.addAttribute("scmComplaint", scmComplaint);
		return "modules/scm/scmComplaintView";
	}

	/**
	 * 保存客户投诉
	 */
	@RequiresPermissions(value={"scm:scmComplaint:add","scm:scmComplaint:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmComplaint scmComplaint, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmComplaint)){
			return form(scmComplaint, model);
		}
		
		try{
		
			if(!scmComplaint.getIsNewRecord()){//编辑表单保存				
				ScmComplaint t = scmComplaintService.get(scmComplaint.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmComplaint, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmComplaintService.save(t);//保存
			}else{//新增表单保存
				scmComplaint.setStatus("0");
				scmComplaintService.save(scmComplaint);//保存
			}
			addMessage(redirectAttributes, "保存客户投诉成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户投诉失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
		}
	}
	
	/**
	 * 删除客户投诉
	 */
	@RequiresPermissions("scm:scmComplaint:del")
	@RequestMapping(value = "delete")
	public String delete(ScmComplaint scmComplaint, RedirectAttributes redirectAttributes) {
		scmComplaintService.delete(scmComplaint);
		addMessage(redirectAttributes, "删除客户投诉成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
	}
	
	/**
	 * 批量删除客户投诉
	 */
	@RequiresPermissions("scm:scmComplaint:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scmComplaintService.delete(scmComplaintService.get(id));
		}
		addMessage(redirectAttributes, "删除客户投诉成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("scm:scmComplaint:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(ScmComplaint scmComplaint, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户投诉"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScmComplaint> page = scmComplaintService.findPage(new Page<ScmComplaint>(request, response, -1), scmComplaint);
    		new ExportExcel("客户投诉", ScmComplaint.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户投诉记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("scm:scmComplaint:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScmComplaint> list = ei.getDataList(ScmComplaint.class);
			for (ScmComplaint scmComplaint : list){
				try{
					scmComplaintService.save(scmComplaint);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户投诉记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户投诉记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户投诉失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
    }
	
	/**
	 * 下载导入客户投诉数据模板
	 */
	@RequiresPermissions("scm:scmComplaint:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户投诉数据导入模板.xlsx";
    		List<ScmComplaint> list = Lists.newArrayList(); 
    		new ExportExcel("客户投诉数据", ScmComplaint.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
    }
	
	/**
	 * 客户投诉列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(ScmComplaint scmComplaint, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(scmComplaint, request, response, model);
        return "modules/scm/scmComplaintSelectList";
	}
	
	
	/**
	 * 审核客户投诉表单页面
	 */
	@RequiresPermissions(value="scm:scmComplaint:audit")
	@RequestMapping(value = "auditForm")
	public String auditForm(ScmComplaint scmComplaint, Model model) {
		model.addAttribute("scmComplaint", scmComplaint);
		return "modules/scm/scmComplaintAuditForm";
	}
	
	/**
	 * 审核客户投诉
	 */
	@RequiresPermissions(value="scm:scmComplaint:audit")
	@RequestMapping(value = "auditSave")
	public String auditSave(ScmComplaint scmComplaint, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmComplaint)){
			return form(scmComplaint, model);
		}
		
		try{
		
			ScmComplaint t = scmComplaintService.get(scmComplaint.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(scmComplaint, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			
			t.setStatus("1");
			t.setAuditBy(UserUtils.getUser());
			t.setAuditDate(new Date());
			scmComplaintService.save(t);//保存
			addMessage(redirectAttributes, "审核客户投诉成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审核客户投诉失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmComplaint/?repage";
		}
	}
}