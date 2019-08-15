/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.web.ui;

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
import com.javafast.modules.sys.entity.Office;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.test.entity.ui.TestUielement;
import com.javafast.modules.test.service.ui.TestUielementService;

/**
 * UI标签Controller
 * @author javafast
 * @version 2017-08-22
 */
@Controller
@RequestMapping(value = "${adminPath}/test/ui/testUielement")
public class TestUielementController extends BaseController {

	@Autowired
	private TestUielementService testUielementService;
	
	@ModelAttribute
	public TestUielement get(@RequestParam(required=false) String id) {
		TestUielement entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testUielementService.get(id);
		}
		if (entity == null){
			entity = new TestUielement();
		}
		return entity;
	}
	
	/**
	 * UI标签列表页面
	 */
	@RequiresPermissions("test:ui:testUielement:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestUielement testUielement, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestUielement> page = testUielementService.findPage(new Page<TestUielement>(request, response), testUielement); 
		model.addAttribute("page", page);
		return "modules/test/ui/testUielementList";
	}

	/**
	 * 编辑UI标签表单页面
	 */
	@RequiresPermissions(value={"test:ui:testUielement:view","test:ui:testUielement:add","test:ui:testUielement:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestUielement testUielement, Model model) {
		model.addAttribute("testUielement", testUielement);
		return "modules/test/ui/testUielementForm";
	}
	
	/**
	 * 查看UI标签页面
	 */
	@RequiresPermissions(value="test:ui:testUielement:view")
	@RequestMapping(value = "view")
	public String view(TestUielement testUielement, Model model) {
		model.addAttribute("testUielement", testUielement);
		return "modules/test/ui/testUielementView";
	}

	/**
	 * 保存UI标签
	 */
	@RequiresPermissions(value={"test:ui:testUielement:add","test:ui:testUielement:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestUielement testUielement, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testUielement)){
			return form(testUielement, model);
		}
		
		try{
		
			if(!testUielement.getIsNewRecord()){//编辑表单保存				
				TestUielement t = testUielementService.get(testUielement.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testUielement, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testUielementService.save(t);//保存
			}else{//新增表单保存
				testUielementService.save(testUielement);//保存
			}
			addMessage(redirectAttributes, "保存UI标签成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存UI标签失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
		}
	}
	
	/**
	 * 删除UI标签
	 */
	@RequiresPermissions("test:ui:testUielement:del")
	@RequestMapping(value = "delete")
	public String delete(TestUielement testUielement, RedirectAttributes redirectAttributes) {
		testUielementService.delete(testUielement);
		addMessage(redirectAttributes, "删除UI标签成功");
		return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
	}
	
	/**
	 * 批量删除UI标签
	 */
	@RequiresPermissions("test:ui:testUielement:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testUielementService.delete(testUielementService.get(id));
		}
		addMessage(redirectAttributes, "删除UI标签成功");
		return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:ui:testUielement:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestUielement testUielement, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "UI标签"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestUielement> page = testUielementService.findPage(new Page<TestUielement>(request, response, -1), testUielement);
    		new ExportExcel("UI标签", TestUielement.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出UI标签记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:ui:testUielement:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestUielement> list = ei.getDataList(TestUielement.class);
			for (TestUielement testUielement : list){
				try{
					testUielementService.save(testUielement);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条UI标签记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条UI标签记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入UI标签失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
    }
	
	/**
	 * 下载导入UI标签数据模板
	 */
	@RequiresPermissions("test:ui:testUielement:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "UI标签数据导入模板.xlsx";
    		List<TestUielement> list = Lists.newArrayList(); 
    		new ExportExcel("UI标签数据", TestUielement.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/ui/testUielement/?repage";
    }
	
	/**
	 * UI标签列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestUielement testUielement, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testUielement, request, response, model);
        return "modules/test/ui/testUielementSelectList";
	}
	
}