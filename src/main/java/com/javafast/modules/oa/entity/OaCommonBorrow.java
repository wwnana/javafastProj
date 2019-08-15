package com.javafast.modules.oa.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 借款单Entity
 */
public class OaCommonBorrow extends DataEntity<OaCommonBorrow> {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal amount;		// 借款总额
	private Date borrowDate;		// 借款时间
	private Date beginBorrowDate;		// 开始 借款时间
	private Date endBorrowDate;		// 结束 借款时间
	
	private OaCommonAudit oaCommonAudit;//审批主表
	
	public OaCommonBorrow() {
		super();
	}

	public OaCommonBorrow(String id){
		super(id);
	}

	@ExcelField(title="借款总额", align=2, sort=1)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="借款时间", align=2, sort=2)
	public Date getBorrowDate() {
		return borrowDate;
	}

	public void setBorrowDate(Date borrowDate) {
		this.borrowDate = borrowDate;
	}
	
	public Date getBeginBorrowDate() {
		return beginBorrowDate;
	}

	public void setBeginBorrowDate(Date beginBorrowDate) {
		this.beginBorrowDate = beginBorrowDate;
	}
	
	public Date getEndBorrowDate() {
		return endBorrowDate;
	}

	public void setEndBorrowDate(Date endBorrowDate) {
		this.endBorrowDate = endBorrowDate;
	}

	public OaCommonAudit getOaCommonAudit() {
		return oaCommonAudit;
	}

	public void setOaCommonAudit(OaCommonAudit oaCommonAudit) {
		this.oaCommonAudit = oaCommonAudit;
	}
		
}