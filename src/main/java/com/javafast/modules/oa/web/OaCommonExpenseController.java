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

import java.math.BigDecimal;
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
import com.javafast.modules.oa.entity.OaCommonExpense;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonExpenseService;

/**
 * 报销单Controller
 * @author javafast
 * @version 2017-08-25
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonExpense")
public class OaCommonExpenseController extends BaseController {

	@Autowired
	private OaCommonExpenseService oaCommonExpenseService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@ModelAttribute
	public OaCommonExpense get(@RequestParam(required=false) String id) {
		OaCommonExpense entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonExpenseService.get(id);
		}
		if (entity == null){
			entity = new OaCommonExpense();
		}
		return entity;
	}
	
	/**
	 * 报销单列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonExpense oaCommonExpense, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommonExpense> page = oaCommonExpenseService.findPage(new Page<OaCommonExpense>(request, response), oaCommonExpense); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonExpenseList";
	}

	/**
	 * 编辑报销单表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaCommonExpense oaCommonExpense, Model model) {
		model.addAttribute("oaCommonExpense", oaCommonExpense);
		return "modules/oa/oaCommonExpenseForm";
	}
	
	/**
	 * 查看报销单页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonExpense oaCommonExpense, Model model) {
		model.addAttribute("oaCommonExpense", oaCommonExpense);
		return "modules/oa/oaCommonExpenseView";
	}

	/**
	 * 提交报销单
	 */
	@RequestMapping(value = "save")
	public String save(OaCommonExpense oaCommonExpense, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, oaCommonExpense)){
			return form(oaCommonExpense, model);
		}
		
		try{
		
			if(!oaCommonExpense.getIsNewRecord()){//编辑表单提交				
				OaCommonExpense t = oaCommonExpenseService.get(oaCommonExpense.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonExpense, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonExpenseService.save(t);//提交
			}else{//新增表单提交
				oaCommonExpenseService.save(oaCommonExpense);//提交
				
				//获取审批主体
				OaCommonAudit oaCommonAudit = oaCommonAuditService.get(oaCommonExpense.getId());
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			addMessage(redirectAttributes, "提交报销单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交报销单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
		}
	}
	
	/**
	 * 删除报销单
	 */
	@RequestMapping(value = "delete")
	public String delete(OaCommonExpense oaCommonExpense, RedirectAttributes redirectAttributes) {
		oaCommonExpenseService.delete(oaCommonExpense);
		addMessage(redirectAttributes, "删除报销单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
	}
	
	/**
	 * 批量删除报销单
	 */
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonExpenseService.delete(oaCommonExpenseService.get(id));
		}
		addMessage(redirectAttributes, "删除报销单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExpense/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonAudit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonExpense oaCommonExpense, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "报销单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonExpense> page = oaCommonExpenseService.findPage(new Page<OaCommonExpense>(request, response, -1), oaCommonExpense);
    		new ExportExcel("报销单", OaCommonExpense.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出报销单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExpense/?repage";
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
			List<OaCommonExpense> list = ei.getDataList(OaCommonExpense.class);
			for (OaCommonExpense oaCommonExpense : list){
				try{
					oaCommonExpenseService.save(oaCommonExpense);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条报销单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条报销单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入报销单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExpense/?repage";
    }
	
	/**
	 * 下载导入报销单数据模板
	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "报销单数据导入模板.xlsx";
    		List<OaCommonExpense> list = Lists.newArrayList(); 
    		new ExportExcel("报销单数据", OaCommonExpense.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExpense/?repage";
    }
	
	/**
	 * 报销单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonExpense oaCommonExpense, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonExpense, request, response, model);
        return "modules/oa/oaCommonExpenseSelectList";
	}
	
}