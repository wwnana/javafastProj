/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.web.onetomany;

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

import java.math.BigDecimal;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.test.entity.onetomany.TestDataChild;
import com.javafast.modules.test.entity.onetomany.TestDataMain;
import com.javafast.modules.test.service.onetomany.TestDataMainService;

/**
 * 订单信息Controller
 * @author javafast
 * @version 2017-07-16
 */
@Controller
@RequestMapping(value = "${adminPath}/test/onetomany/testDataMain")
public class TestDataMainController extends BaseController {

	@Autowired
	private TestDataMainService testDataMainService;
	
	@ModelAttribute
	public TestDataMain get(@RequestParam(required=false) String id) {
		TestDataMain entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testDataMainService.get(id);
		}
		if (entity == null){
			entity = new TestDataMain();
		}
		return entity;
	}
	
	/**
	 * 订单信息列表页面
	 */
	@RequiresPermissions("test:onetomany:testDataMain:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestDataMain testDataMain, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestDataMain> page = testDataMainService.findPage(new Page<TestDataMain>(request, response), testDataMain); 
		model.addAttribute("page", page);
		return "modules/test/onetomany/testDataMainList";
	}

	/**
	 * 编辑订单信息订单信息表单页面
	 */
	@RequiresPermissions(value={"test:onetomany:testDataMain:view","test:onetomany:testDataMain:add","test:onetomany:testDataMain:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestDataMain testDataMain, Model model) {
		
		if(testDataMain.getIsNewRecord()){
			testDataMain.setNo("DD"+IdUtils.getId());
			testDataMain.setDealBy(UserUtils.getUser());
			testDataMain.setDealDate(new Date());
			testDataMain.setStatus("0");
		}
		model.addAttribute("testDataMain", testDataMain);
		return "modules/test/onetomany/testDataMainForm";
	}
	
	/**
	 * 查看订单信息页面
	 */
	@RequiresPermissions(value="test:onetomany:testDataMain:view")
	@RequestMapping(value = "view")
	public String view(TestDataMain testDataMain, Model model) {
		model.addAttribute("testDataMain", testDataMain);
		return "modules/test/onetomany/testDataMainView";
	}

	/**
	 * 保存订单信息
	 */
	@RequiresPermissions(value={"test:onetomany:testDataMain:add","test:onetomany:testDataMain:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestDataMain testDataMain, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testDataMain)){
			return form(testDataMain, model);
		}
		
		try{
		
			if(!testDataMain.getIsNewRecord()){//编辑表单保存				
				TestDataMain t = testDataMainService.get(testDataMain.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testDataMain, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testDataMainService.save(t);//保存
			}else{//新增表单保存
				testDataMainService.save(testDataMain);//保存
			}
			addMessage(redirectAttributes, "保存订单信息成功");
			return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存订单信息失败");
			return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
		}
	}
	
	/**
	 * 删除订单信息
	 */
	@RequiresPermissions("test:onetomany:testDataMain:del")
	@RequestMapping(value = "delete")
	public String delete(TestDataMain testDataMain, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
		}
		testDataMainService.delete(testDataMain);
		addMessage(redirectAttributes, "删除订单信息成功");
		return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
	}
	
	/**
	 * 批量删除订单信息
	 */
	@RequiresPermissions("test:onetomany:testDataMain:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testDataMainService.delete(testDataMainService.get(id));
		}
		addMessage(redirectAttributes, "删除订单信息成功");
		return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:onetomany:testDataMain:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestDataMain testDataMain, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "订单信息"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestDataMain> page = testDataMainService.findPage(new Page<TestDataMain>(request, response, -1), testDataMain);
    		new ExportExcel("订单信息", TestDataMain.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出订单信息记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:onetomany:testDataMain:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestDataMain> list = ei.getDataList(TestDataMain.class);
			for (TestDataMain testDataMain : list){
				try{
					testDataMainService.save(testDataMain);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条订单信息记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条订单信息记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入订单信息失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
    }
	
	/**
	 * 下载导入订单信息数据模板
	 */
	@RequiresPermissions("test:onetomany:testDataMain:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "订单信息数据导入模板.xlsx";
    		List<TestDataMain> list = Lists.newArrayList(); 
    		new ExportExcel("订单信息数据", TestDataMain.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/onetomany/testDataMain/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestDataMain testDataMain, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testDataMain, request, response, model);
        return "modules/testDataMainSelectList";
	}
	
	

}