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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.scm.entity.ScmProblem;
import com.javafast.modules.scm.service.ScmProblemService;
import com.javafast.modules.scm.service.ScmProblemTypeService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 常见问题Controller
 * @author javafast
 * @version 2017-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/scm/scmProblem")
public class ScmProblemController extends BaseController {

	@Autowired
	private ScmProblemService scmProblemService;
	
	@Autowired
	private ScmProblemTypeService scmProblemTypeService;
	
	@ModelAttribute
	public ScmProblem get(@RequestParam(required=false) String id) {
		ScmProblem entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmProblemService.get(id);
		}
		if (entity == null){
			entity = new ScmProblem();
		}
		return entity;
	}
	
	/**
	 * 常见问题列表页面（左树右表）
	 */
	@RequiresPermissions("scm:scmProblem:list")
	@RequestMapping(value = "index")
	public String index(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/scm/scmProblemIndex";
	}
	
	/**
	 * 常见问题列表页面
	 */
	@RequiresPermissions("scm:scmProblem:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, Model model) {
		if(StringUtils.isBlank(scmProblem.getStatus())){
			scmProblem.setStatus("1");
		}else{
			if("0".equals(scmProblem.getStatus())){
				scmProblem.setCreateBy(UserUtils.getUser());
			}
		}
		
		Page<ScmProblem> page = scmProblemService.findPage(new Page<ScmProblem>(request, response), scmProblem); 
		model.addAttribute("page", page);
		return "modules/scm/scmProblemList";
	}

	/**
	 * 编辑常见问题表单页面
	 */
	@RequiresPermissions(value={"scm:scmProblem:view","scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmProblem scmProblem, Model model) {
		
		if(scmProblem.getIsNewRecord()){
			if(scmProblem.getScmProblemType()!=null && scmProblem.getScmProblemType().getId()!=null)
				scmProblem.setScmProblemType(scmProblemTypeService.get(scmProblem.getScmProblemType().getId()));
		}
		
		model.addAttribute("scmProblem", scmProblem);
		return "modules/scm/scmProblemForm";
	}
	
	/**
	 * 查看常见问题页面
	 */
	@RequiresPermissions(value="scm:scmProblem:view")
	@RequestMapping(value = "view")
	public String view(ScmProblem scmProblem, Model model) {
		model.addAttribute("scmProblem", scmProblem);
		return "modules/scm/scmProblemView";
	}

	/**
	 * 保存常见问题
	 */
	@RequiresPermissions(value={"scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmProblem scmProblem, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmProblem)){
			return form(scmProblem, model);
		}
		
		try{
		
			if(!scmProblem.getIsNewRecord()){//编辑表单保存				
				ScmProblem t = scmProblemService.get(scmProblem.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmProblem, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmProblemService.save(t);//保存
			}else{//新增表单保存
				scmProblemService.save(scmProblem);//保存
			}
			addMessage(redirectAttributes, "保存常见问题成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存常见问题失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
		}
	}
	
	/**
	 * 删除常见问题
	 */
	@RequiresPermissions("scm:scmProblem:del")
	@RequestMapping(value = "delete")
	public String delete(ScmProblem scmProblem, RedirectAttributes redirectAttributes) {
		scmProblemService.delete(scmProblem);
		addMessage(redirectAttributes, "删除常见问题成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
	}
	
	/**
	 * 批量删除常见问题
	 */
	@RequiresPermissions("scm:scmProblem:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			scmProblemService.delete(scmProblemService.get(id));
		}
		addMessage(redirectAttributes, "删除常见问题成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("scm:scmProblem:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "常见问题"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ScmProblem> page = scmProblemService.findPage(new Page<ScmProblem>(request, response, -1), scmProblem);
    		new ExportExcel("常见问题", ScmProblem.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出常见问题记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("scm:scmProblem:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<ScmProblem> list = ei.getDataList(ScmProblem.class);
			for (ScmProblem scmProblem : list){
				try{
					scmProblemService.save(scmProblem);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条常见问题记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条常见问题记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入常见问题失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
    }
	
	/**
	 * 下载导入常见问题数据模板
	 */
	@RequiresPermissions("scm:scmProblem:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "常见问题数据导入模板.xlsx";
    		List<ScmProblem> list = Lists.newArrayList(); 
    		new ExportExcel("常见问题数据", ScmProblem.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblem/?repage";
    }
	
	/**
	 * 常见问题列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(scmProblem, request, response, model);
        return "modules/scm/scmProblemSelectList";
	}
	
}