package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户关注Entity
 */
public class CrmCustomerStar extends DataEntity<CrmCustomerStar> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomer customer;		// 客户
	private String ownBy;		// 关注者
	
	public CrmCustomerStar() {
		super();
	}

	public CrmCustomerStar(String id){
		super(id);
	}
	
	public CrmCustomerStar(CrmCustomer customer){
		this.customer = customer;
	}

	@ExcelField(title="客户", align=2, sort=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=30, message="关注者长度必须介于 0 和 30 之间")
	@ExcelField(title="关注者", align=2, sort=2)
	public String getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(String ownBy) {
		this.ownBy = ownBy;
	}
	
}