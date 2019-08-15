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
import com.javafast.modules.scm.entity.ScmSuppot;
import com.javafast.modules.scm.service.ScmSuppotService;

/**
 * 客户服务Controller
 * @author javafast
 * @version 2017-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/scm/scmSuppot")
public class ScmSuppotController extends BaseController {

	@Autowired
	private ScmSuppotService scmSuppotService;
	
	@ModelAttribute
	public ScmSuppot get(@RequestParam(required=false) String id) {
		ScmSuppot entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmSuppotService.get(id);
		}
		if (entity == null){
			entity = new ScmSuppot();
		}
		return entity;
	}
	
	/**
	 * 客户服务列表页面
	 */
	@RequiresPermissions("scm:scmSuppot:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmSuppot scmSuppot, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScmSuppot> page = scmSuppotService.findPage(new Page<ScmSuppot>(request, response), scmSuppot); 
		model.addAttribute("page", page);
		return "modules/scm/scmSuppotList";
	}

	/**
	 * 编辑客户服务表单页面
	 */
	@RequiresPermissions(value={"scm:scmSuppot:view","scm:scmSuppot:add","scm:scmSuppot:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmSuppot scmSuppot, Model model) {
		model.addAttribute("scmSuppot", scmSuppot);
		return "modules/scm/scmSuppotForm";
	}
	
	/**
	 * 查看客户服务页面
	 */
	@RequiresPermissions(value="scm:scmSuppot:view")
	@RequestMapping(value = "view")
	public String view(ScmSuppot scmSuppot, Model model) {
		model.addAttribute("scmSuppot", scmSuppot);
		return "modules/scm/scmSuppotView";
	}

	/**
	 * 保存客户服务
	 */
	@RequiresPermissions(value={"scm:scmSuppot:add","scm:scmSuppot:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmSuppot scmSuppot, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmSuppot)){
			return form(scmSuppot, model);
		}
		
		try{
		
			if(!scmSuppot.getIsNewRecord()){//编辑表单保存				
				ScmSuppot t = scmSuppotService.get(scmSuppot.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmSuppot, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmSuppotService.save(t);//保存
			}else{//新增表单保存
				scmSuppot.setStatus("0");
				scmSuppotService.save(scmSuppot);//保存
			}
			addMessage(redirectAttributes, "保存客户服务成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户服务失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
		}
	}
	
	/**
	 * 删除客户服务
	 */
	@RequiresPermissions("scm:scmSuppot:del")
	@RequestMapping(value = "delete")
	public String delete(ScmSuppot scmSuppot, RedirectAttributes redirectAttributes) {
		scmSuppotService.delete(scmSuppot);
		addMessage(redirectAttributes, "删除客户服务成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
	}
	
	/**
	 * 批量删除客户服务
	 */
	@RequiresPermissions("scm:scmSuppot:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scmSuppotService.delete(scmSuppotService.get(id));
		}
		addMessage(redirectAttributes, "删除客户服务成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("scm:scmSuppot:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(ScmSuppot scmSuppot, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户服务"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScmSuppot> page = scmSuppotService.findPage(new Page<ScmSuppot>(request, response, -1), scmSuppot);
    		new ExportExcel("客户服务", ScmSuppot.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户服务记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("scm:scmSuppot:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScmSuppot> list = ei.getDataList(ScmSuppot.class);
			for (ScmSuppot scmSuppot : list){
				try{
					scmSuppotService.save(scmSuppot);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户服务记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户服务记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户服务失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
    }
	
	/**
	 * 下载导入客户服务数据模板
	 */
	@RequiresPermissions("scm:scmSuppot:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户服务数据导入模板.xlsx";
    		List<ScmSuppot> list = Lists.newArrayList(); 
    		new ExportExcel("客户服务数据", ScmSuppot.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
    }
	
	/**
	 * 客户服务列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(ScmSuppot scmSuppot, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(scmSuppot, request, response, model);
        return "modules/scm/scmSuppotSelectList";
	}
	
	/**
	 * 审核客户服务表单页面
	 */
	@RequiresPermissions(value="scm:scmSuppot:audit")
	@RequestMapping(value = "auditForm")
	public String auditForm(ScmSuppot scmSuppot, Model model) {
		model.addAttribute("scmSuppot", scmSuppot);
		return "modules/scm/scmSuppotAuditForm";
	}


	/**
	 * 审核客户服务
	 */
	@RequiresPermissions(value="scm:scmSuppot:audit")
	@RequestMapping(value = "auditSave")
	public String auditSave(ScmSuppot scmSuppot, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmSuppot)){
			return form(scmSuppot, model);
		}
		
		try{
		
			ScmSuppot t = scmSuppotService.get(scmSuppot.getId());//从数据库取出记录的值
			MyBeanUtils.copyBeanNotNull2Bean(scmSuppot, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			
			t.setStatus("1");
			t.setAuditBy(UserUtils.getUser());
			t.setAuditDate(new Date());
			scmSuppotService.save(t);//保存
			
			addMessage(redirectAttributes, "审核客户服务成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审核客户服务失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmSuppot/?repage";
		}
	}
}