package com.javafast.modules.hr.service;

import java.util.List;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.service.ServiceException;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrApproval;
import com.javafast.modules.hr.entity.HrCheckReportDay;
import com.javafast.modules.hr.entity.HrCheckReportDetail;
import com.javafast.modules.hr.dao.HrCheckReportDayDao;
import com.javafast.modules.hr.dao.HrCheckReportDetailDao;

/**
 * 每日打卡汇总Service
 *
 * @author javafast
 * @version 2018-07-10
 */
@Service
@Transactional(readOnly = true)
public class HrCheckReportDayService extends CrudService<HrCheckReportDayDao, HrCheckReportDay> {

    @Autowired
    private HrCheckReportDayDao hrCheckReportDayDao;
    
    @Autowired
    HrCheckReportDetailDao hrCheckReportDetailDao;
    
    @Autowired
    private HrCheckReportService hrCheckReportService;

    public HrCheckReportDay get(String id) {
        return super.get(id);
    }

    public List<HrCheckReportDay> findList(HrCheckReportDay hrCheckReportDay) {
    	dataScopeFilter(hrCheckReportDay);//加入数据权限过滤
        return super.findList(hrCheckReportDay);
    }

    public Page<HrCheckReportDay> findPage(Page<HrCheckReportDay> page, HrCheckReportDay hrCheckReportDay) {
    	dataScopeFilter(hrCheckReportDay);//加入数据权限过滤
        return super.findPage(page, hrCheckReportDay);
    }

    @Transactional(readOnly = false)
    public void save(HrCheckReportDay hrCheckReportDay) {
        super.save(hrCheckReportDay);
    }

    @Transactional(readOnly = false)
    public void delete(HrCheckReportDay hrCheckReportDay) {
        super.delete(hrCheckReportDay);
    }
    
    /**
     * 通过审批数据校准打卡记录
     * //哪些审批模版支持数据同步到打卡记录？目前仅官方提供的【请假】、【出差】、【外出】、【加班】、【打卡补卡】支持
     * @param hrApproval 审批单
     */
    @Transactional(readOnly = false)
    public void updateDayReportByApproval(HrApproval hrApproval) {
    	
    	//请假(注意有跨天的情况)
		if("1".equals(hrApproval.getApprovalType())){
			
			Date startTime = hrApproval.getLeaveStartTime();
			Date endTime = hrApproval.getLeaveEndTime();
			int leaveTimeunit = hrApproval.getLeaveTimeunit();//请假时间单位：0半天；1小时		
			int leaveDuration = hrApproval.getLeaveDuration();//请假时长，单位小时
			
			//当日的
			if(leaveDuration < 24){
				
				String dateStr = DateUtils.formatDate(startTime, "yyyy-MM-dd");
				String id = hrApproval.getUser().getId() + dateStr + hrApproval.getAccountId();//ID = 用户ID+日期+accountId
				updateDayReportByApproval(id, hrApproval);
			}
			//跨天的
			if(leaveDuration > 24){
				
				List<Date> betweenDates = DateUtils.getBetweenDates(startTime, endTime);
				for(Date date : betweenDates){
					
					String dateStr = DateUtils.formatDate(date, "yyyy-MM-dd");
					String id = hrApproval.getUser().getId() + dateStr;//ID = 用户ID+日期
					updateDayReportByApproval(id, hrApproval);
				}
			}
    	}
		
		//出差
		if("4".equals(hrApproval.getApprovalType())){
			
		}
		
    }
    
    /**
     * 校准
     * @param uniqueCode
     * @param hrApprovalId
     */
    @Transactional(readOnly = false)
    public void updateDayReportByApproval(String id, HrApproval hrApproval){
    	
		//查询用户审批对应日期的打卡记录
		HrCheckReportDay hrCheckReportDay = this.get(id);
		if(hrCheckReportDay != null){
            hrCheckReportDay.setAuditStatus("0");
			//审批类型   1请假、2报销、3费用、4出差、5采购、6加班、7外出、8用章、9付款、10用车、11绩效、20打卡补卡 
			if("1".equals(hrApproval.getApprovalType())){
				hrCheckReportDay.setAuditStatus(hrApproval.getLeaveType()+"");// 请假类型：1年假；2事假；3病假；4调休假；5婚假；6产假；7陪产假；8其他
				hrCheckReportDay.setLeaveDay(hrApproval.getLeaveDuration());
			}
			hrCheckReportDay.setHrApproval(hrApproval);
    		this.save(hrCheckReportDay);
		}
    }
    
    /**
     * 创建个人打卡日汇总记录（注：只能生成昨天或之前的）
     * @param sysUserId
     * @param accountId
     */
    @Transactional(readOnly = false)
    public void createDayReport(String accountId) {
    	
    	HrCheckReportDetail conDetail = new HrCheckReportDetail();
    	conDetail.setAccountId(accountId);
    	List<HrCheckReportDetail> detailList = hrCheckReportDetailDao.findCheckUserList(conDetail);
    	for(HrCheckReportDetail userDetail : detailList){
    		
    		User sysUser = userDetail.getUser();
    	
	    	HrCheckReportDay hrCheckReportDay = new HrCheckReportDay();
	    	String checkinStatus = "0";
	    	 
	    	//查询用户当日打卡明细
	    	HrCheckReportDetail conHrCheckReportDetail = new HrCheckReportDetail();
	    	conHrCheckReportDetail.setUser(sysUser);
	    	conHrCheckReportDetail.setStartDate(DateUtils.getBeginDayOfYesterday());
	    	conHrCheckReportDetail.setEndDate(DateUtils.getEndDayOfYesterDay());
	    	conHrCheckReportDetail.getSqlMap().put("dsf", " AND a.account_id='"+accountId+"'");
	    	List<HrCheckReportDetail> hrCheckReportDetailList = hrCheckReportDetailDao.findList(conHrCheckReportDetail);
	    	
	    	int count = hrCheckReportDetailList.size();
	    	for(int i=0; i<count; i++){
	    		
	    		HrCheckReportDetail detail = hrCheckReportDetailList.get(i);
	    		if(i == 0){
	    			hrCheckReportDay.setCheckinDate(detail.getCheckinDate());
	        		hrCheckReportDay.setCheckinNum(count);
	        		hrCheckReportDay.setGroupname(detail.getGroupname());
	        		hrCheckReportDay.setFirstCheckinTime(detail.getCheckinDate());
	    		}
	    		if(i == (count-1)){
	    			hrCheckReportDay.setLastCheckinTime(detail.getCheckinDate());
	    		}
	    		
	    		if("1".equals(conHrCheckReportDetail.getCheckinStatus())){
	    			checkinStatus = "1";
	    		}
	    	}
	    	//计算工作时长
	    	if(hrCheckReportDetailList != null && hrCheckReportDetailList.size() > 1){
	    		
	    		HrCheckReportDetail fistDetail = hrCheckReportDetailList.get(0);
	    		HrCheckReportDetail lastDetail = hrCheckReportDetailList.get(count-1);
	    		BigDecimal workHours = new BigDecimal(((lastDetail.getCheckinDate().getTime() - fistDetail.getCheckinDate().getTime()) / (1000 * 60 * 60)));
	    		hrCheckReportDay.setWorkHours(workHours);
	    	}
	    	
	    	hrCheckReportDay.setCheckinStatus(checkinStatus);    	
	    	hrCheckReportDay.setId(sysUser.getId() + DateUtils.formatDate(hrCheckReportDay.getCheckinDate(), "yyyy-MM-dd"));//ID = 用户ID+日期
	    	hrCheckReportDay.setAccountId(accountId);
	    	
	    	//校验是否已经有记录
	    	HrCheckReportDay tempHrCheckReportDay = this.get(hrCheckReportDay.getId());
	    	if(tempHrCheckReportDay != null){
	    		dao.update(hrCheckReportDay);
	    	}else{
	    		dao.insert(hrCheckReportDay);
	    	}
    	}
    }

    /**
     * 按日期重新生成日考勤统计
     *
     * @param hrCheckReportDay.startDate 开始时间 默认今天
     * @param hrCheckReportDay.endDate   结束时间 默认今天
     * @param hrCheckReportDay.accountId 企业主键 必传
     * @param hrCheckReportDay.user.id   传入则统计个人
     * @return
     */
    @Transactional(readOnly = false)
    public int generateDayReport(Date startDate, Date endDate, String accountId, String sysUserId) {
        if (StringUtils.isBlank(accountId)) {
            throw new ServiceException("1", "缺少参数accountId");
        }
        if (startDate == null) {
            startDate = DateUtils.getBeginDayOfYesterday();
        }
        if (endDate == null) {
            endDate = DateUtils.getEndDayOfYesterDay();
        }
        
        HrCheckReportDay hrCheckReportDay = new HrCheckReportDay();
        hrCheckReportDay.setStartDate(startDate);
        hrCheckReportDay.setEndDate(endDate);
        hrCheckReportDay.setAccountId(accountId);
        hrCheckReportDay.setUser(new User(sysUserId));
        //先删除当天的个人统计
        int countDelete=hrCheckReportDayDao.deleteByDateButNotAudit(hrCheckReportDay);
        logger.info("删除accountId:{} 日统计数量{}",accountId,countDelete);
        int count = hrCheckReportDayDao.generateDayReportButNotAudit(hrCheckReportDay);
        logger.info("新增accountId:{} 日统计数量{}",accountId,count);
        return count;
    }
    /***
     * 审批模版支持数据同步到打卡记录
     * 哪些审批模版支持数据同步到打卡记录？目前仅官方提供的【请假】、【出差】、【外出】、【加班】、【打卡补卡】支持，可通过【企业应用】->【审批】->【添加模版】进行添加并启用。
     * @param checkinDate 打卡日期
     * @param accountId 企业编号
     * @param oaId oa审核编号
     * @param auditStatus 审核后状态
     * @return
     */
    @Transactional(readOnly = false)
    public int updateauditStatusByOa(Date checkinDate, String accountId, String oaId, String auditStatus, User user,int leaveDay) {
        if (checkinDate == null || StringUtils.isBlank(accountId) || StringUtils.isBlank(oaId) || StringUtils.isBlank(auditStatus)) {
            throw new ServiceException("1", "缺少参数");
        }
        if (user == null) {
            throw new ServiceException("1", "缺少用户参数");
        }
        HrCheckReportDay hrCheckReportDay = new HrCheckReportDay();
        hrCheckReportDay.setCheckinDate(checkinDate);
        hrCheckReportDay.setAccountId(accountId);
        hrCheckReportDay.setHrApproval(new HrApproval(oaId));
        hrCheckReportDay.setAuditStatus(auditStatus);
        hrCheckReportDay.setLeaveDay(leaveDay);
        hrCheckReportDay.setUser(user);
        //修改个人天考勤报表的的状态
        int count = hrCheckReportDayDao.updateAuditStatusByOa(hrCheckReportDay);
        if (count > 0) {
            //重新生成个人月报表考勤
            hrCheckReportService.generateMonthReport(checkinDate, checkinDate, accountId, user.getId());
        }
        return count;
    }


    /**
     * 按日期重新生成日考勤统计以及月的汇总
     * 定时器可以调用这个方法-每天
     * @param startDate 开始时间 默认今天
     * @param endDate   结束时间 默认今天
     * @param accountId 企业主键 必传
     * @param user.id   传入则统计个人
     * @return
     */
    @Transactional(readOnly = false)
    public int generateDayReportAndMonth(Date startDate, Date endDate, String accountId, String sysUserId) {
        //生成日统计
        if (this.generateDayReport(startDate, endDate, accountId, sysUserId) > 0) {
            return hrCheckReportService.generateMonthReport(startDate, endDate, accountId, sysUserId);
        }
        return 0;
    }


}