/**
 * Copyright 2015-2020
 */
package com.javafast.modules.scm.entity;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.entity.User;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户关怀Entity
 * @author javafast
 * @version 2017-08-18
 */
public class ScmCare extends DataEntity<ScmCare> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 主题
	private CrmCustomer customer;		// 客户
	private String contacterName;		// 联系人
	private String careType;		// 关怀类型
	private Date careDate;		// 关怀日期
	private String careNote;		// 关怀内容
	private User ownBy;		// 负责人
	
	private Date beginCareDate;		// 开始 关怀日期
	private Date endCareDate;		// 结束 关怀日期
	
	public ScmCare() {
		super();
	}

	public ScmCare(String id){
		super(id);
	}

	@Length(min=0, max=50, message="主题长度必须介于 0 和 50 之间")
	@ExcelField(title="主题", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="客户", align=2, sort=2)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=30, message="联系人长度必须介于 0 和 30 之间")
	@ExcelField(title="联系人", align=2, sort=3)
	public String getContacterName() {
		return contacterName;
	}

	public void setContacterName(String contacterName) {
		this.contacterName = contacterName;
	}
	
	@Length(min=0, max=2, message="关怀类型长度必须介于 0 和 2 之间")
	@ExcelField(title="关怀类型", dictType="care_type", align=2, sort=4)
	public String getCareType() {
		return careType;
	}

	public void setCareType(String careType) {
		this.careType = careType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="关怀日期", align=2, sort=5)
	public Date getCareDate() {
		return careDate;
	}

	public void setCareDate(Date careDate) {
		this.careDate = careDate;
	}
	
	@Length(min=0, max=200, message="关怀内容长度必须介于 0 和 200 之间")
	@ExcelField(title="关怀内容", align=2, sort=6)
	public String getCareNote() {
		return careNote;
	}

	public void setCareNote(String careNote) {
		this.careNote = careNote;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=7)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	public Date getBeginCareDate() {
		return beginCareDate;
	}

	public void setBeginCareDate(Date beginCareDate) {
		this.beginCareDate = beginCareDate;
	}
	
	public Date getEndCareDate() {
		return endCareDate;
	}

	public void setEndCareDate(Date endCareDate) {
		this.endCareDate = endCareDate;
	}
		
}