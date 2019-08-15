package com.javafast.modules.sys.web;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 动态Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysDynamic")
public class SysDynamicController extends BaseController {

	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public SysDynamic get(@RequestParam(required=false) String id) {
		SysDynamic entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysDynamicService.get(id);
		}
		if (entity == null){
			entity = new SysDynamic();
		}
		return entity;
	}
	
	/**
	 * 动态列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysDynamic> page = sysDynamicService.findPage(new Page<SysDynamic>(request, response), sysDynamic); 
		model.addAttribute("page", page);
		return "modules/sys/sysDynamicList";
	}

	/**
	 * 查看，增加，编辑动态表单页面
	 */
	@RequiresPermissions(value={"sys:sysDynamic:view","sys:sysDynamic:add","sys:sysDynamic:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(SysDynamic sysDynamic, Model model) {
		model.addAttribute("sysDynamic", sysDynamic);
		return "modules/sys/sysDynamicForm";
	}

	/**
	 * 保存动态
	 */
	@RequiresPermissions(value={"sys:sysDynamic:add","sys:sysDynamic:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(SysDynamic sysDynamic, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysDynamic)){
			return form(sysDynamic, model);
		}
		
		try{
		
			if(!sysDynamic.getIsNewRecord()){//编辑表单保存				
				SysDynamic t = sysDynamicService.get(sysDynamic.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysDynamic, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysDynamicService.save(t);//保存
			}else{//新增表单保存
				sysDynamicService.save(sysDynamic);//保存
			}
			addMessage(redirectAttributes, "保存动态成功");
			return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存动态失败");
			return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
		}
	}
	
	/**
	 * 删除动态
	 */
	@RequiresPermissions("sys:sysDynamic:del")
	@RequestMapping(value = "delete")
	public String delete(SysDynamic sysDynamic, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/sysDynamic/?repage";
		}
		sysDynamicService.delete(sysDynamic);
		addMessage(redirectAttributes, "删除动态成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
	}
	
	/**
	 * 批量删除动态
	 */
	@RequiresPermissions("sys:sysDynamic:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/sysDynamic/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			sysDynamicService.delete(sysDynamicService.get(id));
		}
		addMessage(redirectAttributes, "删除动态成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("sys:sysDynamic:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "动态"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<SysDynamic> page = sysDynamicService.findPage(new Page<SysDynamic>(request, response, -1), sysDynamic);
    		new ExportExcel("动态", SysDynamic.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出动态记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("sys:sysDynamic:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<SysDynamic> list = ei.getDataList(SysDynamic.class);
			for (SysDynamic sysDynamic : list){
				try{
					sysDynamicService.save(sysDynamic);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条动态记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条动态记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入动态失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
    }
	
	/**
	 * 下载导入动态数据模板
	 */
	@RequiresPermissions("sys:sysDynamic:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "动态数据导入模板.xlsx";
    		List<SysDynamic> list = Lists.newArrayList(); 
    		new ExportExcel("动态数据", SysDynamic.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysDynamic/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(sysDynamic, request, response, model);
        return "modules/sys/sysDynamic/sysDynamicSelectList";
	}
	
	

}