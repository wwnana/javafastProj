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
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.service.OmOrderService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 订单Controller(手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/om/omOrder")
public class MobileOmOrderController extends BaseController {
	
	@Autowired
	private OmOrderService omOrderService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@ModelAttribute
	public OmOrder get(@RequestParam(required=false) String id) {
		OmOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = omOrderService.get(id);
		}
		if (entity == null){
			entity = new OmOrder();
		}
		return entity;
	}
	
	/**
	 * 订单列表页面
	 * @param omOrder
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OmOrder omOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/om/omOrderList";
	}
	
	/**
	 * 查询数据列表
	 * @param omOrder
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OmOrder omOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			omOrder.setOwnBy(new User(ownById));
		Page<OmOrder> page = omOrderService.findPage(new Page<OmOrder>(request, response), omOrder); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param omOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(OmOrder omOrder, Model model) {		
		model.addAttribute("omOrder", omOrder);
		return "modules/om/omOrderSearch";
	}
	
	/**
	 * 订单详情页面
	 * @param omOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "view")
	public String view(OmOrder omOrder, Model model) {
		
		model.addAttribute("omOrder", omOrder);		
		return "modules/om/omOrderView";
	}
	
	/**
	 * 订单主页
	 * @param omOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "index")
	public String index(OmOrder omOrder, Model model) {
		
		CrmCustomer crmCustomer = crmCustomerService.get(omOrder.getCustomer().getId());
		
		omOrder.setCustomer(crmCustomer);
		model.addAttribute("omOrder", omOrder);
		
		//如果是已经审核的合同，还需要查询关联的应收款、出库单
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setCustomer(crmCustomer);
		fiReceiveAble.setOrder(omOrder);
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findFiReceiveAbleList(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		return "modules/om/omOrderIndex";
	}
	
	@RequestMapping(value = "form")
	public String form(OmOrder omOrder, Model model) {
		
		if(omOrder.getIsNewRecord()){
			omOrder.setNo("DD"+IdUtils.getId());
			omOrder.setDealDate(new Date());
			omOrder.setOwnBy(UserUtils.getUser());
			if(omOrder.getCustomer() != null && omOrder.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(omOrder.getCustomer().getId());
				omOrder.setCustomer(customer);
			}
			
		}		
		omOrder.setStatus("0");		
		model.addAttribute("omOrder", omOrder);
		return "modules/om/omOrderForm";
	}
	
	/**
	 * 保存
	 * @param request
	 * @param omOrder
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, OmOrder omOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omOrder)){
			return form(omOrder, model);
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
			
			if(StringUtils.isBlank(totalAmt)) {
				totalAmt = amount;
			}
//			if(StringUtils.isBlank(taxAmt)) {
//				taxAmt = "0";
//			}
			if(StringUtils.isBlank(otherAmt)) {
				otherAmt = "0";
			}
			if(StringUtils.isBlank(num)) {
				num = "0";
			}
			
			if(omOrder.getIsNewRecord()){
				omOrder.setNo(omOrder.getNo());
				omOrder.setSaleType("0");
				omOrder.setStatus("0");
			}
			if(omOrder.getInvoiceAmt() != null){
				omOrder.setIsInvoice("1");
			}
			omOrder.setTotalAmt(new BigDecimal(totalAmt));
			//omOrder.setTaxAmt(new BigDecimal(taxAmt));
			omOrder.setOtherAmt(new BigDecimal(otherAmt));
			omOrder.setAmount(new BigDecimal(amount));		
			omOrder.setNum(Integer.parseInt(num));
			omOrder.setCustomer(omOrder.getCustomer());
			omOrder.setDealBy(omOrder.getOwnBy());
			omOrder.setDealDate(omOrder.getDealDate());
			
			omOrder.setAmount(omOrder.getAmount());
			if(!omOrder.getIsNewRecord()){//编辑表单保存				
				OmOrder t = omOrderService.get(omOrder.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(omOrder, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				omOrderService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				omOrder.setStatus("0");
				omOrderService.save(omOrder);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_ADD, omOrder.getId(), omOrder.getNo(), omOrder.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存订单成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrder.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存订单失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/?repage";
		}
	}
	
	@RequiresPermissions("om:omOrder:del")
	@RequestMapping(value = "delete")
	public String delete(OmOrder omOrder, RedirectAttributes redirectAttributes) {
		try {
			omOrderService.delete(omOrder);
			addMessage(redirectAttributes, "删除销售订单成功");		
		} catch (Exception e) {
			addMessage(redirectAttributes, "删除失败！失败信息："+e.getMessage());
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/?repage";
		}
	}
	
	/**
	 * 审核
	 * @param omOrder
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "audit")
	public String audit(OmOrder omOrder, RedirectAttributes redirectAttributes) {
		try {
			
			omOrderService.audit(omOrder.getId());
			addMessage(redirectAttributes, "审核销售订单成功");
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDER, Contants.ACTION_TYPE_AUDIT, omOrder.getId(), omOrder.getNo(), omOrder.getCustomer().getId());
		} catch (Exception e) {
			addMessage(redirectAttributes, "审核失败！失败信息："+e.getMessage());
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrder.getId();
		}
	}
}
