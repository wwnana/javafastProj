package com.javafast.modules.timer;

import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.javafast.api.sms.utils.SmsUtils;

@Component
public class SmsJob {

    private Logger logger = Logger.getLogger(SmsJob.class);

    //短信推送，每2分钟一次
    //@Scheduled(cron = "0 0/2 * * * ?")
    public void pushSms() {
        try {
            //System.out.println("========推送短信 定时任务开始=========");
            SmsUtils.pushSms();
            //System.out.println("========推送短信 定时任务结束=========");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

  	
}
