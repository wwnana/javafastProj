package com.javafast.modules.test.web.note;

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
import com.javafast.modules.test.entity.note.TestNote;
import com.javafast.modules.test.service.note.TestNoteService;

/**
 * 富文本测试Controller
 * @author javafast
 * @version 2018-07-18
 */
@Controller
@RequestMapping(value = "${adminPath}/test/note/testNote")
public class TestNoteController extends BaseController {

	@Autowired
	private TestNoteService testNoteService;
	
	@ModelAttribute
	public TestNote get(@RequestParam(required=false) String id) {
		TestNote entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testNoteService.get(id);
		}
		if (entity == null){
			entity = new TestNote();
		}
		return entity;
	}
	
	/**
	 * 富文本测试列表页面
	 */
	@RequiresPermissions("test:note:testNote:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestNote testNote, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestNote> page = testNoteService.findPage(new Page<TestNote>(request, response), testNote); 
		model.addAttribute("page", page);
		return "modules/test/note/testNoteList";
	}

	/**
	 * 编辑富文本测试表单页面
	 */
	@RequiresPermissions(value={"test:note:testNote:view","test:note:testNote:add","test:note:testNote:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestNote testNote, Model model) {
		model.addAttribute("testNote", testNote);
		return "modules/test/note/testNoteForm";
	}
	
	/**
	 * 查看富文本测试页面
	 */
	@RequiresPermissions(value="test:note:testNote:view")
	@RequestMapping(value = "view")
	public String view(TestNote testNote, Model model) {
		model.addAttribute("testNote", testNote);
		return "modules/test/note/testNoteView";
	}

	/**
	 * 保存富文本测试
	 */
	@RequiresPermissions(value={"test:note:testNote:add","test:note:testNote:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestNote testNote, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, testNote)){
			return form(testNote, model);
		}
		
		try{
		
			if(!testNote.getIsNewRecord()){//编辑表单保存				
				TestNote t = testNoteService.get(testNote.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(testNote, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				testNoteService.save(t);//保存
			}else{//新增表单保存
				testNoteService.save(testNote);//保存
			}
			addMessage(redirectAttributes, "保存富文本测试成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存富文本测试失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
		}
	}
	
	/**
	 * 删除富文本测试
	 */
	@RequiresPermissions("test:note:testNote:del")
	@RequestMapping(value = "delete")
	public String delete(TestNote testNote, RedirectAttributes redirectAttributes) {
		testNoteService.delete(testNote);
		addMessage(redirectAttributes, "删除富文本测试成功");
		return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
	}
	
	/**
	 * 批量删除富文本测试
	 */
	@RequiresPermissions("test:note:testNote:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testNoteService.delete(testNoteService.get(id));
		}
		addMessage(redirectAttributes, "删除富文本测试成功");
		return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("test:note:testNote:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestNote testNote, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "富文本测试"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestNote> page = testNoteService.findPage(new Page<TestNote>(request, response, -1), testNote);
    		new ExportExcel("富文本测试", TestNote.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出富文本测试记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("test:note:testNote:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestNote> list = ei.getDataList(TestNote.class);
			for (TestNote testNote : list){
				try{
					testNoteService.save(testNote);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条富文本测试记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条富文本测试记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入富文本测试失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
    }
	
	/**
	 * 下载导入富文本测试数据模板
	 */
	@RequiresPermissions("test:note:testNote:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "富文本测试数据导入模板.xlsx";
    		List<TestNote> list = Lists.newArrayList(); 
    		new ExportExcel("富文本测试数据", TestNote.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/test/note/testNote/?repage";
    }
	
	/**
	 * 富文本测试列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(TestNote testNote, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(testNote, request, response, model);
        return "modules/test/note/testNoteSelectList";
	}
	
}