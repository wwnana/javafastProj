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

import com.fasterxml.jackson.annotation.JsonFormat;

import javax.validation.constraints.NotNull;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 足迹Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysBrowseLog")
public class SysBrowseLogController extends BaseController {

	@Autowired
	private SysBrowseLogService sysBrowseLogService;
	
	@ModelAttribute
	public SysBrowseLog get(@RequestParam(required=false) String id) {
		SysBrowseLog entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysBrowseLogService.get(id);
		}
		if (entity == null){
			entity = new SysBrowseLog();
		}
		return entity;
	}
	
	/**
	 * 足迹列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(SysBrowseLog sysBrowseLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		sysBrowseLog.setUserId(UserUtils.getUser().getId());
		Page<SysBrowseLog> page = sysBrowseLogService.findPage(new Page<SysBrowseLog>(request, response), sysBrowseLog); 
		model.addAttribute("page", page);
		return "modules/sys/sysBrowseLogList";
	}

	/**
	 * 查看，增加，编辑足迹表单页面
	 */
	@RequiresPermissions(value={"sys:sysBrowseLog:view","sys:sysBrowseLog:add","sys:sysBrowseLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(SysBrowseLog sysBrowseLog, Model model) {
		model.addAttribute("sysBrowseLog", sysBrowseLog);
		return "modules/sys/sysBrowseLogForm";
	}

	/**
	 * 保存足迹
	 */
	@RequiresPermissions(value={"sys:sysBrowseLog:add","sys:sysBrowseLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(SysBrowseLog sysBrowseLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysBrowseLog)){
			return form(sysBrowseLog, model);
		}
		
		try{
		
			if(!sysBrowseLog.getIsNewRecord()){//编辑表单保存				
				SysBrowseLog t = sysBrowseLogService.get(sysBrowseLog.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysBrowseLog, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysBrowseLogService.save(t);//保存
			}else{//新增表单保存
				sysBrowseLogService.save(sysBrowseLog);//保存
			}
			addMessage(redirectAttributes, "保存足迹成功");
			return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存足迹失败");
			return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
		}
	}
	
	/**
	 * 删除足迹
	 */
	@RequiresPermissions("sys:sysBrowseLog:del")
	@RequestMapping(value = "delete")
	public String delete(SysBrowseLog sysBrowseLog, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/sysBrowseLog/?repage";
		}
		sysBrowseLogService.delete(sysBrowseLog);
		addMessage(redirectAttributes, "删除足迹成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
	}
	
	/**
	 * 批量删除足迹
	 */
	@RequiresPermissions("sys:sysBrowseLog:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/sysBrowseLog/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			sysBrowseLogService.delete(sysBrowseLogService.get(id));
		}
		addMessage(redirectAttributes, "删除足迹成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("sys:sysBrowseLog:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(SysBrowseLog sysBrowseLog, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "足迹"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<SysBrowseLog> page = sysBrowseLogService.findPage(new Page<SysBrowseLog>(request, response, -1), sysBrowseLog);
    		new ExportExcel("足迹", SysBrowseLog.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出足迹记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("sys:sysBrowseLog:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<SysBrowseLog> list = ei.getDataList(SysBrowseLog.class);
			for (SysBrowseLog sysBrowseLog : list){
				try{
					sysBrowseLogService.save(sysBrowseLog);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条足迹记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条足迹记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入足迹失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
    }
	
	/**
	 * 下载导入足迹数据模板
	 */
	@RequiresPermissions("sys:sysBrowseLog:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "足迹数据导入模板.xlsx";
    		List<SysBrowseLog> list = Lists.newArrayList(); 
    		new ExportExcel("足迹数据", SysBrowseLog.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysBrowseLog/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(SysBrowseLog sysBrowseLog, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(sysBrowseLog, request, response, model);
        return "modules/sys/sysBrowseLog/sysBrowseLogSelectList";
	}
	
	

}