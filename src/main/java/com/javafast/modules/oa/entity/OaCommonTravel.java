package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 差旅单Entity
 * @author javafast
 * @version 2017-08-25
 */
public class OaCommonTravel extends DataEntity<OaCommonTravel> {
	
	private static final long serialVersionUID = 1L;
	private String startAddress;		// 出发地
	private String destAddress;		// 出差城市
	private Date startTime;		// 开始时间
	private Date endTime;		// 结束时间
	private BigDecimal budgetAmt;		// 预算金额
	private BigDecimal advanceAmt;		// 预支金额
	
	private OaCommonAudit oaCommonAudit;//审批主表
	
	public OaCommonTravel() {
		super();
	}

	public OaCommonTravel(String id){
		super(id);
	}

	@Length(min=0, max=30, message="出发地长度必须介于 0 和 30 之间")
	@ExcelField(title="出发地", align=2, sort=1)
	public String getStartAddress() {
		return startAddress;
	}

	public void setStartAddress(String startAddress) {
		this.startAddress = startAddress;
	}
	
	@Length(min=0, max=30, message="出差城市长度必须介于 0 和 30 之间")
	@ExcelField(title="出差城市", align=2, sort=2)
	public String getDestAddress() {
		return destAddress;
	}

	public void setDestAddress(String destAddress) {
		this.destAddress = destAddress;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="开始时间", align=2, sort=3)
	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="结束时间", align=2, sort=4)
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	@ExcelField(title="预算金额", align=2, sort=5)
	public BigDecimal getBudgetAmt() {
		return budgetAmt;
	}

	public void setBudgetAmt(BigDecimal budgetAmt) {
		this.budgetAmt = budgetAmt;
	}
	
	@ExcelField(title="预支金额", align=2, sort=6)
	public BigDecimal getAdvanceAmt() {
		return advanceAmt;
	}

	public void setAdvanceAmt(BigDecimal advanceAmt) {
		this.advanceAmt = advanceAmt;
	}

	public OaCommonAudit getOaCommonAudit() {
		return oaCommonAudit;
	}

	public void setOaCommonAudit(OaCommonAudit oaCommonAudit) {
		this.oaCommonAudit = oaCommonAudit;
	}
	
}