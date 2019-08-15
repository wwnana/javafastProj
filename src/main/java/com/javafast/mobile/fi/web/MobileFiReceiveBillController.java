package com.javafast.mobile.fi.web;

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
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 收款单Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/fi/fiReceiveBill")
public class MobileFiReceiveBillController extends BaseController {

	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
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
	 * @param fiReceiveBill
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("fi:fiReceiveBill:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiReceiveBill fiReceiveBill, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/fi/fiReceiveBillList";
	}
	
	/**
	 * 查询数据列表
	 * @param fiReceiveBill
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(FiReceiveBill fiReceiveBill, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiReceiveBill> page = fiReceiveBillService.findPage(new Page<FiReceiveBill>(request, response), fiReceiveBill); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param fiReceiveBill
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(FiReceiveBill fiReceiveBill, Model model) {		
		model.addAttribute("fiReceiveBill", fiReceiveBill);
		return "modules/fi/fiReceiveBillSearch";
	}
	
	/**
	 * 收款单详情页面
	 * @param fiReceiveBill
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="fi:fiReceiveBill:view")
	@RequestMapping(value = "view")
	public String view(FiReceiveBill fiReceiveBill, Model model) {
		model.addAttribute("fiReceiveBill", fiReceiveBill);
		return "modules/fi/fiReceiveBillView";
	}
	
	/**
	 * 编辑收款单表单页面
	 */
	@RequiresPermissions(value={"fi:fiReceiveBill:view","fi:fiReceiveBill:add","fi:fiReceiveBill:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiReceiveBill fiReceiveBill, Model model) {

		if(fiReceiveBill.getIsNewRecord()){
			fiReceiveBill.setNo("SK"+IdUtils.getId());
			
//			if(fiReceiveBill.getCustomer()!=null && fiReceiveBill.getCustomer().getId()!=null){
//				fiReceiveBill.setCustomer(crmCustomerService.get(fiReceiveBill.getCustomer().getId()));
//			}
			
			if(fiReceiveBill.getFiReceiveAble()!=null && fiReceiveBill.getFiReceiveAble().getId()!=null) {
				FiReceiveAble fiReceiveAble = fiReceiveAbleService.get(fiReceiveBill.getFiReceiveAble());
				
				fiReceiveBill.setFiReceiveAble(fiReceiveAble);
				
				CrmCustomer crmCustomer = crmCustomerService.get(fiReceiveAble.getCustomer());
				if(crmCustomer != null)
					fiReceiveBill.setCustomer(fiReceiveAble.getCustomer());
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
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveBill/view?id="+fiReceiveBill.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存收款单失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveBill/?repage";
		}
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
				return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveAble/view?id="+fiReceiveBill.getFiReceiveAble().getId();
			
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveBill/?repage";
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "审核收款单失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveBill/?repage";
		}
	}
}
