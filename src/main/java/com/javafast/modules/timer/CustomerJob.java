package com.javafast.modules.timer;

import java.util.List;
import com.javafast.common.config.Global;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.service.CrmReportService;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;

@Component
public class CustomerJob {

    private Logger logger = Logger.getLogger(CustomerJob.class);

    @Autowired
    private CrmCustomerService crmCustomerService;

    @Autowired
    CrmContactRecordService crmContactRecordService;

    @Autowired
    CrmReportService crmReportService;

    @Autowired
    UserDao userDao;

    @Autowired
    SysAccountDao sysAccountDao;

    //获取手机网址
  	private static final String mobileRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/mobile/crm/crmCustomer/index";
  	
    //回收超过30天未联系的客户被释放到公海
    @Scheduled(cron = "0 30 3 * * ?")
    public void recycleCustomer() {
        try {
        	System.out.println("========回收超过30天未联系的客户定时任务开始=========");
        	List<SysAccount> accountList = sysAccountDao.findList(new SysAccount());
			for(SysAccount sysAccount : accountList){
				
				String accountId = sysAccount.getId();
				System.out.println("企业编号："+accountId);
				
				//超过30天未联系的客户
	            List<CrmCustomer> customerList = crmCustomerService.findOverdueList(accountId, 30);
	    		for(int i=0; i<customerList.size(); i++){
	    			
	    			CrmCustomer crmCustomer = customerList.get(i);
	    			System.out.println("客户："+crmCustomer.getName()+"被释放到公海");
	    			
	    			//释放到公海
	    			crmCustomerService.throwToPool(crmCustomer);
	    			
	    			//日志
	    			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_AUTO_POOL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), "1", accountId);
	    		}
			}
			System.out.println("========回收超过30天未联系的客户定时任务结束=========");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //每天9:10点提醒，客户跟进提醒联系
    @Scheduled(cron = "0 30 10 * * ?")
    public void crmContactRemind() {
        try {
            System.out.println("========客户跟进提醒开始=========");
            

            //今日需联系客户提醒
            //crmContactRecordService.remindNeedContactRecord();

            List<SysAccount> accountList = sysAccountDao.findCorpList(new SysAccount());
			for(SysAccount sysAccount : accountList){
				
				String accountId = sysAccount.getId();
				System.out.println("企业编号："+accountId);
				
				//超过7天未联系的客户提醒(开发中的客户)
	            List<CrmCustomer> customerList = crmCustomerService.findOverdueList(accountId, 7);
	    		for(int i=0; i<customerList.size(); i++){
	    			
	    			CrmCustomer crmCustomer = customerList.get(i);
	    			
	    			//微信提醒用户
	    			if(crmCustomer.getOwnBy() != null  && StringUtils.isNotBlank(crmCustomer.getOwnBy().getId())){
	    				User user = userDao.get(crmCustomer.getOwnBy().getId());
	    				if(user != null && StringUtils.isNotBlank(user.getUserId()))
	    					WorkWechatMsgUtils.sendMsg(user.getUserId(), "客户提醒：您的客户：<a href=\""+mobileRequestUrl+"?id="+crmCustomer.getId()+"\">"+crmCustomer.getName()+"</a> 已经超过7天未跟进了！点击查看", user.getAccountId());
	    			}			
	    		}
			}

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //业绩报表消息推送
    @Scheduled(cron = "0 30 8 * * ?")
    public void crmReportRemind() {
        try {
            System.out.println("========业绩报表消息推送=========");

            //业绩报表
            crmReportService.crmReportRemind();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
