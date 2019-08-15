/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 供应商Entity
 * @author javafast
 * @version 2017-07-04
 */
public class WmsSupplier extends DataEntity<WmsSupplier> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 编号
	private String name;		// 名称
	private WmsSupplierType supplierType;		// 供应商分类
	private String contactName;		// 联系人
	private String phone;		// 联系电话
	private String email;		// 邮箱
	private String qq;		// QQ
	private String fax;		// 传真
	private Integer zipcode;		// 邮编
	private String address;		// 联系地址
	private BigDecimal arrear;		// 应付欠款
	private String status;		// 状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public WmsSupplier() {
		super();
	}

	public WmsSupplier(String id){
		super(id);
	}

	@Length(min=1, max=30, message="编号长度必须介于 1 和 30 之间")
	@ExcelField(title="编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="名称长度必须介于 1 和 50 之间")
	@ExcelField(title="名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="供应商分类", align=2, sort=3, fieldType=WmsSupplierType.class, value="supplierType.name", type=1)
	public WmsSupplierType getSupplierType() {
		return supplierType;
	}

	public void setSupplierType(WmsSupplierType supplierType) {
		this.supplierType = supplierType;
	}
	
	@Length(min=0, max=30, message="联系人长度必须介于 0 和 30 之间")
	@ExcelField(title="联系人", align=2, sort=4)
	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	
	@Length(min=0, max=20, message="联系电话长度必须介于 0 和 20 之间")
	@ExcelField(title="联系电话", align=2, sort=5)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	@Length(min=0, max=50, message="邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱", align=2, sort=6)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=30, message="QQ长度必须介于 0 和 30 之间")
	@ExcelField(title="QQ", align=2, sort=7)
	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}
	
	@Length(min=0, max=30, message="传真长度必须介于 0 和 30 之间")
	@ExcelField(title="传真", align=2, sort=8)
	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}
	
	@ExcelField(title="邮编", align=2, sort=9)
	public Integer getZipcode() {
		return zipcode;
	}

	public void setZipcode(Integer zipcode) {
		this.zipcode = zipcode;
	}
	
	@Length(min=0, max=50, message="联系地址长度必须介于 0 和 50 之间")
	@ExcelField(title="联系地址", align=2, sort=10)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@ExcelField(title="应付欠款", align=2, sort=11, type=1)
	public BigDecimal getArrear() {
		return arrear;
	}

	public void setArrear(BigDecimal arrear) {
		this.arrear = arrear;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=12, type=1)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}
	
	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}
		
}