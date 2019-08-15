package com.javafast.mobile.crm.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.BrowseLogUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 客户主页Controller(手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmIndex")
public class MobileCrmIndexController extends BaseController {

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
	
	/**
	 * 客户主页
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndex")
	public String crmIndex(String id, Model model) {
		
		//客户信息
		CrmCustomer crmCustomer = crmCustomerService.get(id);
		if(crmCustomer == null) {
			return "modules/crm/crmIndex";
		}
		
		model.addAttribute("crmCustomer", crmCustomer);
		
		//添加浏览足迹
		BrowseLogUtils.addBrowseLog("1", crmCustomer.getId(), crmCustomer.getName());
		
		//查询联系人数
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);		
		Long contacterCount = crmContacterService.findCount(crmContacter);
		model.addAttribute("contacterCount", contacterCount);
		
		//查询跟进记录数
		CrmContactRecord crmContactRecord = new CrmContactRecord();
		crmContactRecord.setTargetId(id);
		Long contactRecordCount = crmContactRecordService.findCount(crmContactRecord);
		model.addAttribute("contactRecordCount", contactRecordCount);
		
		//查询商机数
		CrmChance crmChance =new CrmChance();
		crmChance.setCustomer(crmCustomer);
		Long chanceCount = crmChanceService.findCount(crmChance);
		model.addAttribute("chanceCount", chanceCount);
		
		//查询报价数
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setCustomer(crmCustomer);
		Long quoteCount = crmQuoteService.findCount(crmQuote);
		model.addAttribute("quoteCount", quoteCount);
		
		//查询订单合同数
		OmContract omContract = new OmContract();
		omContract.setCustomer(crmCustomer);
		Long contactCount = omContractService.findCount(omContract);
		model.addAttribute("contactCount", contactCount);
		
		//查询应收款数
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setCustomer(crmCustomer);
		Long receiveAbleCount = fiReceiveAbleService.findCount(fiReceiveAble);
		model.addAttribute("receiveAbleCount", receiveAbleCount);
		
		//查询关联任务数
		OaTask oaTask = new OaTask();
		oaTask.setRelationId(crmCustomer.getId());
		Long taskCount = oaTaskService.findCount(oaTask);
		model.addAttribute("taskCount", taskCount);
		
		//查询日程数
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setCustomerId(crmCustomer.getId());
		Long calendarCount = myCalendarService.findCount(myCalendar);
		model.addAttribute("calendarCount", calendarCount);
		
		//查询附件数量
		CrmDocument crmDocument = new CrmDocument();
		crmDocument.setCustomer(crmCustomer);
		Long docmentCount = crmDocumentService.findCount(crmDocument);
		model.addAttribute("docmentCount", docmentCount);
		
		//查询是否关注
		CrmCustomerStar crmCustomerStar = new CrmCustomerStar();
		crmCustomerStar.setCustomer(crmCustomer);
		crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
		List<CrmCustomerStar> starList = crmCustomerStarService.findList(crmCustomerStar);
		if(starList != null && starList.size()>0){			
			model.addAttribute("isStar", "1");
		}
		
		//客户主页
		return "modules/crm/crmIndex";
	}
	
	/**
	 * 客户主页 - 联系人
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexContacterList")
	public String crmIndexContacterList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		List<CrmContacter> list = crmContacterService.findListByCustomer(crmContacter); 
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexContacterList";
	}
	
	/**
	 * 客户主页 - 沟通
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexContactRecordList")
	public String crmIndexContactRecordList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		CrmContactRecord crmContactRecord = new CrmContactRecord();
		crmContactRecord.setTargetId(crmCustomer.getId());
		List<CrmContactRecord> list = crmContactRecordService.findListByCustomer(crmContactRecord);
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexContactRecordList";
	}
	
	/**
	 * 客户主页 - 商机
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexChanceList")
	public String crmIndexChanceList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		CrmChance crmChance = new CrmChance();
		crmChance.setCustomer(crmCustomer);
		List<CrmChance> list = crmChanceService.findListByCustomer(crmChance); 
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexChanceList";
	}
	
	/**
	 * 客户主页  - 报价
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexQuoteList")
	public String crmIndexQuoteList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setCustomer(crmCustomer);
		List<CrmQuote> list = crmQuoteService.findListByCustomer(crmQuote);
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexQuoteList";
	}
	
	/**
	 * 客户主页  - 合同订单
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexContractList")
	public String crmIndexContractList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		OmContract omContract = new OmContract();
		omContract.setCustomer(crmCustomer);
		List<OmContract> list = omContractService.findListByCustomer(omContract);
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexContractList";
	}
	
	/**
	 * 附件
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "crmIndexDocumentList")
	public String crmIndexDocumentList(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		crmCustomer = crmCustomerService.get(crmCustomer.getId());
		model.addAttribute("crmCustomer", crmCustomer);
		
		CrmDocument crmDocument = new CrmDocument();
		crmDocument.setCustomer(crmCustomer);
		List<CrmDocument> list = crmDocumentService.findListByCustomer(crmDocument);
		model.addAttribute("list", list);
		
		return "modules/crm/crmIndexDocumentList";
	}
}
