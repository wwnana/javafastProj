package com.javafast.modules.main.web;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.web.BaseController;
import com.javafast.common.websocket.onchat.ChatServerPool;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmMarketService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.crm.service.CrmServiceService;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.entity.FiPaymentBill;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiPaymentAbleService;
import com.javafast.modules.fi.service.FiPaymentBillService;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.gen.entity.GenReport;
import com.javafast.modules.gen.service.GenReportService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaNotifyService;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.oa.service.OaWorkLogService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.report.entity.CrmChanceReport;
import com.javafast.modules.report.entity.CrmClueReport;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.entity.HrReport;
import com.javafast.modules.report.service.CrmChanceReportService;
import com.javafast.modules.report.service.CrmClueReportService;
import com.javafast.modules.report.service.CrmReportService;
import com.javafast.modules.report.service.HrReportService;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.SysPanel;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.SysPanelService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.entity.WmsPurchase;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.service.WmsInstockService;
import com.javafast.modules.wms.service.WmsOutstockService;
import com.javafast.modules.wms.service.WmsPurchaseService;
import com.javafast.modules.wms.service.WmsStockService;

/**
 * 主页 Controller
 */
@Controller
public class HomeController extends BaseController{
	
	@Autowired
	private OaNotifyService oaNotifyService;
	
	@Autowired
	private OaWorkLogService oaWorkLogService;
	
	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private MyCalendarService myCalendarService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
		
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	@Autowired
	private FiPaymentBillService fiPaymentBillService;
	
	@Autowired
	private SysBrowseLogService sysBrowseLogService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private WmsPurchaseService wmsPurchaseService;
	
	@Autowired
	private WmsInstockService wmsInstockService;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@Autowired
	private WmsStockService wmsStockService;
	
	@Autowired
	private GenReportService genReportService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmReportService crmReportService;
	
	@Autowired
	HrReportService hrReportService;
	
	@Autowired
	private OaProjectService oaProjectService;
	
	@Autowired
	private SysPanelService sysPanelService;
	
	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private CrmMarketService crmMarketService;
	
	@Autowired
	private CrmServiceService crmServiceService;
	
	@Autowired
	CrmChanceReportService crmChanceReportService;
	
	@Autowired
	CrmClueReportService crmClueReportService;
	
	/**
	 * 仪表盘
	 * @param userType 用户范围：0：本人，1：部门，2：公司
	 * @param dateType 日期范围： C当天，L昨日，W本周，LW上周，M本月，Q：本季度，Y：本年
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/home")
	public String dashboard(String userType, String dateType, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		
		//时间范围条件转化
		if(StringUtils.isBlank(userType)) {
			userType = "0"; //默认为当前用户
			//总负责人，默认查询全公司
			if("1".equals(UserUtils.getUser().getUserType())) {
				userType = "1"; //默认为当前用户
			}
		}
		if(StringUtils.isBlank(dateType)) {
			dateType = "M"; //默认为本月
		}
		
		System.out.println(userType);
		System.out.println(dateType);
		request.setAttribute("userType", userType);
		request.setAttribute("dateType", dateType);
		
		User user = null;
		
		if("0".equals(userType)) {
			user = UserUtils.getUser();
		}

		Date startDate = null;  //开始时间
		Date endDate = null;   //结束时间
				
		//当天
		if("C".equals(dateType)){
			startDate = DateUtils.getDayBegin();
			endDate = DateUtils.getDayEnd();
		}
		//昨日
		if("L".equals(dateType)){
			startDate = DateUtils.getBeginDayOfYesterday();
			endDate = DateUtils.getEndDayOfYesterDay();
		}
		//本周
		if("W".equals(dateType)){
			startDate = DateUtils.getBeginDayOfWeek();
			endDate = DateUtils.getEndDayOfWeek();
		}
		//上周
		if("LW".equals(dateType)){
			startDate = DateUtils.getBeginDayOfLastWeek();
			endDate = DateUtils.getBeginDayOfLastWeek();
		}
		//本月
		if("M".equals(dateType)){
			startDate = DateUtils.getBeginDayOfMonth();
			endDate = DateUtils.getEndDayOfMonth();
		}
		//上月
		if("LM".equals(dateType)){
			startDate = DateUtils.getBeginDayOfLastMonth();
			endDate = DateUtils.getEndDayOfLastMonth();
		}
		//本季度
		if("Q".equals(dateType)){
			startDate = DateUtils.getCurrentQuarterStartTime();
			endDate = DateUtils.getCurrentQuarterEndTime();
		}
		//本年
		if("Y".equals(dateType)){
			startDate = DateUtils.getBeginDayOfYear();
			endDate = DateUtils.getEndDayOfYear();
		}
	  	
	    //查询销售简报
	    CrmReport conCrmSimpleReport = new CrmReport();
	    conCrmSimpleReport.setStartDate(startDate);
	    conCrmSimpleReport.setEndDate(endDate);
	    conCrmSimpleReport.setAccountId(UserUtils.getUser().getAccountId());
	    conCrmSimpleReport.setUser(user);
	    CrmReport crmSimpleReport = crmReportService.findCustomerReport(conCrmSimpleReport);
	    model.addAttribute("crmSimpleReport", crmSimpleReport);
	  		
	    //销售漏斗
	    CrmChanceReport conCrmChanceReport = new CrmChanceReport();
	    conCrmChanceReport.setStartDate(startDate);
	    conCrmChanceReport.setEndDate(endDate);
	    conCrmChanceReport.setAccountId(UserUtils.getUser().getAccountId());
 		conCrmChanceReport.setUser(user);
 		
// 		CrmChanceReport chanceReport = crmChanceReportService.findChanceReport(conCrmChanceReport);
// 		request.setAttribute("chanceReport", chanceReport);
// 	
// 		//构建销售漏斗数据
// 		Map<String,Object> orientData = new LinkedHashMap<String,Object>();//LinkedHashMap是有序的MAP实现
// 		if(chanceReport.getTotalChanceNum() != 0) {
// 			
// 			orientData.put("01.初步恰接", chanceReport.getPurposeCustomerNum()*100/chanceReport.getTotalChanceNum());
// 	 		orientData.put("02.需求确定", chanceReport.getDemandCustomerNum()*100/chanceReport.getTotalChanceNum());
// 	 		orientData.put("03.方案报价", chanceReport.getQuoteCustomerNum()*100/chanceReport.getTotalChanceNum());
// 	 		orientData.put("04.合同签订", chanceReport.getDealOrderNum()*100/chanceReport.getTotalChanceNum());
// 	 		orientData.put("05.赢单", chanceReport.getCompleteOrderNum()*100/chanceReport.getTotalChanceNum());
// 		}else {
// 			orientData.put("01.初步恰接", 0);
// 			orientData.put("02.需求确定", 0);
// 			orientData.put("03.方案报价", 0);
// 			orientData.put("04.合同签订", 0);
// 			orientData.put("05.赢单", 0);
// 		}
// 		request.setAttribute("orientData", orientData);
 		
 		CrmChanceReport chanceReport = crmChanceReportService.findChanceAmountReport(conCrmChanceReport);
 		request.setAttribute("chanceReport", chanceReport);
 	
 		//构建销售漏斗数据
 		Map<String,Object> orientData = new LinkedHashMap<String,Object>();//LinkedHashMap是有序的MAP实现
 		if(chanceReport.getTotalChanceNum() != 0) {
 			
 			orientData.put("初步恰接：" + chanceReport.getPurposeCustomerNum() + "元", 50);
 	 		orientData.put("需求确定：" + chanceReport.getDemandCustomerNum() + "元", 40);
 	 		orientData.put("方案报价：" + chanceReport.getQuoteCustomerNum() + "元", 30);
 	 		orientData.put("合同签订：" + chanceReport.getDealOrderNum() + "元", 20);
 	 		orientData.put("赢单：" + chanceReport.getCompleteOrderNum() + "元", 10);
 		}else {
 			orientData.put("初步恰接：0元", 50);
 			orientData.put("需求确定：0元", 40);
 			orientData.put("方案报价：0元", 30);
 			orientData.put("合同签订：0元", 20);
 			orientData.put("赢单：0元", 10);
 		}
 		request.setAttribute("orientData", orientData);
 		
 		//线索转化率
 		CrmClueReport conCrmClueReport = new CrmClueReport();
 		conCrmClueReport.setUser(user);
 		conCrmClueReport.setAccountId(UserUtils.getUser().getAccountId());
 		conCrmClueReport.setStartDate(startDate);
 		conCrmClueReport.setEndDate(endDate);

 		CrmClueReport crmClueReport = crmClueReportService.findClueReport(conCrmClueReport);
 		request.setAttribute("crmClueReport", crmClueReport);
	
		//销售排行榜
		CrmReport comCrmReportRank = new CrmReport();
		comCrmReportRank.setAccountId(UserUtils.getUser().getAccountId());
		comCrmReportRank.setStartDate(startDate);
		comCrmReportRank.setEndDate(endDate);
		List<CrmReport> crmReportRankList = crmReportService.findAchReportList(comCrmReportRank);
		model.addAttribute("crmReportRankList", crmReportRankList);
		model.addAttribute("firstCrmReport", crmReportRankList.get(0));//销售冠军
		
		
		//动态
		Page<SysDynamic> conSysDynamicPage = new Page<SysDynamic>(request, response);
		conSysDynamicPage.setPageSize(10);
		Page<SysDynamic> sysDynamicPage = sysDynamicService.findPage(conSysDynamicPage, new SysDynamic());
	  	model.addAttribute("sysDynamicPage", sysDynamicPage);
	  	
	  	//浏览足迹
	  	Page<SysBrowseLog> conSysBrowseLogPage = new Page<SysBrowseLog>(request, response);
	  	conSysBrowseLogPage.setPageSize(10);
	    Page<SysBrowseLog> browseLogPage = sysBrowseLogService.findPage(conSysBrowseLogPage, new SysBrowseLog());
	    model.addAttribute("browseLogPage", browseLogPage);
	  	
	    //公告
//	    Page conOaNotifyPage = new Page<OaNotify>(request, response);
//	    conOaNotifyPage.setPageSize(5);
//  		OaNotify conOaNotify = new OaNotify();
//  		conOaNotify.setSelf(true);
//  		Page<OaNotify> newNotifyPage = oaNotifyService.findPage(conOaNotifyPage, conOaNotify);
//  		model.addAttribute("newNotifyPage", newNotifyPage);
  		
  		//待办合同订单
		OmContract omContract = new OmContract();
		omContract.setStatus("0");
		//omContract.setOwnBy(UserUtils.getUser());
		Page<OmContract> conOmContractPage = new Page<OmContract>(request, response);
		conOmContractPage.setPageSize(8);
		Page<OmContract> omContractPage = omContractService.findPage(conOmContractPage, omContract); 
		model.addAttribute("omContractPage", omContractPage);
		  		
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		//fiReceiveAble.setOwnBy(UserUtils.getUser());
		fiReceiveAble.setUnComplete(true);
		Page<FiReceiveAble> conFiReceiveAblePage = new Page<FiReceiveAble>(request, response);
		conFiReceiveAblePage.setPageSize(8);
		Page<FiReceiveAble> fiReceiveAblePage = fiReceiveAbleService.findPage(conFiReceiveAblePage, fiReceiveAble);
		model.addAttribute("fiReceiveAblePage", fiReceiveAblePage);
				
		//待办工单
		CrmService conCrmService = new CrmService();
		conCrmService.setStatus("0");
		//conCrmService.setOwnBy(UserUtils.getUser());
		Page<CrmService> conCrmServicePage = new Page<CrmService>(request, response);
		conCrmServicePage.setPageSize(8);
		Page<CrmService> crmServicePage = crmServiceService.findPage(conCrmServicePage, conCrmService); 
		model.addAttribute("crmServicePage", crmServicePage);
		
		//最近需联系客户
		CrmCustomer crmCustomer = new CrmCustomer();
		//crmCustomer.setOwnBy(UserUtils.getUser());
		crmCustomer.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
	    crmCustomer.setEndNextcontactDate(DateUtils.getDayAfterN(7));
	    Page<CrmCustomer> conCrmCustomerPage = new Page<CrmCustomer>(request, response);
	    conCrmCustomerPage.setOrderBy("a.nextcontact_date asc");
	    conCrmCustomerPage.setPageSize(8);
		Page<CrmCustomer> contactCustomerPage = crmCustomerService.findPage(conCrmCustomerPage, crmCustomer); 
		model.addAttribute("contactCustomerPage", contactCustomerPage);
		
		//最近需联系商机
		CrmChance conCrmChance = new CrmChance();
		//conCrmChance.setOwnBy(UserUtils.getUser());
		conCrmChance.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
		conCrmChance.setEndNextcontactDate(DateUtils.getDayAfterN(7));
		Page<CrmChance> conCrmChancePage = new Page<CrmChance>(request, response);
		conCrmChancePage.setOrderBy("a.nextcontact_date asc");
		conCrmChancePage.setPageSize(8);
		Page<CrmChance> contactChancePage = crmChanceService.findPage(conCrmChancePage, conCrmChance); 
		model.addAttribute("contactChancePage", contactChancePage);
  		
		return "modules/main/sysHome";
	}
	
	/**
	 * 动态
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/sysDynamic")
	public String home(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, Model model) {
	    
	    //查询动态
		Page<SysDynamic> sysDynamicPage = sysDynamicService.findPage(new Page<SysDynamic>(request, response), new SysDynamic());
	  	model.addAttribute("sysDynamicPage", sysDynamicPage);
	    
		
		return "modules/main/sysDynamic";		
	}
	
	
	/**
	 * 办公主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/oaHome")
	public String oaHome(HttpServletRequest request, HttpServletResponse response, Model model) {
			
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//公告
		OaNotify conOaNotify = new OaNotify();
		conOaNotify.setSelf(true);
		Page<OaNotify> newNotifyPage = oaNotifyService.findPage(new Page<OaNotify>(request, response), conOaNotify);
		model.addAttribute("newNotifyPage", newNotifyPage);
		
		//日程
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setBeginStart(DateUtils.getDate());
		myCalendar.setEndStart(DateUtils.formatDateTime(endDate));
		Page<MyCalendar> calenderPage = myCalendarService.findPage(new Page<MyCalendar>(request, response), myCalendar);
		model.addAttribute("calenderPage", calenderPage);
		
		//流程审批
		OaCommonAudit oaCommonAudit =  new OaCommonAudit();
		oaCommonAudit.setStatus("1");
		oaCommonAudit.setCurrentBy(UserUtils.getUser());
		Page<OaCommonAudit> oaCommonAuditPage = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response), oaCommonAudit);
		model.addAttribute("oaCommonAuditPage", oaCommonAuditPage);
		
		//日志
		OaWorkLog oaWorkLog = new OaWorkLog();
		oaWorkLog.setSelf(true);
		Page<OaWorkLog> oaWorkLogPage = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response), oaWorkLog); 
		model.addAttribute("oaWorkLogPage", oaWorkLogPage);
		
		return "modules/main/oaHome";		
	}
	
	/**
	 * 项目主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/pmHome")
	public String pmHome(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//项目
		OaProject oaProject = new OaProject();
		oaProject.setSelf(true);
		Page<OaProject> projectPage = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		model.addAttribute("projectPage", projectPage);
		
		//项目总数量
		Long projectCount = projectPage.getCount();
		model.addAttribute("projectCount", projectCount);
		
		//我负责的
		oaProject.setOwnBy(UserUtils.getUser());
		Long ownProjectCount = oaProjectService.findCount(oaProject);
		model.addAttribute("ownProjectCount", ownProjectCount);
		
				
		//我的任务列表
		OaTask oaTask = new OaTask();
		oaTask.setSelf(true);
		Page<OaTask> taskPage = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("taskPage", taskPage);
		
		//任务总数量
		Long taskCount = taskPage.getCount();
		model.addAttribute("taskCount", taskCount);
		
		//我负责的
		oaTask.setOwnBy(UserUtils.getUser());
		Long ownTaskCount = oaTaskService.findCount(oaTask);
		model.addAttribute("ownTaskCount", ownTaskCount);
				
		return "modules/main/pmHome";		
	}
	
	/**
	 * 客户主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/crmHome")
	public String crmHome(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//最近需联系客户
		crmCustomer.setOwnBy(UserUtils.getUser());
		crmCustomer.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
	    crmCustomer.setEndNextcontactDate(endDate);
	    Page<CrmCustomer> conCrmCustomerPage = new Page<CrmCustomer>(request, response);
	    conCrmCustomerPage.setOrderBy("a.nextcontact_date asc");
		Page<CrmCustomer> contactCustomerPage = crmCustomerService.findPage(conCrmCustomerPage, crmCustomer); 
		model.addAttribute("contactCustomerPage", contactCustomerPage);
		
		//最近需联系商机
		CrmChance conCrmChance = new CrmChance();
		conCrmChance.setOwnBy(UserUtils.getUser());
		conCrmChance.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
		conCrmChance.setEndNextcontactDate(endDate);
		Page<CrmChance> conCrmChancePage = new Page<CrmChance>(request, response);
		conCrmChancePage.setOrderBy("a.nextcontact_date asc");
		Page<CrmChance> contactChancePage = crmChanceService.findPage(conCrmChancePage, conCrmChance); 
		model.addAttribute("contactChancePage", contactChancePage);
		
//		//查询我负责的客户数
//		Long customerCount = crmCustomerService.findCount(crmCustomer);
//		model.addAttribute("customerCount", customerCount);
//		
//		//查询我负责的商机数
//		CrmChance crmChance = new CrmChance();
//		crmChance.setOwnBy(UserUtils.getUser());
//		Long chanceCount = crmChanceService.findCount(crmChance);
//		model.addAttribute("chanceCount", chanceCount);
//		
//		//查询我负责的报价单数
//		CrmQuote crmQuote = new CrmQuote();
//		crmQuote.setOwnBy(UserUtils.getUser());
//		Long quoteCount = crmQuoteService.findCount(crmQuote);
//		model.addAttribute("quoteCount", quoteCount);
//		
//		//查询我负责的订单数
//		OmContract omContract = new OmContract();
//		omContract.setOwnBy(UserUtils.getUser());
//		Long contractCount = omContractService.findCount(omContract);
//		model.addAttribute("contractCount", contractCount);
//		
//		//查询我负责的应收款数
//		FiReceiveAble fiReceiveAble = new FiReceiveAble();
//		fiReceiveAble.setOwnBy(UserUtils.getUser());
//		Long receiveAbleCount = fiReceiveAbleService.findCount(fiReceiveAble);
//		model.addAttribute("receiveAbleCount", receiveAbleCount);
		
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		//fiReceiveAble.setOwnBy(UserUtils.getUser());
		fiReceiveAble.setUnComplete(true);
		Page<FiReceiveAble> fiReceiveAblePage = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response), fiReceiveAble);
		model.addAttribute("fiReceiveAblePage", fiReceiveAblePage);
		
	    //待办报价单
	    CrmQuote crmQuote = new CrmQuote();
	    //crmQuote.setOwnBy(UserUtils.getUser());
	    crmQuote.setStatus("0");
	    Page<CrmQuote> crmQuotePage = crmQuoteService.findPage(new Page<CrmQuote>(request, response), crmQuote); 
		model.addAttribute("crmQuotePage", crmQuotePage);
	    
	    //待办合同订单
		OmContract omContract = new OmContract();
		omContract.setStatus("0");
		//omContract.setOwnBy(UserUtils.getUser());
		Page<OmContract> omContractPage = omContractService.findPage(new Page<OmContract>(request, response), omContract); 
		model.addAttribute("omContractPage", omContractPage);
		
		//查询销售数据总览
		String type = "";// 设置默认时间范围，默认当前月
		CrmReport myCrmReport = ReportUtils.getCrmReport(UserUtils.getUser(), "0", UserUtils.getUser().getAccountId());
		model.addAttribute("myCrmReport", myCrmReport);
				
		//浏览足迹
	    Page<SysBrowseLog> browseLogPage = sysBrowseLogService.findPage(new Page<SysBrowseLog>(request, response), new SysBrowseLog());
	    model.addAttribute("browseLogPage", browseLogPage);
	    
		return "modules/main/crmHome";		
	}
	
	/**
	 * 活动线索分析
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/clueHome")
	public String clueHome(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//活动线索简报，活动次数，线索次数，未转化线索，已转化线索
		
		
		//进行中的活动
		CrmMarket conCrmMarket = new CrmMarket();
		Page<CrmMarket> crmMarketPage = crmMarketService.findPage(new Page<CrmMarket>(request, response), conCrmMarket); 
		model.addAttribute("crmMarketPage", crmMarketPage);
		
		//待转化线索
		CrmClue conCrmClue = new CrmClue();
		conCrmClue.setIsChange("0");//默认查询未转化的
		Page<CrmClue> crmCluePage = crmClueService.findPage(new Page<CrmClue>(request, response), conCrmClue); 
		model.addAttribute("crmCluePage", crmCluePage);
		
		return "modules/main/clueHome";		
	}
	
	/**
	 * 服务工单分析
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/serviceHome")
	public String serviceHome(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//服务简报，待完成工单总数，已完成工单总数
		
		
		//未处理工单
		CrmService conCrmService = new CrmService();
		conCrmService.setStatus("0");
		Page<CrmService> unCrmServicePage = crmServiceService.findPage(new Page<CrmService>(request, response), conCrmService); 
		model.addAttribute("unCrmServicePage", unCrmServicePage);	
		
		//已经完成待审核工单
		conCrmService.setStatus("2");
		Page<CrmService> completedCrmServicePage = crmServiceService.findPage(new Page<CrmService>(request, response), conCrmService); 
		model.addAttribute("completedCrmServicePage", completedCrmServicePage);
		
		//
		
		return "modules/main/serviceHome";		
	}
	
	
	/**
	 * 进销存主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/wmsHome")
	public String wmsHome(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//待审核的采购单
		WmsPurchase wmsPurchase = new WmsPurchase();
		wmsPurchase.setStatus("0");
		Page<WmsPurchase> wmsPurchasePage = wmsPurchaseService.findPage(new Page<WmsPurchase>(request, response), wmsPurchase); 
		model.addAttribute("wmsPurchasePage", wmsPurchasePage);
		
		//入库
		WmsInstock wmsInstock = new WmsInstock();
		wmsInstock.setStatus("0");
		Page<WmsInstock> wmsInstockPage = wmsInstockService.findPage(new Page<WmsInstock>(request, response), wmsInstock); 
		model.addAttribute("wmsInstockPage", wmsInstockPage);
		
		//出库
		WmsOutstock wmsOutstock = new WmsOutstock();
		wmsOutstock.setStatus("0");
		Page<WmsOutstock> wmsOutstockPage = wmsOutstockService.findPage(new Page<WmsOutstock>(request, response), wmsOutstock); 
		model.addAttribute("wmsOutstockPage", wmsOutstockPage);
		
		//盘点
		
		//库存预警
		WmsStock wmsStock = new WmsStock();
		Page<WmsStock> wmsStockPage = wmsStockService.findWarnPage(new Page<WmsStock>(request, response), wmsStock); 
		model.addAttribute("wmsStockPage", wmsStockPage);
		
		return "modules/main/wmsHome";		
	}
	
	/**
	 * 财务主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/fiHome")
	public String fiHome(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setUnComplete(true);
		Page<FiReceiveAble> fiReceiveAblePage = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response), fiReceiveAble); 
		model.addAttribute("fiReceiveAblePage", fiReceiveAblePage);
		
		//应付款
		FiPaymentAble fiPaymentAble = new FiPaymentAble();
		fiPaymentAble.setUnComplete(true);
		Page<FiPaymentAble> fiPaymentAblePage = fiPaymentAbleService.findPage(new Page<FiPaymentAble>(request, response), fiPaymentAble); 
		model.addAttribute("fiPaymentAblePage", fiPaymentAblePage);
		
		//收款单
		FiReceiveBill fiReceiveBill = new FiReceiveBill();
		fiReceiveBill.setStatus("0");
		Page<FiReceiveBill> fiReceiveBillPage = fiReceiveBillService.findPage(new Page<FiReceiveBill>(request, response), fiReceiveBill); 
		model.addAttribute("fiReceiveBillPage", fiReceiveBillPage);
		
		//付款单
		FiPaymentBill fiPaymentBill = new FiPaymentBill();
		fiPaymentBill.setStatus("0");
		Page<FiPaymentBill> fiPaymentBillPage = fiPaymentBillService.findPage(new Page<FiPaymentBill>(request, response), fiPaymentBill); 
		model.addAttribute("fiPaymentBillPage", fiPaymentBillPage);
		
		return "modules/main/fiHome";		
	}
		
	@RequestMapping(value = "${adminPath}/hrHome")
	public String hrHome(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天

		
		return "modules/main/hrHome";		
	}
	
	
	/**
	 * 报表主页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/reportHome")
	public String reportHome(GenReport genReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		genReport.setStatus("1");
		Page<GenReport> page = genReportService.findPage(new Page<GenReport>(request, response), genReport); 
		model.addAttribute("page", page);
		
		return "modules/main/reportHome";	
	}
	
	/**
	 * 引导页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/sysGuide")
	public String guide(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/main/sysGuide";		
	}
	
	/**
	 * 帮助页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/sysHelp")
	public String sysHelp(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		return "modules/main/sysHelp";		
	}
	
	@RequestMapping(value = "${adminPath}/sysAbout")
	public String sysAbout(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		return "modules/main/sysAbout";		
	}
	
	/**
	 * 获取在线用户
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/getOnlineUser")
	public String getOnlineUser(HttpServletRequest request, HttpServletResponse response, Model model) {
	
		//查询在线用户
		Collection<String> onlineUsers = ChatServerPool.getOnlineUser();
		for(String userId : onlineUsers){
			System.out.println(userId);
		}
		
		//查询所有用户
		List<User> onlineUserList = new ArrayList<User>();
		List<User> userList = userService.findUser(new User());
		for(User user : userList){
			
			//只添加在线的用户到LIST
			if(onlineUsers.contains(user.getLoginName())){
				onlineUserList.add(user);
			}
		}		
		
		model.addAttribute("onlineUserList", onlineUserList);
		return "modules/main/onlineUser";		
	}
}
