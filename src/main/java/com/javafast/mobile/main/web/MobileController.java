package com.javafast.mobile.main.web;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
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
import com.javafast.modules.iim.entity.MailBox;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MailBoxService;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaTask;
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
import com.javafast.modules.report.service.CrmChanceReportService;
import com.javafast.modules.report.service.CrmClueReportService;
import com.javafast.modules.report.service.CrmReportService;
import com.javafast.modules.report.service.HrReportService;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.SysPanelService;
import com.javafast.modules.sys.service.UserService;
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
 * 手机主页 Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile")
public class MobileController extends BaseController{
	
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
	
	@Autowired
	MailBoxService mailBoxService;
	
	/**
	 * 首页
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "index")
	public String index(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//时间范围条件转化
		User user = UserUtils.getUser();
		//本月
		Date startDate = DateUtils.getBeginDayOfMonth();
		Date endDate = DateUtils.getEndDayOfMonth();
				
		//最近商机
		Page<CrmChance> conCrmChancePage = new Page<CrmChance>(request, response);
		conCrmChancePage.setOrderBy("a.create_date desc");
		conCrmChancePage.setPageSize(3);
		Page<CrmChance> crmChancePage = crmChanceService.findPage(conCrmChancePage, new CrmChance()); 
		model.addAttribute("crmChancePage", crmChancePage);
		
		//最近添加客户（最多显示3个）
		Page<CrmCustomer> conCrmCustomerPage = new Page<CrmCustomer>(request, response);
		conCrmCustomerPage.setOrderBy("a.create_date desc");
		conCrmCustomerPage.setPageSize(3);
		Page<CrmCustomer> newCustomerPage = crmCustomerService.findPage(conCrmCustomerPage, new CrmCustomer()); 
		model.addAttribute("newCustomerPage", newCustomerPage);
			
		//最近跟进记录
		Page<CrmContactRecord> conCrmContactRecordPage = new Page<CrmContactRecord>(request, response);
		conCrmContactRecordPage.setOrderBy("a.create_date desc");
		conCrmContactRecordPage.setPageSize(3);
		Page<CrmContactRecord> crmContactRecordPage = crmContactRecordService.findPage(conCrmContactRecordPage, new CrmContactRecord()); 
		model.addAttribute("crmContactRecordPage", crmContactRecordPage);
		
		//客户联系提醒（最多显示3个）
		
		
		
		
		//线索转化率
 		CrmClueReport conCrmClueReport = new CrmClueReport();
 		conCrmClueReport.setUser(user);
 		conCrmClueReport.setAccountId(UserUtils.getUser().getAccountId());
 		conCrmClueReport.setStartDate(startDate);
 		conCrmClueReport.setEndDate(endDate);

 		CrmClueReport crmClueReport = crmClueReportService.findClueReport(conCrmClueReport);
 		request.setAttribute("crmClueReport", crmClueReport);
 		
		//查询销售简报
	    CrmReport conCrmSimpleReport = new CrmReport();
	    conCrmSimpleReport.setStartDate(startDate);
	    conCrmSimpleReport.setEndDate(endDate);
	    conCrmSimpleReport.setAccountId(UserUtils.getUser().getAccountId());
	    conCrmSimpleReport.setUser(user);
	    CrmReport crmSimpleReport = crmReportService.findCustomerReport(conCrmSimpleReport);
	    model.addAttribute("crmSimpleReport", crmSimpleReport);
	    
	    //销售排行榜
  		CrmReport comCrmReportRank = new CrmReport();
  		comCrmReportRank.setAccountId(UserUtils.getUser().getAccountId());
  		comCrmReportRank.setStartDate(startDate);
  		comCrmReportRank.setEndDate(endDate);
  		List<CrmReport> crmReportRankList = crmReportService.findAchReportList(comCrmReportRank);
  		model.addAttribute("crmReportRankList", crmReportRankList);
  		model.addAttribute("firstCrmReport", crmReportRankList.get(0));//销售冠军
	  	
		return "modules/main/index";
	}
	
	/**
	 * 功能菜单
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "menu")
	public String menu(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		return "modules/main/menu";
	}
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "find")
	public String find(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//待办合同订单
		OmContract omContract = new OmContract();
		omContract.setStatus("0");
		//omContract.setOwnBy(UserUtils.getUser());
		Page<OmContract> omContractPage = omContractService.findPage(new Page<OmContract>(request, response), omContract); 
		model.addAttribute("omContractPage", omContractPage);
		  		
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		//fiReceiveAble.setOwnBy(UserUtils.getUser());
		fiReceiveAble.setUnComplete(true);
		Page<FiReceiveAble> fiReceiveAblePage = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response), fiReceiveAble);
		model.addAttribute("fiReceiveAblePage", fiReceiveAblePage);
				
		//待办工单
		CrmService conCrmService = new CrmService();
		conCrmService.setStatus("0");
		//conCrmService.setOwnBy(UserUtils.getUser());
		Page<CrmService> crmServicePage = crmServiceService.findPage(new Page<CrmService>(request, response), conCrmService); 
		model.addAttribute("crmServicePage", crmServicePage);
		
		//待联系客户
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		CrmCustomer crmCustomer = new CrmCustomer();
		crmCustomer.setOwnBy(UserUtils.getUser());
		crmCustomer.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
	    crmCustomer.setEndNextcontactDate(endDate);
	    Page<CrmCustomer> conCrmCustomerPage = new Page<CrmCustomer>(request, response);
	    conCrmCustomerPage.setOrderBy("a.nextcontact_date asc");
		Page<CrmCustomer> contactCustomerPage = crmCustomerService.findPage(conCrmCustomerPage, crmCustomer); 
		model.addAttribute("contactCustomerPage", contactCustomerPage);
		
		return "modules/main/find";
	}
	
	/**
	 * 待办
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "news")
	public String news(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//公告
		OaNotify conOaNotify = new OaNotify();
		conOaNotify.setSelf(true);
		Page<OaNotify> newNotifyPage = oaNotifyService.findPage(new Page<OaNotify>(request, response), conOaNotify);
		model.addAttribute("newNotifyPage", newNotifyPage);
		
		//流程审批
		OaCommonAudit oaCommonAudit =  new OaCommonAudit();
		oaCommonAudit.setCurrentBy(UserUtils.getUser());
		oaCommonAudit.setStatus("1");
		Page<OaCommonAudit> oaCommonAuditPage = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response), oaCommonAudit);
		model.addAttribute("oaCommonAuditPage", oaCommonAuditPage);
		
		//项目
		OaProject oaProject = new OaProject();
		oaProject.setSelf(true);
		oaProject.setIsUnComplete(true);
		Page<OaProject> projectPage = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		model.addAttribute("projectPage", projectPage);
				
		//任务
		OaTask oaTask = new OaTask();
		oaTask.setSelf(true);
		oaTask.setIsUnComplete(true);
		Page<OaTask> taskPage = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("taskPage", taskPage);
		
		//日程
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setBeginStart(DateUtils.getDate());
		myCalendar.setEndStart(DateUtils.formatDateTime(endDate));
		Page<MyCalendar> calenderPage = myCalendarService.findPage(new Page<MyCalendar>(request, response), myCalendar);
		model.addAttribute("calenderPage", calenderPage);
				
		//待办联系
		
				
		return "modules/main/news";
	}
	
	/**
	 * 更多
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "more")
	public String more(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//未读通知
		OaNotify oaNotify = new OaNotify();
		oaNotify.setSelf(true);
		oaNotify.setReadFlag("0");
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify); 
		request.setAttribute("page", page);
		request.setAttribute("notifyCount", page.getCount());//未读通知条数
		
		//未读内部邮件
		MailBox mailBox = new MailBox();
		mailBox.setReceiver(UserUtils.getUser());
		mailBox.setReadstatus("0");//筛选未读
//				Page<MailBox> mailPage = mailBoxService.findPage(new MailPage<MailBox>(request, response), mailBox); 
		request.setAttribute("noReadCount", mailBoxService.getCount(mailBox));//未读内部邮件条数
//				request.setAttribute("mailPage", mailPage);
				
		return "modules/main/more";
	}
	
	/**
	 * 仪表盘
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "dashboard")
	public String dashboard(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Date endDate = DateUtils.getDayAfterN(30);//往后推30天
		
		//公告
		OaNotify conOaNotify = new OaNotify();
		conOaNotify.setSelf(true);
		Page<OaNotify> newNotifyPage = oaNotifyService.findPage(new Page<OaNotify>(request, response), conOaNotify);
		model.addAttribute("newNotifyPage", newNotifyPage);
		
		//流程审批
		OaCommonAudit oaCommonAudit =  new OaCommonAudit();
		oaCommonAudit.setSelf(true);
		oaCommonAudit.setStatus("1");
		Page<OaCommonAudit> oaCommonAuditPage = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response), oaCommonAudit);
		model.addAttribute("oaCommonAuditPage", oaCommonAuditPage);
		
		//项目
		OaProject oaProject = new OaProject();
		oaProject.setSelf(true);
		oaProject.setIsUnComplete(true);
		Page<OaProject> projectPage = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		model.addAttribute("projectPage", projectPage);
				
		//任务
		OaTask oaTask = new OaTask();
		oaTask.setSelf(true);
		oaTask.setIsUnComplete(true);
		Page<OaTask> taskPage = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("taskPage", taskPage);
		
		//日程
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setBeginStart(DateUtils.getDate());
		myCalendar.setEndStart(DateUtils.formatDateTime(endDate));
		Page<MyCalendar> calenderPage = myCalendarService.findPage(new Page<MyCalendar>(request, response), myCalendar);
		model.addAttribute("calenderPage", calenderPage);
				
		//待办联系
		
		
//		//最近需联系客户
//	    CrmCustomer crmCustomer = new CrmCustomer();
//		crmCustomer.setBeginNextcontactDate(new Date());
//	    crmCustomer.setEndNextcontactDate(endDate);
//	    crmCustomer.setOwnBy(UserUtils.getUser());
//	    Page<CrmCustomer> contactCustomerPage = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
//		model.addAttribute("contactCustomerPage", contactCustomerPage);
//		
//		//
		
		//查询销售数据总览
		String type = "M";// 设置默认时间范围，默认当前月
		CrmReport myCrmReport = ReportUtils.getCrmReport(UserUtils.getUser(), "0", UserUtils.getUser().getAccountId());
		model.addAttribute("myCrmReport", myCrmReport);
		
		//浏览足迹
	    Page<SysBrowseLog> browseLogPage = sysBrowseLogService.findPage(new Page<SysBrowseLog>(request, response), new SysBrowseLog());
	    model.addAttribute("browseLogPage", browseLogPage);
	    
		return "modules/main/dashboard";
	}
	
	/**
	 * 看板
	 * @param userType
	 * @param dateType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "report")
	public String report(String userType, String dateType, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		
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
 			
 			orientData.put("初步恰接：" + chanceReport.getPurposeCustomerNum() + "元", 80);
 	 		orientData.put("需求确定：" + chanceReport.getDemandCustomerNum() + "元", 60);
 	 		orientData.put("方案报价：" + chanceReport.getQuoteCustomerNum() + "元", 40);
 	 		orientData.put("合同签订：" + chanceReport.getDealOrderNum() + "元", 20);
 	 		orientData.put("赢单：" + chanceReport.getCompleteOrderNum() + "元", 10);
 		}else {
 			orientData.put("初步恰接：0元", 80);
 			orientData.put("需求确定：0元", 60);
 			orientData.put("方案报价：0元", 40);
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
  		
		return "modules/main/report";
	}
	
	//关于我们
	@RequestMapping(value = "about")
	public String about() {
		System.out.println("===========about=========");
		return "modules/main/about";
	}
	
	//联系客服
	@RequestMapping(value = "contact")
	public String contact() {
		return "modules/main/contact";
	}
}
