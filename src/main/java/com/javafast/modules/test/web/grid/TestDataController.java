/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.web.grid;

import java.text.SimpleDateFormat;
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

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.test.entity.grid.TestData;
import com.javafast.modules.test.service.grid.TestDataService;

/**
 * 业务数据Controller
 * @author javafast
 * @version 2017-07-21
 */
@Controller
@RequestMapping(value = "${adminPath}/test/grid/testData")
public class TestDataController extends BaseController {

	@Autowired
	private TestDataService testDataService;
	
	@ModelAttribute
	public TestData get(@RequestParam(required=false) String id) {
		TestData entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testDataService.get(id);
		}
		if (entity == null){
			entity = new TestData();
		}
		return entity;
	}
	
	/**
	 * 业务数据列表页面
	 */
	@RequiresPermissions("test:grid:testData:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestData testData, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//开始计时
		long beginTime = System.currentTimeMillis();//1、开始时间  
		String beginTimeStr = new SimpleDateFormat("hh:mm:ss.SSS").format(beginTime);
		
		Page<TestData> page = testDataService.findPage(new Page<TestData>(request, response), testData); 
		model.addAttribute("page", page);
		
		//结束计时
		long endTime = System.currentTimeMillis(); 	//2、结束时间  
		String endTimeStr = new SimpleDateFormat("hh:mm:ss.SSS").format(endTime);
		
		//计算耗时
		String useTimeStr = DateUtils.formatDateTime(endTime - beginTime);		
		
		//显示到页面
		String timeResult = "数据大小："+page.getCount()+"，计时开始："+beginTimeStr+"，计时结束："+endTimeStr+"，耗时："+useTimeStr+"(毫秒)";
		model.addAttribute("timeResult", timeResult);
		
		return "modules/test/grid/testDataList";
	}

	/**
	 * 编辑业务数据业务数据表单页面
	 */
	@RequiresPermissions(value={"test:grid:testData:view","test:grid:testData:add","test:grid:testData:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestData testData, Model model) {
		model.addAttribute("testData", testData);
		return "modules/test/grid/testDataForm";
	}
	
	/**
	 * 查看业务数据页面
	 */
	@RequiresPermissions(value="test:grid:testData:view")
	@RequestMapping(value = "view")
	public String view(TestData testData, Model model) {
		model.addAttribute("testData", testData);
		return "modules/test/grid/testDataView";
	}

	/**
	 * 保存业务数据
	 */
	@RequiresPermissions(value={"test:grid:testData:add","test:grid:testData:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestData testData, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testData)){
			return form(testData, model);
		}
		
		try{
		
			if(!testData.getIsNewRecord()){//编辑表单保存				
				TestData t = testDataService.get(testData.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testData, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testDataService.save(t);//保存
			}else{//新增表单保存
				testDataService.save(testData);//保存
			}
			addMessage(redirectAttributes, "保存业务数据成功");
			return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存业务数据失败");
			return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
		}
	}
	
	/**
	 * 删除业务数据
	 */
	@RequiresPermissions("test:grid:testData:del")
	@RequestMapping(value = "delete")
	public String delete(TestData testData, RedirectAttributes redirectAttributes) {
		testDataService.delete(testData);
		addMessage(redirectAttributes, "删除业务数据成功");
		return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
	}
	
	/**
	 * 批量删除业务数据
	 */
	@RequiresPermissions("test:grid:testData:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testDataService.delete(testDataService.get(id));
		}
		addMessage(redirectAttributes, "删除业务数据成功");
		return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:grid:testData:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestData testData, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "业务数据"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestData> page = testDataService.findPage(new Page<TestData>(request, response, -1), testData);
    		new ExportExcel("业务数据", TestData.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出业务数据记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:grid:testData:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestData> list = ei.getDataList(TestData.class);
			for (TestData testData : list){
				try{
					testDataService.save(testData);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条业务数据记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条业务数据记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入业务数据失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
    }
	
	/**
	 * 下载导入业务数据数据模板
	 */
	@RequiresPermissions("test:grid:testData:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "业务数据数据导入模板.xlsx";
    		List<TestData> list = Lists.newArrayList(); 
    		new ExportExcel("业务数据数据", TestData.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/grid/testData/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestData testData, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testData, request, response, model);
        return "modules/test/grid/testDataSelectList";
	}
	
	
}