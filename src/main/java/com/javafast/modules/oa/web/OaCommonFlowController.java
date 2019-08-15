/**
 * Copyright 2015-2020
 */
package com.javafast.modules.oa.web;

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

import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonFlow;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonFlowService;

/**
 * 流程配置Controller
 * @author javafast
 * @version 2017-08-25
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonFlow")
public class OaCommonFlowController extends BaseController {

	@Autowired
	private OaCommonFlowService oaCommonFlowService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@ModelAttribute
	public OaCommonFlow get(@RequestParam(required=false) String id) {
		OaCommonFlow entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonFlowService.get(id);
		}
		if (entity == null){
			entity = new OaCommonFlow();
		}
		return entity;
	}
	
	/**
	 * 流程配置列表页面
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonFlow oaCommonFlow, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommonFlow> page = oaCommonFlowService.findPage(new Page<OaCommonFlow>(request, response), oaCommonFlow); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonFlowList";
	}

	/**
	 * 编辑流程配置表单页面
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
	@RequestMapping(value = "form")
	public String form(OaCommonFlow oaCommonFlow, Model model) {
		model.addAttribute("oaCommonFlow", oaCommonFlow);
		return "modules/oa/oaCommonFlowForm";
	}
	
	/**
	 * 查看流程配置页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonFlow oaCommonFlow, Model model) {
		model.addAttribute("oaCommonFlow", oaCommonFlow);
		return "modules/oa/oaCommonFlowView";
	}

	/**
	 * 保存流程配置
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
	@RequestMapping(value = "save")
	public String save(OaCommonFlow oaCommonFlow, Model model, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
		}
		
		if (!beanValidator(model, oaCommonFlow)){
			return form(oaCommonFlow, model);
		}
		
		try{
		
			if(!oaCommonFlow.getIsNewRecord()){//编辑表单保存				
				OaCommonFlow t = oaCommonFlowService.get(oaCommonFlow.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonFlow, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonFlowService.save(t);//保存
			}else{//新增表单保存
				oaCommonFlowService.save(oaCommonFlow);//保存
				
				//获取审批主体
				OaCommonAudit oaCommonAudit = oaCommonAuditService.get(oaCommonFlow.getId());
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			addMessage(redirectAttributes, "保存流程配置成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存流程配置失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
		}
	}
	
	/**
	 * 删除流程配置
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
	@RequestMapping(value = "delete")
	public String delete(OaCommonFlow oaCommonFlow, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
		}
		
		oaCommonFlowService.delete(oaCommonFlow);
		addMessage(redirectAttributes, "删除流程配置成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
	}
	
	/**
	 * 批量删除流程配置
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonFlowService.delete(oaCommonFlowService.get(id));
		}
		addMessage(redirectAttributes, "删除流程配置成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonFlow oaCommonFlow, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "流程配置"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonFlow> page = oaCommonFlowService.findPage(new Page<OaCommonFlow>(request, response, -1), oaCommonFlow);
    		new ExportExcel("流程配置", OaCommonFlow.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出流程配置记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaCommonFlow> list = ei.getDataList(OaCommonFlow.class);
			for (OaCommonFlow oaCommonFlow : list){
				try{
					oaCommonFlowService.save(oaCommonFlow);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条流程配置记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条流程配置记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入流程配置失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
    }
	
	/**
	 * 下载导入流程配置数据模板
	 */
	@RequiresPermissions("oa:oaCommonFlow:list")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "流程配置数据导入模板.xlsx";
    		List<OaCommonFlow> list = Lists.newArrayList(); 
    		new ExportExcel("流程配置数据", OaCommonFlow.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonFlow/?repage";
    }
	
	/**
	 * 流程配置列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonFlow oaCommonFlow, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonFlow, request, response, model);
        return "modules/oa/oaCommonFlowSelectList";
	}
	
}