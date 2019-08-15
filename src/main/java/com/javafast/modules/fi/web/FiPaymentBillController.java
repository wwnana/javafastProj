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
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.modules.wms.service.WmsSupplierService;
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
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.entity.FiPaymentBill;
import com.javafast.modules.fi.service.FiPaymentAbleService;
import com.javafast.modules.fi.service.FiPaymentBillService;

/**
 * 付款单Controller
 * @author javafast
 * @version 2017-07-17
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiPaymentBill")
public class FiPaymentBillController extends BaseController {

	@Autowired
	private FiPaymentBillService fiPaymentBillService;
	
	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	@Autowired
	private WmsSupplierService wmsSupplierService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public FiPaymentBill get(@RequestParam(required=false) String id) {
		FiPaymentBill entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiPaymentBillService.get(id);
		}
		if (entity == null){
			entity = new FiPaymentBill();
		}
		return entity;
	}
	
	/**
	 * 付款单列表页面
	 */
	@RequiresPermissions("fi:fiPaymentBill:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiPaymentBill fiPaymentBill, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiPaymentBill> page = fiPaymentBillService.findPage(new Page<FiPaymentBill>(request, response), fiPaymentBill); 
		model.addAttribute("page", page);
		return "modules/fi/fiPaymentBillList";
	}

	/**
	 * 编辑付款单付款单表单页面
	 */
	@RequiresPermissions(value={"fi:fiPaymentBill:view","fi:fiPaymentBill:add","fi:fiPaymentBill:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiPaymentBill fiPaymentBill, Model model) {
		
		if(fiPaymentBill.getIsNewRecord()){
			fiPaymentBill.setNo("FK"+IdUtils.getId());
		}
		if(fiPaymentBill.getFiPaymentAble()!= null && StringUtils.isNotBlank(fiPaymentBill.getFiPaymentAble().getId())){
			
			FiPaymentAble fiPaymentAble = fiPaymentAbleService.get(fiPaymentBill.getFiPaymentAble().getId());
			
			if(fiPaymentAble.getSupplier()!=null && StringUtils.isNotBlank(fiPaymentAble.getSupplier().getId())){
				
				WmsSupplier supplier = wmsSupplierService.get(fiPaymentAble.getSupplier().getId());
				fiPaymentBill.setSupplier(supplier);
			}
			if(fiPaymentAble.getCustomer()!= null && StringUtils.isNotBlank(fiPaymentAble.getCustomer().getId())){
				
				CrmCustomer customer = crmCustomerService.get(fiPaymentAble.getCustomer().getId());
				fiPaymentBill.setCustomer(customer);
			}
		}
		if(fiPaymentBill.getOwnBy() == null){
			fiPaymentBill.setOwnBy(UserUtils.getUser());
		}
		if(fiPaymentBill.getDealDate() == null){
			fiPaymentBill.setDealDate(new Date());
		}
		if(fiPaymentBill.getStatus() == null){
			fiPaymentBill.setStatus("0");
		}
		
		model.addAttribute("fiPaymentBill", fiPaymentBill);
		return "modules/fi/fiPaymentBillForm";
	}
	
	/**
	 * 查看付款单页面
	 */
	@RequiresPermissions(value="fi:fiPaymentBill:view")
	@RequestMapping(value = "view")
	public String view(FiPaymentBill fiPaymentBill, Model model) {
		model.addAttribute("fiPaymentBill", fiPaymentBill);
		return "modules/fi/fiPaymentBillView";
	}

	/**
	 * 保存付款单
	 */
	@RequiresPermissions(value={"fi:fiPaymentBill:add","fi:fiPaymentBill:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiPaymentBill fiPaymentBill, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiPaymentBill)){
			return form(fiPaymentBill, model);
		}
		
		try{
		
			if(!fiPaymentBill.getIsNewRecord()){//编辑表单保存				
				FiPaymentBill t = fiPaymentBillService.get(fiPaymentBill.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiPaymentBill, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiPaymentBillService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_PAYMENTBILL, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{
				
				//新增表单保存
				fiPaymentBill.setStatus("0");
				fiPaymentBillService.save(fiPaymentBill);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_PAYMENTBILL, Contants.ACTION_TYPE_ADD, fiPaymentBill.getId(), fiPaymentBill.getNo(), null);
			}
			addMessage(redirectAttributes, "保存付款单成功");
			if(fiPaymentBill.getFiPaymentAble() != null)
				return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/index?id="+fiPaymentBill.getFiPaymentAble().getId();
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存付款单失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
		}
	}
	
	/**
	 * 删除付款单
	 */
	@RequiresPermissions("fi:fiPaymentBill:del")
	@RequestMapping(value = "delete")
	public String delete(FiPaymentBill fiPaymentBill, RedirectAttributes redirectAttributes) {
		fiPaymentBillService.delete(fiPaymentBill);
		addMessage(redirectAttributes, "删除付款单成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
	}
	
	/**
	 * 批量删除付款单
	 */
	@RequiresPermissions("fi:fiPaymentBill:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiPaymentBillService.delete(fiPaymentBillService.get(id));
		}
		addMessage(redirectAttributes, "删除付款单成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiPaymentBill:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiPaymentBill fiPaymentBill, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "付款单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiPaymentBill> page = fiPaymentBillService.findPage(new Page<FiPaymentBill>(request, response, -1), fiPaymentBill);
    		new ExportExcel("付款单", FiPaymentBill.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出付款单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiPaymentBill:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiPaymentBill> list = ei.getDataList(FiPaymentBill.class);
			for (FiPaymentBill fiPaymentBill : list){
				try{
					fiPaymentBillService.save(fiPaymentBill);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条付款单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条付款单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入付款单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
    }
	
	/**
	 * 下载导入付款单数据模板
	 */
	@RequiresPermissions("fi:fiPaymentBill:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "付款单数据导入模板.xlsx";
    		List<FiPaymentBill> list = Lists.newArrayList(); 
    		new ExportExcel("付款单数据", FiPaymentBill.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(FiPaymentBill fiPaymentBill, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(fiPaymentBill, request, response, model);
        return "modules/fi/fiPaymentBillSelectList";
	}
	
	/**
	 * 审核付款单
	 * @param fiPaymentBill
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("fi:fiPaymentBill:audit")
	@RequestMapping(value = "audit")
	public String audit(FiPaymentBill fiPaymentBill, RedirectAttributes redirectAttributes) {
		try {
			
			fiPaymentBill = fiPaymentBillService.get(fiPaymentBill.getId());
			if("0".equals(fiPaymentBill.getStatus())){
				
				fiPaymentBill.setAuditBy(UserUtils.getUser());
				fiPaymentBillService.audit(fiPaymentBill);
				addMessage(redirectAttributes, "审核付款单成功");
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_PAYMENTBILL, Contants.ACTION_TYPE_AUDIT, fiPaymentBill.getId(), fiPaymentBill.getNo(), null);
			}
			
			if(fiPaymentBill.getFiPaymentAble() != null)
				return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/index?id="+fiPaymentBill.getFiPaymentAble().getId();
			
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "审核收款单失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentBill/?repage";
		}		
	}
}