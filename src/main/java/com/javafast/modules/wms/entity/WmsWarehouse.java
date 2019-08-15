/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 仓库Entity
 * @author javafast
 * @version 2017-07-04
 */
public class WmsWarehouse extends DataEntity<WmsWarehouse> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 仓库编号
	private String name;		// 仓库名称
	private String isDefault;		// 是否默认
	private String contactName;		// 联系人
	private String phone;		// 联系电话
	private String mobile;		// 联系手机
	private String email;		// 联系邮箱
	private String address;		// 联系地址
	private String status;		// 状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public WmsWarehouse() {
		super();
	}

	public WmsWarehouse(String id){
		super(id);
	}

	@Length(min=1, max=30, message="仓库编号长度必须介于 1 和 30 之间")
	@ExcelField(title="仓库编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="仓库名称长度必须介于 1 和 50 之间")
	@ExcelField(title="仓库名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=1, message="是否默认长度必须介于 0 和 1 之间")
	@ExcelField(title="是否默认", dictType="yes_no", align=2, sort=3)
	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
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
	
	@Length(min=0, max=20, message="联系手机长度必须介于 0 和 20 之间")
	@ExcelField(title="联系手机", align=2, sort=6)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=50, message="联系邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="联系邮箱", align=2, sort=7)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=50, message="联系地址长度必须介于 0 和 50 之间")
	@ExcelField(title="联系地址", align=2, sort=8)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=9)
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