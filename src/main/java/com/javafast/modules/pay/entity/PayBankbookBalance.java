package com.javafast.modules.pay.entity;

import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 电子钱包余额Entity
 * @author javafast
 * @version 2018-05-15
 */
public class PayBankbookBalance extends DataEntity<PayBankbookBalance> {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal balance;		// 余额
	
	public PayBankbookBalance() {
		super();
	}

	public PayBankbookBalance(String id){
		super(id);
	}

	@ExcelField(title="余额", align=2, sort=1)
	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	
}