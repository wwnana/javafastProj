package com.javafast.modules.hr.web;

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
import com.javafast.modules.hr.entity.HrTemplate;
import com.javafast.modules.hr.service.HrTemplateService;

/**
 * 模板Controller
 * @author javafast
 * @version 2018-07-03
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrTemplate")
public class HrTemplateController extends BaseController {

	@Autowired
	private HrTemplateService hrTemplateService;
	
	@ModelAttribute
	public HrTemplate get(@RequestParam(required=false) String id) {
		HrTemplate entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrTemplateService.get(id);
		}
		if (entity == null){
			entity = new HrTemplate();
		}
		return entity;
	}
	
	/**
	 * 模板列表页面
	 */
	@RequiresPermissions("hr:hrResume:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrTemplate hrTemplate, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrTemplate> page = hrTemplateService.findPage(new Page<HrTemplate>(request, response), hrTemplate); 
		model.addAttribute("page", page);
		return "modules/hr/hrTemplateList";
	}

	/**
	 * 编辑模板表单页面
	 */
	@RequiresPermissions(value={"hr:hrResume:view","hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrTemplate hrTemplate, Model model) {
		model.addAttribute("hrTemplate", hrTemplate);
		return "modules/hr/hrTemplateForm";
	}
	
	/**
	 * 查看模板页面
	 */
	@RequiresPermissions(value="hr:hrResume:view")
	@RequestMapping(value = "view")
	public String view(HrTemplate hrTemplate, Model model) {
		model.addAttribute("hrTemplate", hrTemplate);
		return "modules/hr/hrTemplateView";
	}

	/**
	 * 保存模板
	 */
	@RequiresPermissions(value={"hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrTemplate hrTemplate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrTemplate)){
			return form(hrTemplate, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
		}
		
		try{
		
			if(!hrTemplate.getIsNewRecord()){//编辑表单保存				
				HrTemplate t = hrTemplateService.get(hrTemplate.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrTemplate, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrTemplateService.save(t);//保存
			}else{//新增表单保存
				hrTemplateService.save(hrTemplate);//保存
			}
			addMessage(redirectAttributes, "保存模板成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存模板失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
		}
	}
	
	/**
	 * 删除模板
	 */
	@RequiresPermissions("hr:hrResume:del")
	@RequestMapping(value = "delete")
	public String delete(HrTemplate hrTemplate, RedirectAttributes redirectAttributes) {
		hrTemplateService.delete(hrTemplate);
		addMessage(redirectAttributes, "删除模板成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
	}
	
	/**
	 * 批量删除模板
	 */
	@RequiresPermissions("hr:hrResume:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrTemplateService.delete(hrTemplateService.get(id));
		}
		addMessage(redirectAttributes, "删除模板成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrResume:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrTemplate hrTemplate, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "模板"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrTemplate> page = hrTemplateService.findPage(new Page<HrTemplate>(request, response, -1), hrTemplate);
    		new ExportExcel("模板", HrTemplate.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出模板记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrResume:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrTemplate> list = ei.getDataList(HrTemplate.class);
			for (HrTemplate hrTemplate : list){
				try{
					hrTemplateService.save(hrTemplate);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条模板记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条模板记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
    }
	
	/**
	 * 下载导入模板数据模板
	 */
	@RequiresPermissions("hr:hrResume:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "模板数据导入模板.xlsx";
    		List<HrTemplate> list = Lists.newArrayList(); 
    		new ExportExcel("模板数据", HrTemplate.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrTemplate/?repage";
    }
	
	/**
	 * 模板列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrTemplate hrTemplate, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrTemplate, request, response, model);
        return "modules/hr/hrTemplateSelectList";
	}
	
}