package com.javafast.modules.hr.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 每日打卡汇总Entity
 * @author javafast
 * @version 2018-07-10
 */
public class HrCheckReportDay extends DataEntity<HrCheckReportDay> {
	
	private static final long serialVersionUID = 1L;
	private Date checkinDate;		// 日期
	private User user;		// 姓名
	private Office office;		// 部门
	private String groupname;		// 所属规则
	private Date firstCheckinTime;		// 最早
	private Date lastCheckinTime;		// 最晚
	private Integer checkinNum;		// 次数
	private BigDecimal workHours;		// 工作时长
	
	private HrApproval hrApproval;  // 审批单
	
	private String checkinStatus;		// 状态
	private String auditStatus;		// 校准状态    0正常，-1：异常，1年假；2事假；3病假；4调休假；5婚假；6产假；7陪产假；8其他 
	private int leaveDay;
	private int updateFlag=0;

	private Date startDate;
	private Date endDate;
	
	public HrCheckReportDay() {
		super();
	}

	public HrCheckReportDay(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="日期", align=2, sort=1)
	public Date getCheckinDate() {
		return checkinDate;
	}

	public void setCheckinDate(Date checkinDate) {
		this.checkinDate = checkinDate;
	}
	
	@ExcelField(title="姓名", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="部门", fieldType=Office.class, value="office.name", align=2, sort=3)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=1, max=50, message="所属规则长度必须介于 1 和 50 之间")
	@ExcelField(title="所属规则", align=2, sort=4)
	public String getGroupname() {
		return groupname;
	}

	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="最早", align=2, sort=5)
	public Date getFirstCheckinTime() {
		return firstCheckinTime;
	}

	public void setFirstCheckinTime(Date firstCheckinTime) {
		this.firstCheckinTime = firstCheckinTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="最晚", align=2, sort=6)
	public Date getLastCheckinTime() {
		return lastCheckinTime;
	}

	public void setLastCheckinTime(Date lastCheckinTime) {
		this.lastCheckinTime = lastCheckinTime;
	}
	
	@ExcelField(title="次数", align=2, sort=7)
	public Integer getCheckinNum() {
		return checkinNum;
	}

	public void setCheckinNum(Integer checkinNum) {
		this.checkinNum = checkinNum;
	}
	
	@ExcelField(title="工作时长", align=2, sort=8)
	public BigDecimal getWorkHours() {
		return workHours;
	}

	public void setWorkHours(BigDecimal workHours) {
		this.workHours = workHours;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="checkin_status", align=2, sort=10)
	public String getCheckinStatus() {
		return checkinStatus;
	}

	public void setCheckinStatus(String checkinStatus) {
		this.checkinStatus = checkinStatus;
	}
	
	@Length(min=0, max=1, message="校准状态长度必须介于 0 和 1 之间")
	@ExcelField(title="校准状态", align=2, sort=11)
	public String getAuditStatus() {
		return auditStatus;
	}

	public void setAuditStatus(String auditStatus) {
		this.auditStatus = auditStatus;
	}


	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public int getLeaveDay() {
		return leaveDay;
	}

	public void setLeaveDay(int leaveDay) {
		this.leaveDay = leaveDay;
	}

	public int getUpdateFlag() {
		return updateFlag;
	}

	public void setUpdateFlag(int updateFlag) {
		this.updateFlag = updateFlag;
	}

	public HrApproval getHrApproval() {
		return hrApproval;
	}

	public void setHrApproval(HrApproval hrApproval) {
		this.hrApproval = hrApproval;
	}
}