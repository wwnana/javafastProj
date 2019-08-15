package com.javafast.modules.report.utils;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.dao.CrmReportDao;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 报表数据工具类
 * @author JavaFast
 */
public class ReportUtils {
	
	private static CrmReportDao crmReportDao = SpringContextHolder.getBean(CrmReportDao.class);
	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
	
	//获取CRM INDEX page
  	private static final String request_url_crm_index = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/crm/crmCustomer/index";
  	
	/**
	 * 获取销售数据统计
	 * @param user 用户
	 * @param dateType 日期范围： C当天，L昨日，W本周，LW上周，M本月，Q：本季度，Y：本年
	 * @return
	 */
	public static CrmReport getCrmReport(User user, String dateType, String accountId){
		
		//默认为本月
		if(StringUtils.isBlank(dateType)) {
			dateType = "M"; 
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
	    conCrmSimpleReport.setAccountId(accountId);
	    conCrmSimpleReport.setUser(user);
	    CrmReport crmSimpleReport = crmReportDao.findCustomerReport(conCrmSimpleReport);
		
		return crmSimpleReport;
	}
	
	/**
	 * 获取团队销售数据统计缓存（默认本月）
	 * @param accountId 企业账号
	 * @param dateType C当天，Y昨日，W本周，L上周，M本月
	 * @return
	 */
	public static List<CrmReport> getCrmReportList(String accountId, String dateType){
		
		//从数据库查询
		CrmReport conCrmReport = new CrmReport();
		
		//时间范围条件转化
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
		
		conCrmReport.setStartDate(startDate);
		conCrmReport.setEndDate(endDate);
		
		//隔离企业数据
		conCrmReport.setAccountId(accountId);

		List<CrmReport> crmReportList = crmReportDao.findReportList(conCrmReport);
		return crmReportList;
	}
	
	/**
	 * 消息提醒
	 * @param crmCustomer
	 * @param isMsg
	 * @param isSmsMsg
	 */
	public static void sendWxMsg(CrmCustomer crmCustomer, String isMsg, String isSmsMsg){
		
		if(crmCustomer.getOwnBy() != null  && StringUtils.isNotBlank(crmCustomer.getOwnBy().getId())){
			
			//微信提醒用户
			User user = userDao.get(crmCustomer.getOwnBy().getId());
			if(StringUtils.isNotBlank(user.getUserId()))
				WorkWechatMsgUtils.sendMsg(user.getUserId(), "客户提醒："+UserUtils.getUser().getName()+"将客户：<a href=\""+request_url_crm_index+"?id="+crmCustomer.getId()+"\">"+crmCustomer.getName()+"</a> 指派给您，请及时跟进！", user.getAccountId());
			
//			//站内信通知
//			if(StringUtils.isNotBlank(isMsg)){
//				
//				String title = "客户提醒："+UserUtils.getUser().getName()+"将客户指派给您，请及时跟进！";
//				String content = "客户提醒："+UserUtils.getUser().getName()+"将客户：<a href=\""+request_url_crm_index+"?id="+crmCustomer.getId()+"\">"+crmCustomer.getName()+"</a> 指派给您，请及时跟进！";
//				System.out.println(content);
//				MailUtils.sendMail(title, content, crmCustomer.getOwnBy().getId());
//			}
//			
//			//手机短信通知
//			if(StringUtils.isNotBlank(isSmsMsg)){
//				SmsUtils.addSms(Contants.OBJECT_CRM_TYPE_CUSTOMER, crmCustomer.getOwnBy().getId());
//			}
		}		
	}
}
