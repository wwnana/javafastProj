package com.javafast.mobile.crm.web;

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
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.crm.service.CrmServiceService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.BrowseLogUtils;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 客户Controller(手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmCustomer")
public class MobileCrmCustomerController extends BaseController {

	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private CrmCustomerStarService crmCustomerStarService;
	
	@Autowired
	private MyCalendarService myCalendarService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmDocumentService crmDocumentService;
	
	@Autowired
	private CrmServiceService crmServiceService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public CrmCustomer get(@RequestParam(required=false) String id) {
		CrmCustomer entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmCustomerService.get(id);
		}
		if (entity == null){
			entity = new CrmCustomer();
		}
		return entity;
	}
	
	/**
	 * 客户列表页面
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmCustomerList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response){
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			crmCustomer.setOwnBy(new User(ownById));
		Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmCustomer crmCustomer, Model model) {		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerSearch";
	}
	
	/**
	 * 公海客户列表页面
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "pool")
	public String pool(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		crmCustomer.setIsPool("1");
		Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
		model.addAttribute("page", page);
		return "modules/crm/crmCustomerPoolList";
	}
	
	/**
	 * 客户详情页面
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "index")
	public String index(CrmCustomer crmCustomer, Model model) {
		model.addAttribute("crmCustomer", crmCustomer);
		
		//添加浏览足迹
		BrowseLogUtils.addBrowseLog("1", crmCustomer.getId(), crmCustomer.getName());
		
		//查询联系人
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		List<CrmContacter> crmContacterList = crmContacterService.findListByCustomer(crmContacter); 
		model.addAttribute("crmContacterList", crmContacterList);
		
		//查询商机
		CrmChance crmChance = new CrmChance();
		crmChance.setCustomer(crmCustomer);
		List<CrmChance> crmChanceList = crmChanceService.findListByCustomer(crmChance); 
		model.addAttribute("crmChanceList", crmChanceList);
		
		//查询跟进记录
		CrmContactRecord crmContactRecord = new CrmContactRecord();
		crmContactRecord.setTargetId(crmCustomer.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByCustomer(crmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
		
		//查询报价
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setCustomer(crmCustomer);
		List<CrmQuote> crmQuoteList = crmQuoteService.findListByCustomer(crmQuote);
		model.addAttribute("crmQuoteList", crmQuoteList);
		
		//查询订单合同
		OmContract omContract = new OmContract();
		omContract.setCustomer(crmCustomer);
		List<OmContract> omContractList = omContractService.findListByCustomer(omContract);
		model.addAttribute("omContractList", omContractList);
		
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setCustomer(crmCustomer);
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findListByCustomer(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		//查询服务工单
		CrmService conCrmService = new CrmService();
		conCrmService.setCustomer(crmCustomer);
		List<CrmService> crmServiceList = crmServiceService.findList(conCrmService);
		model.addAttribute("crmServiceList", crmServiceList);
		
		//查询关联任务
		OaTask oaTask = new OaTask();
		oaTask.setRelationId(crmCustomer.getId());
		List<OaTask> oaTaskList = oaTaskService.findList(oaTask);
		model.addAttribute("oaTaskList", oaTaskList);
		
		//查询日程数
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setCustomerId(crmCustomer.getId());
		Long calendarCount = myCalendarService.findCount(myCalendar);
		model.addAttribute("calendarCount", calendarCount);
		
		//查询附件
		CrmDocument crmDocument = new CrmDocument();
		crmDocument.setCustomer(crmCustomer);
		List<CrmDocument> crmDocumentList = crmDocumentService.findList(crmDocument);
		model.addAttribute("crmDocumentList", crmDocumentList);
		
		//查询是否关注
		CrmCustomerStar crmCustomerStar = new CrmCustomerStar();
		crmCustomerStar.setCustomer(crmCustomer);
		crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
		List<CrmCustomerStar> starList = crmCustomerStarService.findList(crmCustomerStar);
		if(starList != null && starList.size()>0){			
			model.addAttribute("isStar", "1");
		}
		
		//查询客户日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(crmCustomer.getId(), true));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//客户信息
		model.addAttribute("crmCustomer", crmCustomer);
		
		//查询客户概况统计
		CrmCustomer generalCout = crmCustomerService.getGeneralCountByCustomer(crmCustomer.getId());
		model.addAttribute("generalCout", generalCout);
		
		return "modules/crm/crmCustomerIndex";
	}
	
	/**
	 * 编辑客户表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmCustomer crmCustomer, Model model) {
		
		if(crmCustomer.getIsNewRecord()){			
			if(crmCustomer.getOwnBy() == null){
				crmCustomer.setOwnBy(UserUtils.getUser());
			}
		}
		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerForm";
	}
	
	/**
	 * 保存客户
	 * @param crmCustomer
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmCustomer crmCustomer, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, crmCustomer)){
			return form(crmCustomer, model);
		}
		
		try{
						
			if(!crmCustomer.getIsNewRecord()){//编辑表单保存
				CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmCustomer, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmCustomerService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getId());
			}else{

				crmCustomerService.save(crmCustomer);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_ADD, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			}
			addMessage(redirectAttributes, "保存客户成功");
			
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/?repage";
		}		
	}
	
	/**
	 * 删除
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		crmCustomerService.delete(crmCustomer);
		DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DEL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
		addMessage(redirectAttributes, "删除客户成功");
		return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/list?repage";
	}
	
	/**
	 * 领取客户
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "receipt")
	public String receipt(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		try{
			
			//判断是否已经被领取
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			if("0".equals(t.getIsPool())) {
				addMessage(redirectAttributes, "对不起，该客户刚刚已被其他人领取了");
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
			}
			
			//更新客户负责人和负责人部门信息	
			t.setOwnBy(UserUtils.getUser());
			t.setOfficeId(UserUtils.getUser().getOffice().getId());
			crmCustomerService.updateOwnBy(t);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DRAW, t.getId(), t.getName(), t.getId());
			addMessage(redirectAttributes, "领取客户成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "客户领取失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * 放入公海
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "toPool")
	public String toPool(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		
		try{
			
			//判断是否已经被领取
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			if("1".equals(t.getIsPool())) {
				addMessage(redirectAttributes, "客户已经放入公海");
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
			}
			
			crmCustomerService.throwToPool(crmCustomer);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_POOL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			addMessage(redirectAttributes, "放入公海成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "放入公海失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * 客户指派表单页面
	 */
	@RequestMapping(value = "shareForm")
	public String shareForm(CrmCustomer crmCustomer, Model model) {
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerShareForm";
	}
	
	/**
	 * 保存客户指派
	 * @param crmCustomer
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "saveShare")
	public String saveShare(CrmCustomer crmCustomer, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, crmCustomer)){
			return form(crmCustomer, model);
		}
		
		try{
			
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			
			User user = userService.getUserByDb(crmCustomer.getOwnBy().getId());
			t.setOwnBy(user);
			t.setOfficeId(user.getOfficeId());
			crmCustomerService.updateOwnBy(t);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_APPOINT, t.getId(), t.getName(), t.getId());
			addMessage(redirectAttributes, "指派客户成功");
			
			//消息提醒
			String isMsg = request.getParameter("isMsg");
			String isSmsMsg = request.getParameter("isSmsMsg");
			ReportUtils.sendWxMsg(crmCustomer, isMsg, isSmsMsg);
			
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "指派客户失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * 客户选择器
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmCustomerSelectList";
	}
	
	@RequestMapping(value = "selectListForRecord")
	public String selectListForRecord(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmCustomerSelectListForRecord";
	}
}
