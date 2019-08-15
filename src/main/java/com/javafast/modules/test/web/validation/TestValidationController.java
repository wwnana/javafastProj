package com.javafast.modules.test.web.validation;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.test.entity.validation.TestValidation;
import com.javafast.modules.test.service.validation.TestValidationService;

/**
 * 校验测试表单Controller
 * @author javafast
 * @version 2018-07-18
 */
@Controller
@RequestMapping(value = "${adminPath}/test/validation/testValidation")
public class TestValidationController extends BaseController {

	@Autowired
	private TestValidationService testValidationService;
	
	@ModelAttribute
	public TestValidation get(@RequestParam(required=false) String id) {
		TestValidation entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testValidationService.get(id);
		}
		if (entity == null){
			entity = new TestValidation();
		}
		return entity;
	}
	
	/**
	 * 校验测试表单列表页面
	 */
	@RequiresPermissions("test:validation:testValidation:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestValidation testValidation, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestValidation> page = testValidationService.findPage(new Page<TestValidation>(request, response), testValidation); 
		model.addAttribute("page", page);
		return "modules/test/validation/testValidationList";
	}

	/**
	 * 编辑校验测试表单表单页面
	 */
	@RequiresPermissions(value={"test:validation:testValidation:view","test:validation:testValidation:add","test:validation:testValidation:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestValidation testValidation, Model model) {
		model.addAttribute("testValidation", testValidation);
		return "modules/test/validation/testValidationForm";
	}
	
	/**
	 * 查看校验测试表单页面
	 */
	@RequiresPermissions(value="test:validation:testValidation:view")
	@RequestMapping(value = "view")
	public String view(TestValidation testValidation, Model model) {
		model.addAttribute("testValidation", testValidation);
		return "modules/test/validation/testValidationView";
	}

	/**
	 * 保存校验测试表单
	 */
	@RequiresPermissions(value={"test:validation:testValidation:add","test:validation:testValidation:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestValidation testValidation, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testValidation)){
			return form(testValidation, model);
		}
		
		try{
		
			if(!testValidation.getIsNewRecord()){//编辑表单保存				
				TestValidation t = testValidationService.get(testValidation.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testValidation, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testValidationService.save(t);//保存
			}else{//新增表单保存
				testValidationService.save(testValidation);//保存
			}
			addMessage(redirectAttributes, "保存校验测试表单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存校验测试表单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
		}
	}
	
	/**
	 * 删除校验测试表单
	 */
	@RequiresPermissions("test:validation:testValidation:del")
	@RequestMapping(value = "delete")
	public String delete(TestValidation testValidation, RedirectAttributes redirectAttributes) {
		testValidationService.delete(testValidation);
		addMessage(redirectAttributes, "删除校验测试表单成功");
		return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
	}
	
	/**
	 * 批量删除校验测试表单
	 */
	@RequiresPermissions("test:validation:testValidation:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testValidationService.delete(testValidationService.get(id));
		}
		addMessage(redirectAttributes, "删除校验测试表单成功");
		return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:validation:testValidation:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestValidation testValidation, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "校验测试表单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestValidation> page = testValidationService.findPage(new Page<TestValidation>(request, response, -1), testValidation);
    		new ExportExcel("校验测试表单", TestValidation.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出校验测试表单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:validation:testValidation:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestValidation> list = ei.getDataList(TestValidation.class);
			for (TestValidation testValidation : list){
				try{
					testValidationService.save(testValidation);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条校验测试表单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条校验测试表单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入校验测试表单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
    }
	
	/**
	 * 下载导入校验测试表单数据模板
	 */
	@RequiresPermissions("test:validation:testValidation:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "校验测试表单数据导入模板.xlsx";
    		List<TestValidation> list = Lists.newArrayList(); 
    		new ExportExcel("校验测试表单数据", TestValidation.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/validation/testValidation/?repage";
    }
	
	/**
	 * 校验测试表单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestValidation testValidation, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testValidation, request, response, model);
        return "modules/test/validation/testValidationSelectList";
	}
	
}