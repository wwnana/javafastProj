/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 结算账户Entity
 * @author javafast
 * @version 2017-07-07
 */
public class FiFinanceAccount extends DataEntity<FiFinanceAccount> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 账户名称
	private String bankName;		// 银行名称
	private String bankcardNo;		// 银行账号
	private BigDecimal balance;		// 余额
	private String isDefault;		// 是否默认
	private String status;		// 状态
	
	public FiFinanceAccount() {
		super();
	}

	public FiFinanceAccount(String id){
		super(id);
	}

	@Length(min=1, max=50, message="账户名称长度必须介于 1 和 50 之间")
	@ExcelField(title="账户名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="银行名称长度必须介于 0 和 50 之间")
	@ExcelField(title="银行名称", align=2, sort=2)
	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	
	@Length(min=0, max=20, message="银行账号长度必须介于 0 和 20 之间")
	@ExcelField(title="银行账号", align=2, sort=3)
	public String getBankcardNo() {
		return bankcardNo;
	}

	public void setBankcardNo(String bankcardNo) {
		this.bankcardNo = bankcardNo;
	}
	
	@ExcelField(title="余额", align=2, sort=4)
	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=5)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
	
}