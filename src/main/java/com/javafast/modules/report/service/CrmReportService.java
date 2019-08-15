package com.javafast.modules.report.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.javafast.common.config.Global;
import com.javafast.common.utils.DateUtils;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.dao.CrmReportDao;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;

/**
 * 客户统计Service
 * @author shi
 * @version 2016-06-28
 */
@Service
@Transactional(readOnly = true)
public class CrmReportService {

	@Autowired
	CrmReportDao crmReportDao;
	
	@Autowired
	SysAccountDao sysAccountDao;
	
	@Autowired
	UserDao userDao;
	
	//系统手机访问地址
	private static final String mobileRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/mobile/report";
	
	/**
	 * 综合统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findReportList(CrmReport crmReport){
		return crmReportDao.findReportList(crmReport);
	}
	
	/**
	 * 客户统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findCustomerReportList(CrmReport crmReport){
		return crmReportDao.findCustomerReportList(crmReport);
	}
	
	/**
	 * 业绩统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findAchReportList(CrmReport crmReport){
		return crmReportDao.findAchReportList(crmReport);
	}
	
	/**
	 * 财务统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findFiReportList(CrmReport crmReport){
		return crmReportDao.findFiReportList(crmReport);
	}
	
	/**
	 * 产品销售统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findProductReportList(CrmReport crmReport){
		return crmReportDao.findProductReportList(crmReport);
	}
	
	/**
	 * 客户统计，返回1行数据
	 * @param crmReport
	 * @return
	 */
	public CrmReport findCustomerReport(CrmReport crmReport){
		return crmReportDao.findCustomerReport(crmReport);
	}
	
	/**
	 * 报表数据推送
	 * @return
	 */
	@Transactional(readOnly = false)
	public void crmReportRemind(){
		
		//如果不是工作日，则不往下执行
		if(!DateUtils.isWorkDay(new Date()) && !DateUtils.getDay().equals("01")){
			return;
		}
		
		SysAccount conSysAccount = new SysAccount();
		List<SysAccount> list = sysAccountDao.findCorpList(conSysAccount);
		for(int i=0;i<list.size();i++){
			
			SysAccount sysAccount = list.get(i);
			String accountId = sysAccount.getId();
					
			User conUser = new User();
			conUser.setLoginFlag("1");
			conUser.setBindWx("1");
			conUser.getSqlMap().put("dsf", " AND a.account_id='"+accountId+"' ");
			List<User> userList = userDao.findList(conUser);
			for(int j=0;j<userList.size();j++){
				
				User user = userList.get(j);
				String userId = user.getUserId();
				
				String content = "个人";
				//如果是管理层，只推送团队业绩
				if("1".equals(user.getUserType())) {
					user = null;
					content = "团队";
				}
				
				//如果是星期一，则获取上周数据
				if(DateUtils.getWeekDay() == 1){
					
					//获取上周销售业绩
					CrmReport crmReport =ReportUtils.getCrmReport(user, "LW", accountId);
					if(crmReport != null){
						
						content += "上周销售报告-"+DateUtils.formatDate(DateUtils.getBeginDayOfLastWeek(), "yyyy-MM-dd")+"至"+DateUtils.formatDate(DateUtils.getEndDayOfLastWeek(), "yyyy-MM-dd")
						+ "\n销售业绩："	
						+ "\n成交总额（元）"+crmReport.getCreateOrderAmt()
						+ "\n回款总额（元）"+crmReport.getRecOrderAmt()
						+ "\n业务新建："
						+ "\n创建客户数（个）"+crmReport.getCreateNum()
						+ "\n创建商机数（个）"+crmReport.getCreateChangeNum()
						+ "\n创建订单数（单）"+crmReport.getCreateOrderNum()
						+ "\n\n<a href=\""+mobileRequestUrl+"\">点击查看详情</a>";
						System.out.println(content);
						WorkWechatMsgUtils.sendMsg(userId, content, accountId);
					}
				}
				
				//如果是周二至周五
				if(DateUtils.getWeekDay() > 1 && DateUtils.getWeekDay() < 6){
					
					//获取昨日销售业绩
					CrmReport crmReport =ReportUtils.getCrmReport(user, "L", accountId);
					if(crmReport != null){
						
						content += "昨日销售报告-"+DateUtils.getDayAfter(-1)
						+ "\n销售业绩："	
						+ "\n成交总额（元）"+crmReport.getCreateOrderAmt()
						+ "\n回款总额（元）"+crmReport.getRecOrderAmt()
						+ "\n业务新建："
						+ "\n创建客户数（个）"+crmReport.getCreateNum()
						+ "\n创建商机数（个）"+crmReport.getCreateChangeNum()
						+ "\n创建订单数（单）"+crmReport.getCreateOrderNum()
						+ "\n\n<a href=\""+mobileRequestUrl+"\">点击查看详情</a>";
						System.out.println(content);
						WorkWechatMsgUtils.sendMsg(userId, content, accountId);
					}
				}
				
				//每月1号
				if(DateUtils.getDay().equals("01")){
					//获取上月销售业绩
					CrmReport crmReport =ReportUtils.getCrmReport(user, "LM", accountId);
					if(crmReport != null){
						
						content += DateUtils.formatDate(DateUtils.getBeginDayOfLastMonth(), "MM月") + "销售报告-"+DateUtils.formatDateTime(DateUtils.getBeginDayOfLastMonth())+"至"+DateUtils.formatDateTime(DateUtils.getEndDayOfLastMonth())
						+ "\n销售业绩："	
						+ "\n成交总额（元）"+crmReport.getCreateOrderAmt()
						+ "\n回款总额（元）"+crmReport.getRecOrderAmt()
						+ "\n业务新建："
						+ "\n创建客户数（个）"+crmReport.getCreateNum()
						+ "\n创建商机数（个）"+crmReport.getCreateChangeNum()
						+ "\n创建订单数（单）"+crmReport.getCreateOrderNum()
						+ "\n\n<a href=\""+mobileRequestUrl+"\">点击查看详情</a>";
						System.out.println(content);
						WorkWechatMsgUtils.sendMsg(userId, content, accountId);
					}
				}
			}
		}
	}
}