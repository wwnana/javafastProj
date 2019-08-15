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
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 收款单Entity
 * @author javafast
 * @version 2017-07-14
 */
public class FiReceiveBill extends DataEntity<FiReceiveBill> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private FiReceiveAble fiReceiveAble;		// 应收款
	private OmOrder order;		// 合同订单
	private CrmCustomer customer;		// 客户
	private BigDecimal amount;		// 收款金额
	private Date dealDate;		// 收款时间
	private FiFinanceAccount fiAccount;		// 收款账户
	private User ownBy;		// 收款人
	private String isInvoice;		// 是否开票
	private BigDecimal invoiceAmt;		// 开票金额
	private String status;		// 状态
	
	private User auditBy;		// 审核人
	private Date auditDate;    //审核时间
	
	
	private Date beginDealDate;		// 开始 收款时间
	private Date endDealDate;		// 结束 收款时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public FiReceiveBill() {
		super();
	}

	public FiReceiveBill(String id){
		super(id);
	}
	
	public FiReceiveBill(FiReceiveAble fiReceiveAble){
		this.fiReceiveAble = fiReceiveAble;
	}

	@Length(min=1, max=30, message="单号长度必须介于 1 和 30 之间")
	@ExcelField(title="单号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@ExcelField(title="应收款", fieldType=FiReceiveAble.class, value="fiReceiveAble.no", align=2, sort=2, type=1)
	public FiReceiveAble getFiReceiveAble() {
		return fiReceiveAble;
	}

	public void setFiReceiveAble(FiReceiveAble fiReceiveAble) {
		this.fiReceiveAble = fiReceiveAble;
	}
	
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=3, type=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@NotNull(message="收款金额不能为空")
	@ExcelField(title="收款金额", align=2, sort=4)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="收款时间", align=2, sort=5, type=1)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="收款账户", fieldType=FiFinanceAccount.class, value="fiAccount.name", align=2, sort=6, type=1)
	public FiFinanceAccount getFiAccount() {
		return fiAccount;
	}

	public void setFiAccount(FiFinanceAccount fiAccount) {
		this.fiAccount = fiAccount;
	}
	
	@ExcelField(title="收款人", fieldType=User.class, value="ownBy.name", align=2, sort=7, type=1)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="是否开票长度必须介于 0 和 1 之间")
	@ExcelField(title="是否开票", dictType="yes_no", align=2, sort=8, type=1)
	public String getIsInvoice() {
		return isInvoice;
	}

	public void setIsInvoice(String isInvoice) {
		this.isInvoice = isInvoice;
	}
	
	@ExcelField(title="开票金额", align=2, sort=9)
	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public void setInvoiceAmt(BigDecimal invoiceAmt) {
		this.invoiceAmt = invoiceAmt;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=10, type=1)
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
		
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=19, type=1)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=20, type=1)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}

	public OmOrder getOrder() {
		return order;
	}

	public void setOrder(OmOrder order) {
		this.order = order;
	}
}