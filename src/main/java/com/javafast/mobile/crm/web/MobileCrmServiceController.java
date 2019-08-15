package com.javafast.mobile.crm.web;

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
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.crm.service.CrmServiceService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 工单Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmService")
public class MobileCrmServiceController extends BaseController {

	@Autowired
	private CrmServiceService crmServiceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public CrmService get(@RequestParam(required=false) String id) {
		CrmService entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmServiceService.get(id);
		}
		if (entity == null){
			entity = new CrmService();
		}
		return entity;
	}
	
	/**
	 * 工单列表页面
	 * @param crmService
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmService:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmService crmService, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmServiceList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmService
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmService crmService, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			crmService.setOwnBy(new User(ownById));
		Page<CrmService> page = crmServiceService.findPage(new Page<CrmService>(request, response), crmService); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmService
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmService crmService, Model model) {		
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceSearch";
	}
	
	/**
	 * 工单详情页面
	 * @param crmService
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmService:view")
	@RequestMapping(value = "view")
	public String view(CrmService crmService, Model model) {
		model.addAttribute("crmService", crmService);
		
		return "modules/crm/crmServiceView";
	}
	
	/**
	 * 编辑工单表单页面
	 */
	@RequiresPermissions(value={"crm:crmService:view","crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmService crmService, Model model) {

		if(crmService.getOwnBy() == null){
			crmService.setOwnBy(UserUtils.getUser());
		}
		
		if(crmService.getIsNewRecord()){
			if(crmService.getCustomer() != null && crmService.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(crmService.getCustomer().getId());
				crmService.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceForm";
	}
	
	/**
	 * 保存工单
	 */
	@RequiresPermissions(value={"crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmService crmService, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmService)){
			return form(crmService, model);
		}
		
		try{
		
			if(!crmService.getIsNewRecord()){//编辑表单保存				
				CrmService t = crmServiceService.get(crmService.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmService, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmServiceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			}else{//新增表单保存
				crmService.setNo("GD"+IdUtils.getId());
				crmService.setStatus("0");
				crmServiceService.save(crmService);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_ADD, crmService.getId(), crmService.getName(), crmService.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存工单成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存工单失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/?repage";
		}
	}
	
	/**
	 * 完成
	 * @param id
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "deal")
	public String deal(String id, RedirectAttributes redirectAttributes) {
		try{
		
			CrmService crmService = crmServiceService.get(id);
			crmService.setStatus("2");
			crmService.setDealDate(new Date());
			crmServiceService.save(crmService);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_END, crmService.getId(), crmService.getName(), crmService.getCustomer().getId());
			
			addMessage(redirectAttributes, "服务工单已标记为完成");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "操作失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/?repage";
		}
	}
	
	/**
	 * 编辑服务工单表单页面
	 */
	@RequiresPermissions(value={"crm:crmService:view","crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "auditForm")
	public String auditForm(CrmService crmService, Model model) {
		crmService.setAuditBy(UserUtils.getUser());
		crmService.setAuditDate(new Date());
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceAuditForm";
	}
	
	/**
	 * 审核服务工单
	 */
	@RequiresPermissions(value={"crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "audit")
	public String audit(CrmService crmService, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmService)){
			return form(crmService, model);
		}
		
		try{
		
			if(!crmService.getIsNewRecord()){//编辑表单保存				
				crmService.setAuditStatus("1");
				CrmService t = crmServiceService.get(crmService.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmService, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmServiceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_AUDIT, crmService.getId(), crmService.getName(), crmService.getCustomer().getId());
			}
			
			addMessage(redirectAttributes, "审核服务工单成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审核服务工单失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/?repage";
		}
	}
	
	@RequestMapping(value = "index")
	public String index(CrmService crmService, Model model) {
		model.addAttribute("crmService", crmService);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, crmService.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		return "modules/crm/crmServiceIndex";
	}
}
