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
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.service.SysSmsService;

/**
 * 系统短信Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysSms")
public class SysSmsController extends BaseController {

	@Autowired
	private SysSmsService sysSmsService;
	
	@ModelAttribute
	public SysSms get(@RequestParam(required=false) String id) {
		SysSms entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysSmsService.get(id);
		}
		if (entity == null){
			entity = new SysSms();
		}
		return entity;
	}
	
	/**
	 * 系统短信列表页面
	 */
	@RequiresPermissions("sys:sysSms:list")
	@RequestMapping(value = {"list", ""})
	public String list(SysSms sysSms, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysSms> page = sysSmsService.findPage(new Page<SysSms>(request, response), sysSms); 
		model.addAttribute("page", page);
		return "modules/sys/sysSmsList";
	}

	/**
	 * 查看，增加，编辑系统短信表单页面
	 */
	@RequiresPermissions(value={"sys:sysSms:view","sys:sysSms:add","sys:sysSms:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(SysSms sysSms, Model model) {
		model.addAttribute("sysSms", sysSms);
		return "modules/sys/sysSmsForm";
	}

	/**
	 * 保存系统短信
	 */
	@RequiresPermissions(value={"sys:sysSms:add","sys:sysSms:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(SysSms sysSms, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysSms)){
			return form(sysSms, model);
		}
		
		try{
		
			if(!sysSms.getIsNewRecord()){//编辑表单保存				
				SysSms t = sysSmsService.get(sysSms.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysSms, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysSmsService.save(t);//保存
			}else{//新增表单保存
				sysSmsService.save(sysSms);//保存
			}
			addMessage(redirectAttributes, "保存系统短信成功");
			return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存系统短信失败");
			return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
		}
	}
	
	/**
	 * 删除系统短信
	 */
	@RequiresPermissions("sys:sysSms:del")
	@RequestMapping(value = "delete")
	public String delete(SysSms sysSms, RedirectAttributes redirectAttributes) {
		sysSmsService.delete(sysSms);
		addMessage(redirectAttributes, "删除系统短信成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
	}
	
	/**
	 * 批量删除系统短信
	 */
	@RequiresPermissions("sys:sysSms:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			sysSmsService.delete(sysSmsService.get(id));
		}
		addMessage(redirectAttributes, "删除系统短信成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("sys:sysSms:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(SysSms sysSms, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "系统短信"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<SysSms> page = sysSmsService.findPage(new Page<SysSms>(request, response, -1), sysSms);
    		new ExportExcel("系统短信", SysSms.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出系统短信记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("sys:sysSms:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<SysSms> list = ei.getDataList(SysSms.class);
			for (SysSms sysSms : list){
				try{
					sysSmsService.save(sysSms);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条系统短信记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条系统短信记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入系统短信失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
    }
	
	/**
	 * 下载导入系统短信数据模板
	 */
	@RequiresPermissions("sys:sysSms:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "系统短信数据导入模板.xlsx";
    		List<SysSms> list = Lists.newArrayList(); 
    		new ExportExcel("系统短信数据", SysSms.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysSms/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(SysSms sysSms, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(sysSms, request, response, model);
        return "modules/sys/sysSms/sysSmsSelectList";
	}
	
	

}