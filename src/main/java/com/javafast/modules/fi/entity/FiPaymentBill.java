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
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 付款单Entity
 * @author javafast
 * @version 2017-07-17
 */
public class FiPaymentBill extends DataEntity<FiPaymentBill> {
	
	private static final long serialVersionUID = 1L;
	private FiPaymentAble fiPaymentAble;		// 所属应付款
	private String no;		// 单号
	private WmsSupplier supplier;		// 供应商
	private CrmCustomer customer;		// 客户
	private BigDecimal amount;		// 付款金额
	private Date dealDate;		// 付款时间
	private FiFinanceAccount fiAccount;		// 付款账户
	private User ownBy;		// 负责人
	private String status;		// 状态
	
	private User auditBy;		// 审核人
	private Date auditDate;    //审核时间
	
	private Date beginDealDate;		// 开始 付款时间
	private Date endDealDate;		// 结束 付款时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public FiPaymentBill() {
		super();
	}

	public FiPaymentBill(String id){
		super(id);
	}
	
	public FiPaymentBill(FiPaymentAble fiPaymentAble){
		this.fiPaymentAble = fiPaymentAble; 
	}

	@ExcelField(title="所属应付款", fieldType=FiPaymentAble.class, value="fiPaymentAble.no", align=2, sort=1)
	public FiPaymentAble getFiPaymentAble() {
		return fiPaymentAble;
	}

	public void setFiPaymentAble(FiPaymentAble fiPaymentAble) {
		this.fiPaymentAble = fiPaymentAble;
	}
	
	@Length(min=1, max=30, message="单号长度必须介于 1 和 30 之间")
	@ExcelField(title="单号", align=2, sort=2)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@ExcelField(title="供应商", fieldType=WmsSupplier.class, value="supplier.name", align=2, sort=3)
	public WmsSupplier getSupplier() {
		return supplier;
	}

	public void setSupplier(WmsSupplier supplier) {
		this.supplier = supplier;
	}

	@NotNull(message="付款金额不能为空")
	@ExcelField(title="付款金额", align=2, sort=4)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="付款时间", align=2, sort=5)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="付款账户", fieldType=FiFinanceAccount.class, value="fiAccount.name", align=2, sort=6)
	public FiFinanceAccount getFiAccount() {
		return fiAccount;
	}

	public void setFiAccount(FiFinanceAccount fiAccount) {
		this.fiAccount = fiAccount;
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
		
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=19)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=20)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}

	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
}