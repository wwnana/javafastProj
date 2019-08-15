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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 商机Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmChance")
public class MobileCrmChanceController extends BaseController {

	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	

	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@ModelAttribute
	public CrmChance get(@RequestParam(required=false) String id) {
		CrmChance entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmChanceService.get(id);
		}
		if (entity == null){
			entity = new CrmChance();
		}
		return entity;
	}
	
	/**
	 * 商机列表页面
	 * @param crmChance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmChance:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmChanceList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmChance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			crmChance.setOwnBy(new User(ownById));
		Page<CrmChance> page = crmChanceService.findPage(new Page<CrmChance>(request, response), crmChance); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmChance
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmChance crmChance, Model model) {		
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceSearch";
	}
	
	/**
	 * 商机详情页面
	 * @param crmChance
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmChance:view")
	@RequestMapping(value = "view")
	public String view(CrmChance crmChance, Model model) {
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceView";
	}
	
	/**
	 * 商机详情页面
	 * @param crmChance
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmChance:view")
	@RequestMapping(value = "index")
	public String index(CrmChance crmChance, Model model) {
		model.addAttribute("crmChance", crmChance);
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(crmChance.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
		
		//查询关联报价单
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setChance(crmChance);
		List<CrmQuote> quoteList = crmQuoteService.findList(crmQuote);
		model.addAttribute("quoteList", quoteList);
		
		//查询关联订单合同
		OmContract conOmContract = new OmContract();
		conOmContract.setChance(crmChance);
		List<OmContract> omContractList = omContractService.findList(conOmContract);
		model.addAttribute("omContractList", omContractList);
		
		//查询商机里程
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, crmChance.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		//查询联系提醒
		if(crmChance.getNextcontactDate() != null){			
			int diffDay = DateUtils.differentDaysByMillisecond(new Date(), crmChance.getNextcontactDate());
			System.out.println(diffDay);
			model.addAttribute("diffDay", diffDay);		
		}
		
		return "modules/crm/crmChanceIndex";
	}
	
	/**
	 * 编辑商机表单页面
	 */
	@RequiresPermissions(value={"crm:crmChance:view","crm:crmChance:add","crm:crmChance:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmChance crmChance, Model model) {

		if(crmChance.getOwnBy() == null){
			crmChance.setOwnBy(UserUtils.getUser());
		}
		
		if(crmChance.getIsNewRecord()){
			if(crmChance.getCustomer() != null && crmChance.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(crmChance.getCustomer().getId());
				crmChance.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceForm";
	}
	
	/**
	 * 保存商机
	 */
	@RequiresPermissions(value={"crm:crmChance:add","crm:crmChance:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmChance crmChance, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmChance)){
			return form(crmChance, model);
		}
		
		try{
		
			if(!crmChance.getIsNewRecord()){//编辑表单保存				
				CrmChance t = crmChanceService.get(crmChance.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmChance, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmChanceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			}else{//新增表单保存
				crmChanceService.save(crmChance);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_ADD, crmChance.getId(), crmChance.getName(), crmChance.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存商机成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmChance/index?id="+crmChance.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存商机失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmChance/?repage";
		}
	}
	
	/**
	 * 删除商机
	 */
	@RequiresPermissions("crm:crmChance:del")
	@RequestMapping(value = "delete")
	public String delete(CrmChance crmChance, RedirectAttributes redirectAttributes) {
		crmChanceService.delete(crmChance);
		addMessage(redirectAttributes, "删除商机成功");
		return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmChance/?repage";
	}
	
	@RequestMapping(value = "selectList")
	public String selectList(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmChanceSelectList";
	}
	
	/**
	 * 销售进阶
	 * @param id
	 * @param periodType
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "updateChancePeriod")
	public String updateChancePeriod(String id, String periodType, RedirectAttributes redirectAttributes) {
		try {
			
			CrmChance crmChance = crmChanceService.get(id);
			crmChance.setPeriodType(periodType);
			
			//结算赢单率   销售阶段 1初步恰接，2需求确定，3方案报价，4签订合同,5赢单,6输单
			if("1".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(1);//10%
			}
			if("2".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(3);//30%
			}
			if("3".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(6);//60%
			}
			if("4".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(8);//80%
			}
			if("5".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(10);//100%
			}
			if("6".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(0);//0%
			}
			crmChanceService.save(crmChance);
			addMessage(redirectAttributes, "销售阶段更新成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "销售阶段更新失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmChance/index?id="+id;
		}
	}
}
