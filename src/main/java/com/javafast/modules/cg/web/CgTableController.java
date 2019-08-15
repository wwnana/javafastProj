/**
 * Copyright &copy; 2015-2020 <a href="http://www.javafast.cn/">javafast</a> All rights reserved.
 */
package com.javafast.modules.cg.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.commons.io.IOUtils;
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
import java.util.List;
import com.google.common.collect.Lists;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.cg.entity.CgTable;
import com.javafast.modules.cg.service.CgTableService;
import com.javafast.modules.cg.util.CodeGenerationUtils;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.service.MenuService;

/**
 * 表单设计Controller
 * @author javafast
 * @version 2018-04-21
 */
@Controller
@RequestMapping(value = "${adminPath}/cg/cgTable")
public class CgTableController extends BaseController {

	@Autowired
	private CgTableService cgTableService;
	
	@Autowired
	private MenuService menuService;
	
	@ModelAttribute
	public CgTable get(@RequestParam(required=false) String id) {
		CgTable entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = cgTableService.get(id);
		}
		if (entity == null){
			entity = new CgTable();
		}
		return entity;
	}
	
	/**
	 * 表单设计列表页面
	 */
	@RequiresPermissions("cg:cgTable:list")
	@RequestMapping(value = {"list", ""})
	public String list(CgTable cgTable, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CgTable> page = cgTableService.findPage(new Page<CgTable>(request, response), cgTable); 
		model.addAttribute("page", page);
		return "modules/cg/cgTableList";
	}

	/**
	 * 编辑表单设计表单页面
	 */
	@RequiresPermissions(value={"cg:cgTable:view","cg:cgTable:add","cg:cgTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CgTable cgTable, Model model) {
		
		// 获取物理表列表
		List<CgTable> tableList = cgTableService.findTableListFormDb(new CgTable());
		model.addAttribute("tableList", tableList);
		// 验证表是否存在
		if (StringUtils.isBlank(cgTable.getId()) && !cgTableService.checkTableName(cgTable.getName())){
			addMessage(model, "下一步失败！" + cgTable.getName() + " 表已经添加！");
			cgTable.setName("");
		}
		// 获取物理表字段
		else{
			cgTable = cgTableService.getTableFormDb(cgTable);
		}
				
		model.addAttribute("cgTable", cgTable);
		model.addAttribute("config", CodeGenerationUtils.getConfig());
		return "modules/cg/cgTableForm";
	}
	
	/**
	 * 查看表单设计页面
	 */
	@RequiresPermissions(value="cg:cgTable:view")
	@RequestMapping(value = "view")
	public String view(CgTable cgTable, Model model) {
		model.addAttribute("cgTable", cgTable);
		return "modules/cg/cgTableView";
	}

	/**
	 * 保存表单设计
	 */
	@RequiresPermissions(value={"cg:cgTable:add","cg:cgTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CgTable cgTable, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, cgTable)){
			return form(cgTable, model);
		}
		
		try{
		
			if(!cgTable.getIsNewRecord()){//编辑表单保存				
				CgTable t = cgTableService.get(cgTable.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(cgTable, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				cgTableService.save(t);//保存
			}else{//新增表单保存
				cgTableService.save(cgTable);//保存
			}
			
			// 验证表是否已经存在
			if (StringUtils.isBlank(cgTable.getId()) && !cgTableService.checkTableName(cgTable.getName())){
				addMessage(model, "保存失败！" + cgTable.getName() + " 表已经存在！");
				cgTable.setName("");
				return form(cgTable, model);
			}
			
			addMessage(redirectAttributes, "保存表单设计成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存表单设计失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/cg/cgTable/?repage";
		}
	}
	
	/**
	 * 删除表单设计
	 */
	@RequiresPermissions("cg:cgTable:del")
	@RequestMapping(value = "delete")
	public String delete(CgTable cgTable, RedirectAttributes redirectAttributes) {
		cgTableService.delete(cgTable);
		addMessage(redirectAttributes, "删除表单设计成功");
		return "redirect:"+Global.getAdminPath()+"/cg/cgTable/?repage";
	}
	
	/**
	 * 批量删除表单设计
	 */
	@RequiresPermissions("cg:cgTable:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			cgTableService.delete(cgTableService.get(id));
		}
		addMessage(redirectAttributes, "删除表单设计成功");
		return "redirect:"+Global.getAdminPath()+"/cg/cgTable/?repage";
	}
	
	/**
	 * 表单设计列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CgTable cgTable, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(cgTable, request, response, model);
        return "modules/cg/cgTableSelectList";
	}
	
	@RequiresPermissions(value={"cg:cgTable:view","cg:cgTable:add","cg:cgTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "importByDBForm")
	public String importByDBForm(CgTable cgTable, Model model) {
		
		// 获取物理表列表
		List<CgTable> tableList = cgTableService.findTableListFormDb(new CgTable());
		model.addAttribute("tableList", tableList);
		// 验证表是否存在
		if (StringUtils.isBlank(cgTable.getId()) && !cgTableService.checkTableName(cgTable.getName())){
			addMessage(model, "下一步失败！" + cgTable.getName() + " 表已经添加！");
			cgTable.setName("");
		}
		// 获取物理表字段
		else{
			cgTable = cgTableService.getTableFormDb(cgTable);
		}
		
		if (StringUtils.isBlank(cgTable.getPackageName())){
			cgTable.setPackageName("com.javafast.modules");
		}
		
		model.addAttribute("cgTable", cgTable);
		model.addAttribute("config", CodeGenerationUtils.getConfig());
		return "modules/cg/importTableByDBForm";
	}
	
	/**
	 * 保存表单设计
	 */
	@RequiresPermissions(value={"cg:cgTable:add","cg:cgTable:edit"},logical=Logical.OR)
	@RequestMapping(value = "ImportByDBSave")
	public String ImportByDBSave(CgTable cgTable, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, cgTable)){
			return form(cgTable, model);
		}
		
		try{
		
			if(!cgTable.getIsNewRecord()){//编辑表单保存				
				CgTable t = cgTableService.get(cgTable.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(cgTable, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				cgTableService.save(t);//保存
			}else{//新增表单保存
				cgTableService.save(cgTable);//保存
			}
			
			// 验证表是否已经存在
			if (StringUtils.isBlank(cgTable.getId()) && !cgTableService.checkTableName(cgTable.getName())){
				addMessage(model, "保存失败！" + cgTable.getName() + " 表已经存在！");
				cgTable.setName("");
				return form(cgTable, model);
			}
			
			// 生成代码
			if ("1".equals(cgTable.getFlag())){
				
				//
				String result = cgTableService.generateCode(cgTable);
				
				addMessage(redirectAttributes, "生成代码成功");
			}else{
				
				addMessage(redirectAttributes, "保存表单设计成功");
			}
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存表单设计失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/cg/cgTable/?repage";
		}
	}
	
	/**
	 * 生成菜单页面
	 * @param gen_table_id
	 * @param menu
	 * @param model
	 * @return
	 */
	@RequiresPermissions("cg:cgTable:edit")
	@RequestMapping(value = "menuForm")
	public String menuForm(String cgTableId, Menu menu, Model model) {
		
		if ((menu.getParent() == null) || (menu.getParent().getId() == null)) {
			menu.setParent(new Menu(Menu.getRootId()));
		}
		String menuId=menu.getParent().getId();
		Menu rootMenu=this.menuService.get(menuId);
		menu.setParent(rootMenu);

		if (StringUtils.isBlank(menu.getId())) {
			List list = (List) Lists.newArrayList();
			List sourcelist = this.menuService.findAllMenu();
			Menu.sortList(list, sourcelist, menu.getParentId(), false);
			if (list.size() > 0)
				menu.setSort(Integer.valueOf(((Menu) list.get(list.size() - 1)).getSort().intValue() + 30));
		}
		CgTable table = cgTableService.get(cgTableId);
		menu.setName(table.getFunctionName());

		model.addAttribute("menu", menu);
		model.addAttribute("cgTableId", cgTableId);
		return "modules/gen/genMenuForm";
	}

	/**
	 * 生成菜单
	 * @param gen_table_id
	 * @param menu
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "createMenu")
	public String createMenu(Menu menu, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		
		String cgTableId = request.getParameter("cgTableId");
				
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/cg/cgTable/?repage";
		}
		
		CgTable table = cgTableService.get(cgTableId);
		menu.setName(table.getFunctionName());
		
		this.cgTableService.createMenu(table, menu);
		addMessage(redirectAttributes, new String[] { "创建菜单'" + table.getFunctionName() + "'成功<br/>" });
		return "redirect:" + this.adminPath + "/cg/cgTable/?repage";
	}
	
	/**
	 * 生成代码并压缩打包
	 * @param cgTable
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "createCodeRar")
	public void createCodeRar(CgTable cgTable, Model model,HttpServletRequest request, HttpServletResponse response) {
		if (!beanValidator(model, cgTable)) {
			
		}
		
		try {
			
			//立即生成代码
			cgTable.setFlag("1");
			//生成代码并打包RAR下载
			byte[] data =cgTableService.generatorCode(cgTable);
			if(data != null){
				
				response.reset();  
		        response.setHeader("Content-Disposition", "attachment; filename=\"code.zip\"");  
		        response.addHeader("Content-Length", "" + data.length);  
		        response.setContentType("application/octet-stream; charset=UTF-8");
				IOUtils.write(data, response.getOutputStream());
			}			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}