package com.javafast.modules.crm.web;

import java.net.URLDecoder;
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

import com.javafast.modules.crm.entity.CrmCustomer;
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
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 附件Controller
 * @author javafast
 * @version 2018-04-27
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmDocument")
public class CrmDocumentController extends BaseController {

	@Autowired
	private CrmDocumentService crmDocumentService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmDocument get(@RequestParam(required=false) String id) {
		CrmDocument entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmDocumentService.get(id);
		}
		if (entity == null){
			entity = new CrmDocument();
		}
		return entity;
	}
	
	/**
	 * 客户附件
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "indexDocumentList")
	public String indexDocumentList(CrmDocument crmDocument, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmDocument> page = crmDocumentService.findPage(new Page<CrmDocument>(request, response), crmDocument); 
		model.addAttribute("page", page);
		return "modules/crm/indexDocumentList";
	}
	
	/**
	 * 附件
	 * @param crmDocument
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmDocument crmDocument, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmDocument> page = crmDocumentService.findPage(new Page<CrmDocument>(request, response), crmDocument); 
		model.addAttribute("page", page);
		return "modules/crm/crmDocumentList";
	}

	/**
	 * 编辑附件表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmDocument crmDocument, Model model) {
		
		if(crmDocument.getIsNewRecord()){
			if(crmDocument.getCustomer() != null && StringUtils.isNotBlank(crmDocument.getCustomer().getId())){
				CrmCustomer customer = crmCustomerService.get(crmDocument.getCustomer().getId());
				crmDocument.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmDocument", crmDocument);
		return "modules/crm/crmDocumentForm";
	}
	
	/**
	 * 查看附件页面
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "view")
	public String view(CrmDocument crmDocument, Model model) {
		model.addAttribute("crmDocument", crmDocument);
		return "modules/crm/crmDocumentView";
	}

	public static String getFileNameFromPath(String path){
		String fileName = path.trim().substring(path.lastIndexOf("/")+1);
		//String fileName = path.substring(path.lastIndexOf("\\")+1); 
		return fileName;
		}
	
	/**
	 * 保存附件
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmDocument crmDocument, Model model, RedirectAttributes redirectAttributes, HttpServletRequest req,HttpServletResponse resp) {
		if (!beanValidator(model, crmDocument)){
			return form(crmDocument, model);
		}
		
		try{
		
			
			if(!crmDocument.getIsNewRecord()){//编辑表单保存				
				CrmDocument t = crmDocumentService.get(crmDocument.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmDocument, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmDocumentService.save(t);//保存
			}else{//新增表单保存
				crmDocumentService.save(crmDocument);//保存
			}
			addMessage(redirectAttributes, "保存附件成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存附件失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmDocument.getCustomer().getId();
		}
	}
	
	/**
	 * 删除附件
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmDocument crmDocument, RedirectAttributes redirectAttributes) {
		crmDocumentService.delete(crmDocument);
		addMessage(redirectAttributes, "删除附件成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmDocument.getCustomer().getId();
	}
	
	/**
	 * 删除附件
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(CrmDocument crmDocument, RedirectAttributes redirectAttributes) {
		crmDocumentService.delete(crmDocument);
		addMessage(redirectAttributes, "删除附件成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmDocument.getCustomer().getId();
	}
	
	/**
	 * 批量删除附件
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmDocumentService.delete(crmDocumentService.get(id));
		}
		addMessage(redirectAttributes, "删除附件成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmDocument/?repage";
	}
	
	/**
	 * 附件列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmDocument crmDocument, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmDocument, request, response, model);
        return "modules/crm/crmDocumentSelectList";
	}
	
}