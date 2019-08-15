package com.javafast.mobile.om.web;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 合同Controller(手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/om/omContract")
public class MobileOmContractController extends BaseController {
	
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
	 * @param omContract
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("om:omContract:list")
	@RequestMapping(value = {"list", ""})
	public String list(OmContract omContract, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/om/omContractList";
	}
	
	/**
	 * 查询数据列表
	 * @param omContract
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OmContract omContract, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			omContract.setOwnBy(new User(ownById));
		Page<OmContract> page = omContractService.findPage(new Page<OmContract>(request, response), omContract); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param omContract
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(OmContract omContract, Model model) {		
		model.addAttribute("omContract", omContract);
		return "modules/om/omContractSearch";
	}
	
	/**
	 * 合同详情页面
	 * @param omContract
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="om:omContract:view")
	@RequestMapping(value = "view")
	public String view(OmContract omContract, Model model) {
		model.addAttribute("omContract", omContract);		
		return "modules/om/omContractView";
	}
	
	@RequiresPermissions(value="om:omContract:view")
	@RequestMapping(value = "index")
	public String index(OmContract omContract, Model model) {
		
		CrmCustomer crmCustomer = crmCustomerService.get(omContract.getCustomer().getId());
		
		omContract.setCustomer(crmCustomer);
		model.addAttribute("omContract", omContract);
		
		//如果是已经审核的合同，还需要查询关联的应收款、出库单
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setCustomer(crmCustomer);
		fiReceiveAble.setOrder(omContract.getOrder());
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findFiReceiveAbleList(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		return "modules/om/omContractIndex";
	}
	
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
	
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, OmContract omContract, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omContract)){
			return form(omContract, model);
		}
		
		try{
		
//			//合计
//			String totalAmt = request.getParameter("totalAmt");
//			//税额
//			String taxAmt = request.getParameter("taxAmt");
//			//其他费用
//			String otherAmt = request.getParameter("otherAmt");
			//总金额
			//String amount = request.getParameter("amount");
//			//总数量
//			String num = request.getParameter("num");
//			
//			if(StringUtils.isBlank(totalAmt)) {
//				totalAmt = amount;
//			}
//			if(StringUtils.isBlank(taxAmt)) {
//				taxAmt = "0";
//			}
//			if(StringUtils.isBlank(otherAmt)) {
//				otherAmt = "0";
//			}
//			if(StringUtils.isBlank(num)) {
//				num = "0";
//			}
			
			BigDecimal amount = omContract.getAmount();
//			
			OmOrder order = omContract.getOrder();
			if(order == null)
				order = new OmOrder();
			
			if(omContract.getIsNewRecord()){
				order.setNo(omContract.getNo());
				order.setSaleType("0");
				order.setStatus("0");
			}
			if(order.getInvoiceAmt() != null){
				order.setIsInvoice("1");
			}
			order.setTotalAmt(amount);
			//order.setTaxAmt(new BigDecimal(taxAmt));
			//order.setOtherAmt(new BigDecimal(otherAmt));
			order.setAmount(amount);		
			//order.setNum(Integer.parseInt(num));
			order.setCustomer(omContract.getCustomer());
			order.setDealBy(omContract.getOwnBy());
			order.setDealDate(omContract.getDealDate());
//			
//			omContract.setAmount(order.getAmount());
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
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/index?id="+omContract.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存合同失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/?repage";
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
		return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/?repage";
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
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/index?id="+omContract.getId();
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
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/index?repage";
		}
	}
}
