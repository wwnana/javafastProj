package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 开票信息Entity
 */
public class CrmInvoice extends DataEntity<CrmInvoice> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomer customer;		// 客户
	private String regName;		// 发票抬头
	private String regAddress;		// 单位地址
	private String invoiceType;		// 发票类型
	private String regPhone;		// 单位电话
	private String bankNo;		// 银行基本户账号
	private String bankName;		// 开户行
	private String taxNo;		// 税务登记号
	private String province;		// 省
	private String city;		// 市
	private String dict;		// 区
	private String address;		// 地址
	private String zipcode;		// 邮编
	private String receiver;		// 收货人
	private String phone;		// 联系电话
	private String status;		// 状态
	
	public CrmInvoice() {
		super();
	}

	public CrmInvoice(String id){
		super(id);
	}

	@ExcelField(title="客户", align=2, sort=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=50, message="发票抬头长度必须介于 0 和 50 之间")
	@ExcelField(title="发票抬头", align=2, sort=2)
	public String getRegName() {
		return regName;
	}

	public void setRegName(String regName) {
		this.regName = regName;
	}
	
	@Length(min=0, max=50, message="单位地址长度必须介于 0 和 50 之间")
	@ExcelField(title="单位地址", align=2, sort=3)
	public String getRegAddress() {
		return regAddress;
	}

	public void setRegAddress(String regAddress) {
		this.regAddress = regAddress;
	}
	
	@Length(min=0, max=1, message="发票类型长度必须介于 0 和 1 之间")
	@ExcelField(title="发票类型", align=2, sort=4)
	public String getInvoiceType() {
		return invoiceType;
	}

	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}
	
	@Length(min=0, max=30, message="单位电话长度必须介于 0 和 30 之间")
	@ExcelField(title="单位电话", align=2, sort=5)
	public String getRegPhone() {
		return regPhone;
	}

	public void setRegPhone(String regPhone) {
		this.regPhone = regPhone;
	}
	
	@Length(min=0, max=30, message="银行基本户账号长度必须介于 0 和 30 之间")
	@ExcelField(title="银行基本户账号", align=2, sort=6)
	public String getBankNo() {
		return bankNo;
	}

	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
	}
	
	@Length(min=0, max=50, message="开户行长度必须介于 0 和 50 之间")
	@ExcelField(title="开户行", align=2, sort=7)
	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	
	@Length(min=0, max=30, message="税务登记号长度必须介于 0 和 30 之间")
	@ExcelField(title="税务登记号", align=2, sort=8)
	public String getTaxNo() {
		return taxNo;
	}

	public void setTaxNo(String taxNo) {
		this.taxNo = taxNo;
	}
	
	@Length(min=0, max=20, message="省长度必须介于 0 和 20 之间")
	@ExcelField(title="省", align=2, sort=9)
	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}
	
	@Length(min=0, max=20, message="市长度必须介于 0 和 20 之间")
	@ExcelField(title="市", align=2, sort=10)
	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}
	
	@Length(min=0, max=20, message="区长度必须介于 0 和 20 之间")
	@ExcelField(title="区", align=2, sort=11)
	public String getDict() {
		return dict;
	}

	public void setDict(String dict) {
		this.dict = dict;
	}
	
	@Length(min=0, max=50, message="地址长度必须介于 0 和 50 之间")
	@ExcelField(title="地址", align=2, sort=12)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=20, message="邮编长度必须介于 0 和 20 之间")
	@ExcelField(title="邮编", align=2, sort=13)
	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	
	@Length(min=0, max=30, message="收货人长度必须介于 0 和 30 之间")
	@ExcelField(title="收货人", align=2, sort=14)
	public String getReceiver() {
		return receiver;
	}

	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	
	@Length(min=0, max=30, message="联系电话长度必须介于 0 和 30 之间")
	@ExcelField(title="联系电话", align=2, sort=15)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", align=2, sort=18, type=1)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}