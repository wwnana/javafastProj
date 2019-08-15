/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 资金流水Entity
 * @author javafast
 * @version 2017-07-16
 */
public class FiFinanceJournal extends DataEntity<FiFinanceJournal> {
	
	private static final long serialVersionUID = 1L;
	private FiFinanceAccount fiaccount;		// 结算账户
	private String dealType;		// 交易类别
	private Date dealDate;		// 业务日期
	private String moneyType;		// 资金类别
	private BigDecimal money;		// 交易金额
	private String notes;		// 摘要
	private BigDecimal balance;		// 当前余额
	private String uniqueCode;		// 唯一码
	private String dataType;		// 终端类型
	private String lastJournalId;		// 上一笔记录ID
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	
	public FiFinanceJournal() {
		super();
	}

	public FiFinanceJournal(String id){
		super(id);
	}

	@ExcelField(title="结算账户", fieldType=FiFinanceAccount.class, value="fiaccount.name", align=2, sort=1)
	public FiFinanceAccount getFiaccount() {
		return fiaccount;
	}

	public void setFiaccount(FiFinanceAccount fiaccount) {
		this.fiaccount = fiaccount;
	}
	
	@Length(min=0, max=2, message="交易类别长度必须介于 0 和 2 之间")
	@ExcelField(title="交易类别", dictType="deal_type", align=2, sort=2)
	public String getDealType() {
		return dealType;
	}

	public void setDealType(String dealType) {
		this.dealType = dealType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="业务日期", align=2, sort=3)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@Length(min=0, max=2, message="资金类别长度必须介于 0 和 2 之间")
	@ExcelField(title="资金类别", dictType="money_type", align=2, sort=4)
	public String getMoneyType() {
		return moneyType;
	}

	public void setMoneyType(String moneyType) {
		this.moneyType = moneyType;
	}
	
	@ExcelField(title="交易金额", align=2, sort=5)
	public BigDecimal getMoney() {
		return money;
	}

	public void setMoney(BigDecimal money) {
		this.money = money;
	}
	
	@Length(min=0, max=50, message="摘要长度必须介于 0 和 50 之间")
	@ExcelField(title="摘要", align=2, sort=6)
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	@ExcelField(title="当前余额", align=2, sort=7)
	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	
	@Length(min=0, max=30, message="唯一码长度必须介于 0 和 30 之间")
	public String getUniqueCode() {
		return uniqueCode;
	}

	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
	}
	
	@Length(min=0, max=2, message="终端类型长度必须介于 0 和 2 之间")
	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	
	@Length(min=0, max=30, message="上一笔记录ID长度必须介于 0 和 30 之间")
	public String getLastJournalId() {
		return lastJournalId;
	}

	public void setLastJournalId(String lastJournalId) {
		this.lastJournalId = lastJournalId;
	}
	
	public Date getBeginDealDate() {
		return beginDealDate;
	}

	public void setBeginDealDate(Date beginDealDate) {
		this.beginDealDate = beginDealDate;
	}
	
	public Date getEndDealDate() {
		return endDealDate;
	}

	public void setEndDealDate(Date endDealDate) {
		this.endDealDate = endDealDate;
	}
		
}