package com.javafast.modules.oa.entity;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 请假单Entity
 */
public class OaCommonLeave extends DataEntity<OaCommonLeave> {
	
	private static final long serialVersionUID = 1L;
	private Date startTime;		// 开始时间
	private Date endTime;		// 结束时间
	private String leaveType;		// 请假类型
	private BigDecimal daysNum;		// 请假时长(天)
	
	private OaCommonAudit oaCommonAudit;//审批主表
	
	public OaCommonLeave() {
		super();
	}

	public OaCommonLeave(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="开始时间", align=2, sort=1)
	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="结束时间", align=2, sort=2)
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	@Length(min=0, max=1, message="请假类型长度必须介于 0 和 1 之间")
	@ExcelField(title="请假类型", dictType="leave_type", align=2, sort=3)
	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}
	
	@ExcelField(title="请假时长(天)", align=2, sort=4)
	public BigDecimal getDaysNum() {
		return daysNum;
	}

	public void setDaysNum(BigDecimal daysNum) {
		this.daysNum = daysNum;
	}

	public OaCommonAudit getOaCommonAudit() {
		return oaCommonAudit;
	}

	public void setOaCommonAudit(OaCommonAudit oaCommonAudit) {
		this.oaCommonAudit = oaCommonAudit;
	}
	
}