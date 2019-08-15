package com.javafast.modules.timer;

import java.util.Date;
import java.util.List;
import com.javafast.common.utils.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.javafast.modules.hr.dao.HrEmployeeDao;
import com.javafast.modules.hr.dao.HrResumeLogDao;
import com.javafast.modules.hr.service.HrApprovalService;
import com.javafast.modules.hr.service.HrCheckReportDayService;
import com.javafast.modules.hr.service.HrCheckReportDetailService;
import com.javafast.modules.hr.service.HrCheckReportService;
import com.javafast.modules.hr.service.HrCheckRuleService;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.service.SystemService;
import com.javafast.modules.sys.utils.AccountUtils;

@Component
public class HrJob {

    private Logger logger = Logger.getLogger(HrJob.class);

    @Autowired
    SystemService systemService;

    @Autowired
    UserDao userDao;

    @Autowired
    HrEmployeeDao hrEmployeeDao;

    @Autowired
    HrResumeLogDao hrResumeLogDao;

    @Autowired
    SysAccountDao sysAccountDao;

    @Autowired
    HrCheckReportDetailService hrCheckReportDetailService;
    
    @Autowired
    HrApprovalService hrApprovalService;

    @Autowired
    HrCheckReportDayService hrCheckReportDayService;

    @Autowired
    HrCheckReportService hrCheckReportService;
    
    @Autowired
    HrCheckRuleService hrCheckRuleService;

    /**
     * 获取打卡、审批数据、汇总统计
     */
    //@Scheduled(cron = "0 30 7 * * ?")
    public void getHrCheckReportData() {
    	
        try {
        	
            System.out.println("========获取打卡、审批数据、汇总统计 开始=========");
			List<SysAccount> list = sysAccountDao.findCorpList(new SysAccount());
			for(int i=0;i<list.size();i++){
				
				SysAccount sysAccount = list.get(i);
				String accountId = sysAccount.getId();
				System.out.println("企业编号："+accountId);
				
				//企业需要自行配置打卡应用的Secret
				SysConfig sysConfig = AccountUtils.getSysConfig(accountId);
				if(sysConfig != null && StringUtils.isNotBlank(sysConfig.getWxCorpid()) && StringUtils.isNotBlank(sysConfig.getCheckinSecret())){

                    //1.获取打卡规则
                    hrCheckRuleService.synchHrCheckRuleList(accountId);
					Date startDate = DateUtils.getBeginDayOfYesterday();
		            Date endDate = DateUtils.getEndDayOfYesterDay();

		            //2.获取打卡明细
		            hrCheckReportDetailService.synchCorpWechatCheckDetail(accountId, startDate, endDate);
		            
		            //3.日打卡汇总统计
		            hrCheckReportDayService.generateDayReport(startDate, endDate, accountId, null);
		            
		            //4.获取审批数据，更新对应的日打卡校准
		            hrApprovalService.getCorpWechatApprovalData(accountId, DateUtils.getBeginDayOfMonth(), new Date());
		            
		            //5.月打卡汇总统计
		            hrCheckReportService.generateMonthReport(startDate, endDate, accountId, null);
				}
			}
            
            System.out.println("========获取打卡、审批数据、汇总统计 结束=========");
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("定时任务获取打卡、审批数据、汇总统计出错");
        }
    }

    
}
