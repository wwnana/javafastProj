package com.javafast.modules.pay.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 电子钱包交易明细Entity
 * @author javafast
 * @version 2018-05-15
 */
public class PayBankbookJournal extends DataEntity<PayBankbookJournal> {
	
	private static final long serialVersionUID = 1L;
	private Date dealDate;		// 交易日期
	private String dealType;		// 交易类型
	private BigDecimal money;		// 交易金额
	private String moneyType;		// 资金类别
	private BigDecimal balance;		// 当前余额
	private String uniqueCode;		// 唯一码
	private Date beginDealDate;		// 开始 交易日期
	private Date endDealDate;		// 结束 交易日期
	
	public PayBankbookJournal() {
		super();
	}

	public PayBankbookJournal(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="交易日期", align=2, sort=2)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@Length(min=0, max=1, message="交易类型长度必须介于 0 和 1 之间")
	@ExcelField(title="交易类型", dictType="deal_type", align=2, sort=3)
	public String getDealType() {
		return dealType;
	}

	public void setDealType(String dealType) {
		this.dealType = dealType;
	}
	
	@ExcelField(title="交易金额", align=2, sort=4)
	public BigDecimal getMoney() {
		return money;
	}

	public void setMoney(BigDecimal money) {
		this.money = money;
	}
	
	@Length(min=0, max=2, message="资金类别长度必须介于 0 和 2 之间")
	@ExcelField(title="资金类别", dictType="money_type", align=2, sort=5)
	public String getMoneyType() {
		return moneyType;
	}

	public void setMoneyType(String moneyType) {
		this.moneyType = moneyType;
	}
	
	@ExcelField(title="当前余额", align=2, sort=6)
	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	
	@Length(min=0, max=50, message="唯一码长度必须介于 0 和 50 之间")
	@ExcelField(title="唯一码", align=2, sort=8)
	public String getUniqueCode() {
		return uniqueCode;
	}

	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
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