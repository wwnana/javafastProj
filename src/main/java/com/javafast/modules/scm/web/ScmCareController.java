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
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.scm.entity.ScmCare;
import com.javafast.modules.scm.service.ScmCareService;

/**
 * 客户关怀Controller
 * @author javafast
 * @version 2017-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/scm/scmCare")
public class ScmCareController extends BaseController {

	@Autowired
	private ScmCareService scmCareService;
	
	@ModelAttribute
	public ScmCare get(@RequestParam(required=false) String id) {
		ScmCare entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmCareService.get(id);
		}
		if (entity == null){
			entity = new ScmCare();
		}
		return entity;
	}
	
	/**
	 * 客户关怀列表页面
	 */
	@RequiresPermissions("scm:scmCare:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmCare scmCare, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScmCare> page = scmCareService.findPage(new Page<ScmCare>(request, response), scmCare); 
		model.addAttribute("page", page);
		return "modules/scm/scmCareList";
	}

	/**
	 * 编辑客户关怀表单页面
	 */
	@RequiresPermissions(value={"scm:scmCare:view","scm:scmCare:add","scm:scmCare:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmCare scmCare, Model model) {
		
		if(scmCare.getIsNewRecord()){
			scmCare.setOwnBy(UserUtils.getUser());
			scmCare.setCareDate(new Date());
		}
		
		model.addAttribute("scmCare", scmCare);
		return "modules/scm/scmCareForm";
	}
	
	/**
	 * 查看客户关怀页面
	 */
	@RequiresPermissions(value="scm:scmCare:view")
	@RequestMapping(value = "view")
	public String view(ScmCare scmCare, Model model) {
		model.addAttribute("scmCare", scmCare);
		return "modules/scm/scmCareView";
	}

	/**
	 * 保存客户关怀
	 */
	@RequiresPermissions(value={"scm:scmCare:add","scm:scmCare:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmCare scmCare, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmCare)){
			return form(scmCare, model);
		}
		
		try{
		
			if(!scmCare.getIsNewRecord()){//编辑表单保存				
				ScmCare t = scmCareService.get(scmCare.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmCare, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmCareService.save(t);//保存
			}else{//新增表单保存
				scmCareService.save(scmCare);//保存
			}
			addMessage(redirectAttributes, "保存客户关怀成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户关怀失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
		}
	}
	
	/**
	 * 删除客户关怀
	 */
	@RequiresPermissions("scm:scmCare:del")
	@RequestMapping(value = "delete")
	public String delete(ScmCare scmCare, RedirectAttributes redirectAttributes) {
		scmCareService.delete(scmCare);
		addMessage(redirectAttributes, "删除客户关怀成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
	}
	
	/**
	 * 批量删除客户关怀
	 */
	@RequiresPermissions("scm:scmCare:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scmCareService.delete(scmCareService.get(id));
		}
		addMessage(redirectAttributes, "删除客户关怀成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("scm:scmCare:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(ScmCare scmCare, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户关怀"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScmCare> page = scmCareService.findPage(new Page<ScmCare>(request, response, -1), scmCare);
    		new ExportExcel("客户关怀", ScmCare.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户关怀记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("scm:scmCare:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScmCare> list = ei.getDataList(ScmCare.class);
			for (ScmCare scmCare : list){
				try{
					scmCareService.save(scmCare);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户关怀记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户关怀记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户关怀失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
    }
	
	/**
	 * 下载导入客户关怀数据模板
	 */
	@RequiresPermissions("scm:scmCare:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户关怀数据导入模板.xlsx";
    		List<ScmCare> list = Lists.newArrayList(); 
    		new ExportExcel("客户关怀数据", ScmCare.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmCare/?repage";
    }
	
	/**
	 * 客户关怀列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(ScmCare scmCare, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(scmCare, request, response, model);
        return "modules/scm/scmCareSelectList";
	}
	
}