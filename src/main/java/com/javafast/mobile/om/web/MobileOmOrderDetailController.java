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
import com.javafast.modules.om.service.OmOrderDetailService;
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
@RequestMapping(value = "${adminPath}/mobile/om/omOrderDetail")
public class MobileOmOrderDetailController extends BaseController {
	
	@Autowired
	private OmOrderService omOrderService;
	
	@Autowired
	private OmOrderDetailService omOrderDetailService;
	
	@ModelAttribute
	public OmOrderDetail get(@RequestParam(required=false) String id) {
		OmOrderDetail entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = omOrderDetailService.get(id);
		}
		if (entity == null){
			entity = new OmOrderDetail();
		}
		return entity;
	}
	
	
	/**
	 * 订单明细
	 * @param omOrderDetail
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "form")
	public String form(OmOrderDetail omOrderDetail, Model model) {
		model.addAttribute("omOrderDetail", omOrderDetail);
		return "modules/om/omOrderDetailForm";
	}
	
	/**
	 * 保存订单明细
	 * @param request
	 * @param omOrderDetail
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, OmOrderDetail omOrderDetail, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omOrderDetail)){
			return form(omOrderDetail, model);
		}
		
		try{
		
			//判断单价 数量是否为空
			if(omOrderDetail.getNum() == null || omOrderDetail.getPrice() == null) {
				addMessage(redirectAttributes, "保存订单明细失败，参数错误");
				return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrderDetail.getOrder().getId();
			}
			
			//
			if(omOrderDetail.getOrder() == null) {
				addMessage(redirectAttributes, "保存订单明细失败，未找到订单");
				return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrderDetail.getOrder().getId();
			}
			
			//小计金额 = 单价 * 数量
			BigDecimal amount = omOrderDetail.getPrice().multiply(new BigDecimal(omOrderDetail.getNum()));
			omOrderDetail.setAmount(amount);
			
			//保存明细
			omOrderDetailService.save(omOrderDetail);
			
			addMessage(redirectAttributes, "保存订单明细成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存订单明细失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrderDetail.getOrder().getId();
		}
	}
	
	/**
	 * 删除1行明细
	 * @param omOrderDetail
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("om:omOrder:del")
	@RequestMapping(value = "delete")
	public String delete(OmOrderDetail omOrderDetail, RedirectAttributes redirectAttributes) {
		try{
			
			omOrderDetailService.delete(omOrderDetail);
			addMessage(redirectAttributes, "删除订单明细成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "删除订单明细失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/om/omOrder/index?id="+omOrderDetail.getOrder().getId();
		}
	}
}
