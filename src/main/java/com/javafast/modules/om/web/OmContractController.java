/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.web;

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
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.service.WmsOutstockService;
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
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.entity.CrmQuoteDetail;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiPaymentBill;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiPaymentBillService;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;

/**
 * 合同Controller
 * @author javafast
 * @version 2017-07-13
 */
@Controller
@RequestMapping(value = "${adminPath}/om/omContract")
public class OmContractController extends BaseController {

	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@ModelAttribute
	public OmContract get(@RequestParam(required=false) String id) {
		OmContract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = omContractService.get(id);
		}
		if (entity == null){
			entity = new OmContract();
		}
		return entity;
	}
	
	/**
	 * 合同列表页面
	 */
	@RequiresPermissions("om:omContract:list")
	@RequestMapping(value = {"list", ""})
	public String list(OmContract omContract, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OmContract> page = omContractService.findPage(new Page<OmContract>(request, response), omContract); 
		model.addAttribute("page", page);
		return "modules/om/omContractList";
	}
	
	@RequiresPermissions(value="om:omContract:view")
	@RequestMapping(value = "view")
	public String view(OmContract omContract, Model model) {
		model.addAttribute("omContract", omContract);
		return "modules/om/omContractView";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="om:omContract:view")
	@RequestMapping(value = "index")
	public String index(OmContract omContract, Model model) {
		
		CrmCustomer crmCustomer = crmCustomerService.get(omContract.getCustomer().getId());
		
		omContract.setCustomer(crmCustomer);
		model.addAttribute("omContract", omContract);
		
		//如果是已经审核的合同，还需要查询关联的应收款、出库单
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		//fiReceiveAble.setCustomer(crmCustomer);
		fiReceiveAble.setOrder(omContract.getOrder());
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findFiReceiveAbleList(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		//查询收款记录
		if(fiReceiveAbleList != null && fiReceiveAbleList.size() > 0) {
			FiReceiveBill conFiReceiveBill = new FiReceiveBill();
			conFiReceiveBill.setFiReceiveAble(fiReceiveAbleList.get(0));
			List<FiReceiveBill> fiReceiveBillList = fiReceiveBillService.findFiReceiveBillList(conFiReceiveBill);
			model.addAttribute("fiReceiveBillList", fiReceiveBillList);
		}		
		
		//查询出库单
		WmsOutstock conWmsOutstock = new WmsOutstock();
		conWmsOutstock.setOrder(omContract.getOrder());
		List<WmsOutstock> wmsOutstockList = wmsOutstockService.findList(conWmsOutstock);
		model.addAttribute("wmsOutstockList", wmsOutstockList);
		
		//查询日志
		SysDynamic conSysDynamic = new SysDynamic();
		conSysDynamic.setTargetId(omContract.getId());
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(conSysDynamic);
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(omContract.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CONTRACT);
		contactRecord.setTargetId(omContract.getId());
		contactRecord.setTargetName(omContract.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
				
		return "modules/om/omContractIndex";
	}
	
	/**
	 * 打印
	 * @param omContract
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="om:omContract:view")
	@RequestMapping(value = "print")
	public String print(OmContract omContract, Model model) {
		CrmCustomer crmCustomer = crmCustomerService.get(omContract.getCustomer().getId());		
		omContract.setCustomer(crmCustomer);
		model.addAttribute("omContract", omContract);
		return "modules/om/omContractPrint";
	}
	
	/**
	 * 查看，增加，编辑合同表单页面
	 */
	@RequiresPermissions(value={"om:omContract:view","om:omContract:add","om:omContract:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OmContract omContract, Model model) {
		
		if(omContract.getIsNewRecord()){
			omContract.setNo("DD"+IdUtils.getId());
			omContract.setDealDate(new Date());
			omContract.setOwnBy(UserUtils.getUser());
			if(omContract.getCustomer() != null && omContract.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(omContract.getCustomer().getId());
				omContract.setCustomer(customer);
			}			
			if(omContract.getChance() != null && omContract.getChance().getId() != null){
				CrmChance chance = crmChanceService.get(omContract.getChance().getId());
				omContract.setChance(chance);
			}
		}		
		omContract.setStatus("0");		
		model.addAttribute("omContract", omContract);
		return "modules/om/omContractForm";
	}

	/**
	 * 保存合同
	 */
	@RequiresPermissions(value={"om:omContract:add","om:omContract:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, OmContract omContract, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omContract)){
			return form(omContract, model);
		}
		
		try{
		
			//合计
			String totalAmt = request.getParameter("totalAmt");
			//税额
			//String taxAmt = request.getParameter("taxAmt");
			//其他费用
			String otherAmt = request.getParameter("otherAmt");
			//总金额
			String amount = request.getParameter("amount");
			//总数量
			String num = request.getParameter("num");
			
			OmOrder order = omContract.getOrder();
			if(omContract.getIsNewRecord()){
				order.setNo(omContract.getNo());
				order.setSaleType("0");
				order.setStatus("0");
			}
			if(order.getInvoiceAmt() != null){
				order.setIsInvoice("1");
			}
			order.setTotalAmt(new BigDecimal(totalAmt));
			//order.setTaxAmt(new BigDecimal(taxAmt));
			order.setOtherAmt(new BigDecimal(otherAmt));
			order.setAmount(new BigDecimal(amount));		
			order.setNum(Integer.parseInt(num));
			order.setCustomer(omContract.getCustomer());
			order.setDealBy(omContract.getOwnBy());
			order.setDealDate(omContract.getDealDate());
			
			omContract.setAmount(order.getAmount());
			if(!omContract.getIsNewRecord()){//编辑表单保存				
				OmContract t = omContractService.get(omContract.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(omContract, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				omContractService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				omContract.setStatus("0");
				omContractService.save(omContract);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_ADD, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存合同成功");
			return "redirect:"+Global.getAdminPath()+"/om/omContract/index?id="+omContract.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存合同失败");
			return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
		}
	}
	
	/**
	 * 删除合同
	 */
	@RequiresPermissions("om:omContract:del")
	@RequestMapping(value = "delete")
	public String delete(OmContract omContract, RedirectAttributes redirectAttributes) {
		omContractService.delete(omContract);
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
	}
	
	/**
	 * 批量删除合同
	 */
	@RequiresPermissions("om:omContract:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			omContractService.delete(omContractService.get(id));
		}
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
	}
	
	/**
	 * 删除合同
	 */
	@RequiresPermissions("om:omContract:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(OmContract omContract, RedirectAttributes redirectAttributes) {
		
		omContract = omContractService.get(omContract.getId());
		if("0".equals(omContract)){
			omContractService.delete(omContract);
		}
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+omContract.getCustomer().getId();
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("om:omContract:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OmContract omContract, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "合同"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OmContract> page = omContractService.findPage(new Page<OmContract>(request, response, -1), omContract);
    		new ExportExcel("合同", OmContract.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出合同记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("om:omContract:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OmContract> list = ei.getDataList(OmContract.class);
			for (OmContract omContract : list){
				try{
					omContractService.save(omContract);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条合同记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条合同记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入合同失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
    }
	
	/**
	 * 下载导入合同数据模板
	 */
	@RequiresPermissions("om:omContract:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "合同数据导入模板.xlsx";
    		List<OmContract> list = Lists.newArrayList(); 
    		new ExportExcel("合同数据", OmContract.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omContract/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OmContract omContract, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(omContract, request, response, model);
        return "modules/om/omContractSelectList";
	}
	
	/**
	 * 报价单生成订单合同
	 * @param omContract
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"om:omContract:view","om:omContract:add","om:omContract:edit"},logical=Logical.OR)
	@RequestMapping(value = "quoteToForm")
	public String quoteToForm(OmContract omContract, Model model) {
		
		if(omContract.getIsNewRecord()){
			omContract.setNo("HT"+IdUtils.getId());
		}
		
		if(omContract.getOwnBy() == null){
			omContract.setOwnBy(UserUtils.getUser());
		}
		if(omContract.getDealDate() == null){
			omContract.setDealDate(new Date());
		}
		
		if(omContract.getQuote().getId() != null){
			
			CrmQuote crmQuote = crmQuoteService.get(omContract.getQuote().getId());
			if(crmQuote != null){
				
				//合同订单主体内容
				omContract.setAmount(crmQuote.getAmount());
				omContract.setCustomer(crmQuote.getCustomer());
				omContract.setChance(crmQuote.getChance());
				omContract.setQuote(crmQuote);
				omContract.setOwnBy(crmQuote.getOwnBy());
				omContract.setStatus("0");
				
				//订单明细
				List<OmOrderDetail> omOrderDetailList = Lists.newArrayList();
				
				for(CrmQuoteDetail crmQuoteDetail : crmQuote.getCrmQuoteDetailList()){
					
					OmOrderDetail omOrderDetail = new OmOrderDetail();
					
					omOrderDetail.setProduct(crmQuoteDetail.getProduct());
					omOrderDetail.setUnitType(crmQuoteDetail.getUnitType());
					omOrderDetail.setPrice(crmQuoteDetail.getPrice());
					omOrderDetail.setNum(crmQuoteDetail.getNum());
					omOrderDetail.setAmount(crmQuoteDetail.getAmt());
					//omOrderDetail.setTaxAmt(BigDecimal.ZERO);
					//omOrderDetail.setTaxRate(BigDecimal.ZERO);
					omOrderDetail.setRemarks(crmQuoteDetail.getRemarks());
					omOrderDetail.setSort(crmQuoteDetail.getSort());
					omOrderDetailList.add(omOrderDetail);
				}
								
				omContract.setOmOrderDetailList(omOrderDetailList);
				
				//合同关联订单
				OmOrder order = new OmOrder();
				order.setNo("DD"+IdUtils.getId());
				order.setCustomer(crmQuote.getCustomer());
				order.setNum(crmQuote.getNum());
				order.setAmount(crmQuote.getAmount());
				order.setTotalAmt(crmQuote.getAmount());
				//order.setTaxAmt(BigDecimal.ZERO);
				order.setOtherAmt(BigDecimal.ZERO);
				order.setReceiveAmt(BigDecimal.ZERO);
				order.setIsInvoice("0");
				omContract.setOrder(order);
			}
		}
		
		model.addAttribute("omContract", omContract);
		return "modules/om/omContractForm";
	}

	/**
	 * 合同审核
	 * @param omContract
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("om:omContract:audit")
	@RequestMapping(value = "audit")
	public String audit(OmContract omContract, RedirectAttributes redirectAttributes) {
		
		try{
			
			omContract.setAuditBy(UserUtils.getUser());
			omContractService.audit(omContract);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_AUDIT, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId());
			addMessage(redirectAttributes, "审核合同成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "审核合同失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/om/omContract/index?id="+omContract.getId();
		}
	}
	
	/**
	 * 合同撤销
	 * @param omContract
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("om:omContract:revoke")
	@RequestMapping(value = "revoke")
	public String revoke(OmContract omContract, RedirectAttributes redirectAttributes) {
		
		try{
			
			omContractService.revoke(omContract);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_AUDIT, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId());
			addMessage(redirectAttributes, "撤销合同成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "撤销合同失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/om/omContract/index?id="+omContract.getId();
		}
	}
}