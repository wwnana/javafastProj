package com.javafast.modules.test.web.one;

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
import com.javafast.modules.test.entity.tree.TestTree;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.test.entity.one.TestOne;
import com.javafast.modules.test.service.one.TestOneService;

/**
 * 商品信息(单表)Controller
 * @author javafast
 * @version 2018-07-30
 */
@Controller
@RequestMapping(value = "${adminPath}/test/one/testOne")
public class TestOneController extends BaseController {

	@Autowired
	private TestOneService testOneService;
	
	@ModelAttribute
	public TestOne get(@RequestParam(required=false) String id) {
		TestOne entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testOneService.get(id);
		}
		if (entity == null){
			entity = new TestOne();
		}
		return entity;
	}
	
	@RequestMapping(value = "index")
	public String index(TestOne testOne, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/test/treelist/testOneIndex";
	}
	
	/**
	 * 商品信息(单表)列表页面
	 */
	@RequiresPermissions("test:one:testOne:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestOne testOne, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestOne> page = testOneService.findPage(new Page<TestOne>(request, response), testOne); 
		model.addAttribute("page", page);
		return "modules/test/one/testOneList";
	}

	/**
	 * 编辑商品信息(单表)表单页面
	 */
	@RequiresPermissions(value={"test:one:testOne:view","test:one:testOne:add","test:one:testOne:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestOne testOne, Model model) {
		model.addAttribute("testOne", testOne);
		return "modules/test/one/testOneForm";
	}
	
	/**
	 * 查看商品信息(单表)页面
	 */
	@RequiresPermissions(value="test:one:testOne:view")
	@RequestMapping(value = "view")
	public String view(TestOne testOne, Model model) {
		model.addAttribute("testOne", testOne);
		return "modules/test/one/testOneView";
	}

	/**
	 * 保存商品信息(单表)
	 */
	@RequiresPermissions(value={"test:one:testOne:add","test:one:testOne:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestOne testOne, Model model, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
		}
		if (!beanValidator(model, testOne)){
			return form(testOne, model);
		}
		
		try{
		
			if(!testOne.getIsNewRecord()){//编辑表单保存				
				TestOne t = testOneService.get(testOne.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testOne, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testOneService.save(t);//保存
			}else{//新增表单保存
				testOneService.save(testOne);//保存
			}
			addMessage(redirectAttributes, "保存商品信息(单表)成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存商品信息(单表)失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
		}
	}
	
	/**
	 * 删除商品信息(单表)
	 */
	@RequiresPermissions("test:one:testOne:del")
	@RequestMapping(value = "delete")
	public String delete(TestOne testOne, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
		}
		testOneService.delete(testOne);
		addMessage(redirectAttributes, "删除商品信息(单表)成功");
		return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
	}
	
	/**
	 * 批量删除商品信息(单表)
	 */
	@RequiresPermissions("test:one:testOne:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testOneService.delete(testOneService.get(id));
		}
		addMessage(redirectAttributes, "删除商品信息(单表)成功");
		return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:one:testOne:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestOne testOne, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "商品信息(单表)"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestOne> page = testOneService.findPage(new Page<TestOne>(request, response, -1), testOne);
    		new ExportExcel("商品信息(单表)", TestOne.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出商品信息(单表)记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:one:testOne:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestOne> list = ei.getDataList(TestOne.class);
			for (TestOne testOne : list){
				try{
					
					if(StringUtils.isNotBlank(testOne.getName())){
						testOneService.save(testOne);
						successNum++;
					}else{
						
						failureNum++;
					}					
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条商品信息(单表)记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条商品信息(单表)记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入商品信息(单表)失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
    }
	
	/**
	 * 下载导入商品信息(单表)数据模板
	 */
	@RequiresPermissions("test:one:testOne:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "商品信息(单表)数据导入模板.xlsx";
    		List<TestOne> list = Lists.newArrayList(); 
    		new ExportExcel("商品信息(单表)数据", TestOne.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/one/testOne/?repage";
    }
	
	/**
	 * 商品信息(单表)列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestOne testOne, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testOne, request, response, model);
        return "modules/test/one/testOneSelectList";
	}
	
}