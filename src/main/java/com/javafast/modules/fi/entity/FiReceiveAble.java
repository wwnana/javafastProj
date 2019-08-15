/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 应收款Entity
 * @author javafast
 * @version 2017-07-14
 */
public class FiReceiveAble extends DataEntity<FiReceiveAble> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private OmOrder order;		// 合同订单
	private CrmCustomer customer;		// 客户
	private BigDecimal amount;		// 应收金额
	private BigDecimal realAmt;		// 实际已收
	private Date ableDate;		// 应收时间
	private User ownBy;		// 负责人
	private String status;		// 状态

	private Date beginAbleDate;		// 开始 应收时间
	private Date endAbleDate;		// 结束 应收时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private List<FiReceiveBill> fiReceiveBillList = Lists.newArrayList();		// 子表列表
	
	private String name;		// 单号
	private boolean isUnComplete;    //未完成的
	
	public FiReceiveAble() {
		super();
	}

	public FiReceiveAble(String id){
		super(id);
	}

	@Length(min=1, max=50, message="单号长度必须介于 1 和 50 之间")
	@ExcelField(title="单号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@ExcelField(title="合同订单", fieldType=OmOrder.class, value="order.no", align=2, sort=2)
	public OmOrder getOrder() {
		return order;
	}

	public void setOrder(OmOrder order) {
		this.order = order;
	}
	
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=3)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@NotNull(message="应收金额不能为空")
	@ExcelField(title="应收金额", align=2, sort=4)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@ExcelField(title="实际已收", align=2, sort=5)
	public BigDecimal getRealAmt() {
		return realAmt;
	}

	public void setRealAmt(BigDecimal realAmt) {
		this.realAmt = realAmt;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="应收时间", align=2, sort=6)
	public Date getAbleDate() {
		return ableDate;
	}

	public void setAbleDate(Date ableDate) {
		this.ableDate = ableDate;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=7)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=8)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getBeginAbleDate() {
		return beginAbleDate;
	}

	public void setBeginAbleDate(Date beginAbleDate) {
		this.beginAbleDate = beginAbleDate;
	}
	
	public Date getEndAbleDate() {
		return endAbleDate;
	}

	public void setEndAbleDate(Date endAbleDate) {
		this.endAbleDate = endAbleDate;
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
		
	public List<FiReceiveBill> getFiReceiveBillList() {
		return fiReceiveBillList;
	}

	public void setFiReceiveBillList(List<FiReceiveBill> fiReceiveBillList) {
		this.fiReceiveBillList = fiReceiveBillList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isUnComplete() {
		return isUnComplete;
	}

	public void setUnComplete(boolean isUnComplete) {
		this.isUnComplete = isUnComplete;
	}
}