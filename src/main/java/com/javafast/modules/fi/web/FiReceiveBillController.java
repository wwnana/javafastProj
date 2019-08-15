/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.web;

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

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;

/**
 * 收款单Controller
 * @author javafast
 * @version 2017-07-14
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiReceiveBill")
public class FiReceiveBillController extends BaseController {

	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public FiReceiveBill get(@RequestParam(required=false) String id) {
		FiReceiveBill entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiReceiveBillService.get(id);
		}
		if (entity == null){
			entity = new FiReceiveBill();
		}
		return entity;
	}
	
	/**
	 * 收款单列表页面
	 */
	@RequiresPermissions("fi:fiReceiveBill:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiReceiveBill fiReceiveBill, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiReceiveBill> page = fiReceiveBillService.findPage(new Page<FiReceiveBill>(request, response), fiReceiveBill); 
		model.addAttribute("page", page);
		return "modules/fi/fiReceiveBillList";
	}

	/**
	 * 查看，增加，编辑收款单表单页面
	 */
	@RequiresPermissions(value="fi:fiReceiveBill:view")
	@RequestMapping(value = "view")
	public String view(FiReceiveBill fiReceiveBill, Model model) {
		model.addAttribute("fiReceiveBill", fiReceiveBill);
		return "modules/fi/fiReceiveBillView";
	}
	
	/**
	 * 查看，增加，编辑收款单表单页面
	 */
	@RequiresPermissions(value={"fi:fiReceiveBill:view","fi:fiReceiveBill:add","fi:fiReceiveBill:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiReceiveBill fiReceiveBill, Model model) {
		
		if(fiReceiveBill.getIsNewRecord()){
			fiReceiveBill.setNo("SK"+IdUtils.getId());
			
			if(fiReceiveBill.getCustomer()!=null && fiReceiveBill.getCustomer().getId()!=null){
				fiReceiveBill.setCustomer(crmCustomerService.get(fiReceiveBill.getCustomer().getId()));
			}
		}
		if(fiReceiveBill.getOwnBy() == null){
			fiReceiveBill.setOwnBy(UserUtils.getUser());
		}
		if(fiReceiveBill.getDealDate() == null){
			fiReceiveBill.setDealDate(new Date());
		}
		if(fiReceiveBill.getStatus() == null){
			fiReceiveBill.setStatus("0");
		}
		
		model.addAttribute("fiReceiveBill", fiReceiveBill);
		return "modules/fi/fiReceiveBillForm";
	}

	/**
	 * 保存收款单
	 */
	@RequiresPermissions(value={"fi:fiReceiveBill:add","fi:fiReceiveBill:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiReceiveBill fiReceiveBill, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiReceiveBill)){
			return form(fiReceiveBill, model);
		}
		
		try{
			
			if(fiReceiveBill.getCustomer() == null && fiReceiveBill.getFiReceiveAble()!=null){
				FiReceiveAble fiReceiveAble = fiReceiveAbleService.get(fiReceiveBill.getFiReceiveAble().getId());
				fiReceiveBill.setCustomer(fiReceiveAble.getCustomer());
			}
			
			if(fiReceiveBill.getInvoiceAmt() != null){
				fiReceiveBill.setIsInvoice("1");
			}
		
			if(!fiReceiveBill.getIsNewRecord()){//编辑表单保存				
				FiReceiveBill t = fiReceiveBillService.get(fiReceiveBill.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiReceiveBill, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiReceiveBillService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				fiReceiveBill.setStatus("0");
				fiReceiveBillService.save(fiReceiveBill);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_ADD, fiReceiveBill.getId(), fiReceiveBill.getNo(), fiReceiveBill.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存收款单成功");
			if(fiReceiveBill.getFiReceiveAble() != null)
				return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/index?id="+fiReceiveBill.getFiReceiveAble().getId();
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存收款单失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
		}
	}
	
	/**
	 * 删除收款单
	 */
	@RequiresPermissions("fi:fiReceiveBill:del")
	@RequestMapping(value = "delete")
	public String delete(FiReceiveBill fiReceiveBill, RedirectAttributes redirectAttributes) {
		fiReceiveBillService.delete(fiReceiveBill);
		addMessage(redirectAttributes, "删除收款单成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
	}
	
	/**
	 * 批量删除收款单
	 */
	@RequiresPermissions("fi:fiReceiveBill:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiReceiveBillService.delete(fiReceiveBillService.get(id));
		}
		addMessage(redirectAttributes, "删除收款单成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiReceiveBill:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiReceiveBill fiReceiveBill, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "收款单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiReceiveBill> page = fiReceiveBillService.findPage(new Page<FiReceiveBill>(request, response, -1), fiReceiveBill);
    		new ExportExcel("收款单", FiReceiveBill.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出收款单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiReceiveBill:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiReceiveBill> list = ei.getDataList(FiReceiveBill.class);
			for (FiReceiveBill fiReceiveBill : list){
				try{
					fiReceiveBillService.save(fiReceiveBill);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条收款单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条收款单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入收款单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
    }
	
	/**
	 * 下载导入收款单数据模板
	 */
	@RequiresPermissions("fi:fiReceiveBill:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "收款单数据导入模板.xlsx";
    		List<FiReceiveBill> list = Lists.newArrayList(); 
    		new ExportExcel("收款单数据", FiReceiveBill.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(FiReceiveBill fiReceiveBill, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(fiReceiveBill, request, response, model);
        return "modules/fi/fiReceiveBillSelectList";
	}
	
	/**
	 * 审核收款单
	 * @param fiReceiveBill
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("fi:fiReceiveBill:audit")
	@RequestMapping(value = "audit")
	public String audit(FiReceiveBill fiReceiveBill, RedirectAttributes redirectAttributes) {
		try {
			
			fiReceiveBill = fiReceiveBillService.get(fiReceiveBill.getId());
			if("0".equals(fiReceiveBill.getStatus())){
				
				fiReceiveBill.setAuditBy(UserUtils.getUser());
				fiReceiveBillService.audit(fiReceiveBill);
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_AUDIT, fiReceiveBill.getId(), fiReceiveBill.getNo(), fiReceiveBill.getCustomer().getId());
				
				addMessage(redirectAttributes, "审核收款单成功");
			}
			
			if(fiReceiveBill.getFiReceiveAble() != null)
				return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/index?id="+fiReceiveBill.getFiReceiveAble().getId();
			
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "审核收款单失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveBill/?repage";
		}
	}

}