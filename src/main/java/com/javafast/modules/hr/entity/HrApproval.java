package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 审批记录Entity
 * @author javafast
 * @version 2018-07-16
 */
public class HrApproval extends DataEntity<HrApproval> {
	
	private static final long serialVersionUID = 1L;
	private String approvalType;		// 审批类型   1请假、2报销、3费用、4出差、5采购、6加班、7外出、8用章、9付款、10用车、11绩效、20打卡补卡 
	private String name;		// 审批名称
	private String applyName;		// 申请人姓名
	private String applyOrg;		// 申请人部门
	private String approvalName;		// 审批人姓名
	private String notifyName;		// 抄送人姓名
	private Integer spStatus;		//  审批状态：1审批中；2 已通过；3已驳回；4已取消；6通过后撤销；10已支付
	private String spNum;		// 审批单号
	private Date applyTime;		// 审批单提交时间
	private String applyUserId;		// 审批单提交者的userid
	
	private Integer expenseType;		// 报销类型 报销类型：1差旅费；2交通费；3招待费；4其他报销
	private String expenseReason;		// 报销事由
	
	private Integer leaveTimeunit;		// 请假时间单位：0半天；1小时
	private Integer leaveType;		// 请假类型：1年假；2事假；3病假；4调休假；5婚假；6产假；7陪产假；8其他
	private Date leaveStartTime;		// 请假开始时间
	private Date leaveEndTime;		// 请假结束时间
	private Integer leaveDuration;		// 请假时长，单位小时
	private String leaveReason;		// 请假事由
	
	private String applyData;		// 申请单数据
	
	private Date bkCheckinTime;      //补卡时间
	private Date beginTime;          //开始时间
	private Date endTime;            //结束时间
	private Integer duration;        //时长，//单位：秒
	
	private User user;		// 用户
	private Office office;		// 部门
	
	private Date startDate;
	private Date endDate;
	
	public HrApproval() {
		super();
	}

	public HrApproval(String id){
		super(id);
	}

	@Length(min=0, max=50, message="审批名称长度必须介于 0 和 50 之间")
	@ExcelField(title="审批名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="申请人姓名长度必须介于 0 和 50 之间")
	@ExcelField(title="申请人姓名", align=2, sort=2)
	public String getApplyName() {
		return applyName;
	}

	public void setApplyName(String applyName) {
		this.applyName = applyName;
	}
	
	@Length(min=0, max=50, message="申请人部门长度必须介于 0 和 50 之间")
	@ExcelField(title="申请人部门", align=2, sort=3)
	public String getApplyOrg() {
		return applyOrg;
	}

	public void setApplyOrg(String applyOrg) {
		this.applyOrg = applyOrg;
	}
	
	@Length(min=0, max=50, message="审批人姓名长度必须介于 0 和 50 之间")
	@ExcelField(title="审批人姓名", align=2, sort=4)
	public String getApprovalName() {
		return approvalName;
	}

	public void setApprovalName(String approvalName) {
		this.approvalName = approvalName;
	}
	
	@Length(min=0, max=50, message="抄送人姓名长度必须介于 0 和 50 之间")
	@ExcelField(title="抄送人姓名", align=2, sort=5)
	public String getNotifyName() {
		return notifyName;
	}

	public void setNotifyName(String notifyName) {
		this.notifyName = notifyName;
	}
	
	@ExcelField(title="审批状态", align=2, sort=6)
	public Integer getSpStatus() {
		return spStatus;
	}

	public void setSpStatus(Integer spStatus) {
		this.spStatus = spStatus;
	}
	
	@Length(min=0, max=50, message="审批单号长度必须介于 0 和 50 之间")
	@ExcelField(title="审批单号", align=2, sort=7)
	public String getSpNum() {
		return spNum;
	}

	public void setSpNum(String spNum) {
		this.spNum = spNum;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审批单提交时间", align=2, sort=8)
	public Date getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	@Length(min=0, max=50, message="审批单提交者的userid长度必须介于 0 和 50 之间")
	@ExcelField(title="审批单提交者的userid", align=2, sort=9)
	public String getApplyUserId() {
		return applyUserId;
	}

	public void setApplyUserId(String applyUserId) {
		this.applyUserId = applyUserId;
	}
	
	@Length(min=0, max=2, message="审批类型长度必须介于 0 和 2 之间")
	@ExcelField(title="审批类型", dictType="common_audit_type", align=2, sort=10)
	public String getApprovalType() {
		return approvalType;
	}

	public void setApprovalType(String approvalType) {
		this.approvalType = approvalType;
	}
	
	@ExcelField(title="报销类型", align=2, sort=11)
	public Integer getExpenseType() {
		return expenseType;
	}

	public void setExpenseType(Integer expenseType) {
		this.expenseType = expenseType;
	}
	
	@Length(min=0, max=255, message="报销事由长度必须介于 0 和 255 之间")
	@ExcelField(title="报销事由", align=2, sort=12)
	public String getExpenseReason() {
		return expenseReason;
	}

	public void setExpenseReason(String expenseReason) {
		this.expenseReason = expenseReason;
	}
	
	@ExcelField(title="请假时间单位：0半天；1小时", align=2, sort=13)
	public Integer getLeaveTimeunit() {
		return leaveTimeunit;
	}

	public void setLeaveTimeunit(Integer leaveTimeunit) {
		this.leaveTimeunit = leaveTimeunit;
	}
	
	@ExcelField(title="请假类型", align=2, sort=14)
	public Integer getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(Integer leaveType) {
		this.leaveType = leaveType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="请假开始时间", align=2, sort=15)
	public Date getLeaveStartTime() {
		return leaveStartTime;
	}

	public void setLeaveStartTime(Date leaveStartTime) {
		this.leaveStartTime = leaveStartTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="请假结束时间", align=2, sort=16)
	public Date getLeaveEndTime() {
		return leaveEndTime;
	}

	public void setLeaveEndTime(Date leaveEndTime) {
		this.leaveEndTime = leaveEndTime;
	}
	
	@ExcelField(title="请假时长，单位小时", align=2, sort=17)
	public Integer getLeaveDuration() {
		return leaveDuration;
	}

	public void setLeaveDuration(Integer leaveDuration) {
		this.leaveDuration = leaveDuration;
	}
	
	@Length(min=0, max=255, message="请假事由长度必须介于 0 和 255 之间")
	@ExcelField(title="请假事由", align=2, sort=18)
	public String getLeaveReason() {
		return leaveReason;
	}

	public void setLeaveReason(String leaveReason) {
		this.leaveReason = leaveReason;
	}
	
	@Length(min=0, max=5000, message="申请单数据长度必须介于 0 和 5000 之间")
	@ExcelField(title="申请单数据", align=2, sort=19)
	public String getApplyData() {
		return applyData;
	}

	public void setApplyData(String applyData) {
		this.applyData = applyData;
	}
	
	@ExcelField(title="用户", fieldType=User.class, value="user.name", align=2, sort=20)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
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

	public Date getBkCheckinTime() {
		return bkCheckinTime;
	}

	public void setBkCheckinTime(Date bkCheckinTime) {
		this.bkCheckinTime = bkCheckinTime;
	}

	public Date getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}
	
}