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

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

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
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonLeave;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonLeaveService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 请假单Controller
 * @author javafast
 * @version 2017-08-25
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonLeave")
public class OaCommonLeaveController extends BaseController {

	@Autowired
	private OaCommonLeaveService oaCommonLeaveService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@ModelAttribute
	public OaCommonLeave get(@RequestParam(required=false) String id) {
		OaCommonLeave entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonLeaveService.get(id);
		}
		if (entity == null){
			entity = new OaCommonLeave();
		}
		return entity;
	}
	
	/**
	 * 请假单列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonLeave oaCommonLeave, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommonLeave> page = oaCommonLeaveService.findPage(new Page<OaCommonLeave>(request, response), oaCommonLeave); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonLeaveList";
	}

	/**
	 * 编辑请假单表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaCommonLeave oaCommonLeave, Model model) {
		
//		if(oaCommonLeave.getIsNewRecord()){
//			OaCommonAudit oaCommonAudit = oaCommonLeave.getOaCommonAudit();
//			oaCommonAudit.setTitle("请假单");
//			
//			oaCommonLeave.setOaCommonAudit(oaCommonAudit);
//		}
		
		model.addAttribute("oaCommonLeave", oaCommonLeave);
		return "modules/oa/oaCommonLeaveForm";
	}
	
	/**
	 * 查看请假单页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonLeave oaCommonLeave, Model model) {
		model.addAttribute("oaCommonLeave", oaCommonLeave);
		return "modules/oa/oaCommonLeaveView";
	}

	/**
	 * 提交请假单
	 */
	@RequestMapping(value = "save")
	public String save(OaCommonLeave oaCommonLeave, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, oaCommonLeave)){
			return form(oaCommonLeave, model);
		}
		
		try{
			
		
			if(!oaCommonLeave.getIsNewRecord()){//编辑表单提交				
				OaCommonLeave t = oaCommonLeaveService.get(oaCommonLeave.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonLeave, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonLeaveService.save(t);//提交
			}else{//新增表单提交
				oaCommonLeaveService.save(oaCommonLeave);//提交
				
				//获取审批主体
				OaCommonAudit oaCommonAudit = oaCommonAuditService.get(oaCommonLeave.getId());
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			
			addMessage(redirectAttributes, "提交请假单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交请假单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
		}
	}
	
	/**
	 * 删除请假单
	 */
	@RequestMapping(value = "delete")
	public String delete(OaCommonLeave oaCommonLeave, RedirectAttributes redirectAttributes) {
		oaCommonLeaveService.delete(oaCommonLeave);
		addMessage(redirectAttributes, "删除请假单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
	}
	
	/**
	 * 批量删除请假单
	 */
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonLeaveService.delete(oaCommonLeaveService.get(id));
		}
		addMessage(redirectAttributes, "删除请假单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonLeave/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonAudit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonLeave oaCommonLeave, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "请假单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonLeave> page = oaCommonLeaveService.findPage(new Page<OaCommonLeave>(request, response, -1), oaCommonLeave);
    		new ExportExcel("请假单", OaCommonLeave.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出请假单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonLeave/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaCommonLeave> list = ei.getDataList(OaCommonLeave.class);
			for (OaCommonLeave oaCommonLeave : list){
				try{
					oaCommonLeaveService.save(oaCommonLeave);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条请假单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条请假单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入请假单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonLeave/?repage";
    }
	
	/**
	 * 下载导入请假单数据模板
	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "请假单数据导入模板.xlsx";
    		List<OaCommonLeave> list = Lists.newArrayList(); 
    		new ExportExcel("请假单数据", OaCommonLeave.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonLeave/?repage";
    }
	
	/**
	 * 请假单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonLeave oaCommonLeave, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonLeave, request, response, model);
        return "modules/oa/oaCommonLeaveSelectList";
	}
	
}