package com.javafast.modules.timer;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;

@Component
public class TestJob {

    private Logger logger = Logger.getLogger(TestJob.class);
    
    @Autowired
	private CrmContactRecordService crmContactRecordService;
    
    @Autowired
	private CrmCustomerService crmCustomerService;

    //每1分钟执行一次
    //@Scheduled(cron = "0 0/1 * * * ?")
    public void test() {
        try {
            System.out.println("========定时任务开始=========");
            
            //业务逻辑
            
            System.out.println("========定时任务结束=========");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //@Scheduled(cron = "0 0/5 * * * ?")
    public void test2() {
        try {
            System.out.println("========定时任务开始=========");
            
            //业务逻辑
            List<CrmContactRecord> list = crmContactRecordService.findAllList();
            for(int i=0;i<list.size();i++) {
            	
            	CrmContactRecord crmContactRecord = list.get(i);
            	if(crmContactRecord.getTargetName() == null) {
            		
            		CrmCustomer crmCustomer = crmCustomerService.get(crmContactRecord.getTargetId());
                	if(crmCustomer != null) {
                		crmContactRecord.setTargetName(crmCustomer.getName());
                		crmContactRecordService.update(crmContactRecord);
                	}
            	}
            }
            
            System.out.println("========定时任务结束=========");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
