/**
 * Copyright 2015-2020
 */
package com.javafast.modules.scm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.sys.entity.User;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户投诉Entity
 * @author javafast
 * @version 2017-08-18
 */
public class ScmComplaint extends DataEntity<ScmComplaint> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 主题
	private OmContract omContract;		// 订单合同
	private CrmCustomer customer;		// 客户
	private User ownBy;		// 负责人
	private String levelType;		// 优先级
	private Date endDate;		// 截止日期
	private String expecte;		// 期望结果
	private String content;		// 内容
	private String status;		// 处理状态
	private Date dealDate;		// 处理日期
	private String satisfyType;		// 满意度
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核日期
	
	private Date beginEndDate;		// 开始 截止日期
	private Date endEndDate;		// 结束 截止日期
	
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public ScmComplaint() {
		super();
	}

	public ScmComplaint(String id){
		super(id);
	}

	@Length(min=1, max=50, message="主题长度必须介于 1 和 50 之间")
	@ExcelField(title="主题", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
	
	@ExcelField(title="订单合同", fieldType=OmContract.class, value="omContract.name", align=2, sort=2)
	public OmContract getOmContract() {
		return omContract;
	}

	public void setOmContract(OmContract omContract) {
		this.omContract = omContract;
	}

	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=3)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=4)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="优先级长度必须介于 0 和 1 之间")
	@ExcelField(title="优先级", dictType="level_type", align=2, sort=5)
	public String getLevelType() {
		return levelType;
	}

	public void setLevelType(String levelType) {
		this.levelType = levelType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="截止日期", align=2, sort=6)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@Length(min=0, max=200, message="期望结果长度必须介于 0 和 200 之间")
	@ExcelField(title="期望结果", align=2, sort=7)
	public String getExpecte() {
		return expecte;
	}

	public void setExpecte(String expecte) {
		this.expecte = expecte;
	}
	
	@Length(min=0, max=10000, message="内容长度必须介于 0 和 10000 之间")
	@ExcelField(title="内容", align=2, sort=8)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=9)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="处理日期", align=2, sort=10)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@Length(min=0, max=1, message="满意度长度必须介于 0 和 1 之间")
	@ExcelField(title="满意度", dictType="satisfy_type", align=2, sort=11)
	public String getSatisfyType() {
		return satisfyType;
	}

	public void setSatisfyType(String satisfyType) {
		this.satisfyType = satisfyType;
	}
	
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=12)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="审核日期", align=2, sort=13)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}
	
	public Date getBeginEndDate() {
		return beginEndDate;
	}

	public void setBeginEndDate(Date beginEndDate) {
		this.beginEndDate = beginEndDate;
	}
	
	public Date getEndEndDate() {
		return endEndDate;
	}

	public void setEndEndDate(Date endEndDate) {
		this.endEndDate = endEndDate;
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