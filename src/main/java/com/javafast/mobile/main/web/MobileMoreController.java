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
 * 更多 Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/more")
public class MobileMoreController extends BaseController{
	
	@Autowired
	HrReportService hrReportService;
	
	@Autowired
	CrmChanceReportService crmChanceReportService;
	
	@Autowired
	CrmClueReportService crmClueReportService;
	
	@Autowired
	MailBoxService mailBoxService;
	
	//设置
	@RequestMapping(value = "set")
	public String set(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/more/set";
	}
	
	/**
	 * 账号
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "userInfo")
	public String userInfo(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/more/userInfo";
	}
	
	@RequestMapping(value = "version")
	public String version() {
		return "modules/more/version";
	}
	
	//关于我们
	@RequestMapping(value = "about")
	public String about() {
		return "modules/more/about";
	}
	
	//联系客服
	@RequestMapping(value = "contact")
	public String contact() {
		return "modules/more/contact";
	}
	
	/**
	 * 权限管理
	 * @return
	 */
	@RequestMapping(value = "permission")
	public String permission() {
		return "modules/more/permission";
	}
}
