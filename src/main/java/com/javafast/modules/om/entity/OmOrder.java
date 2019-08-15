/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.sys.entity.User;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 销售订单Entity
 * @author javafast
 * @version 2017-07-14
 */
public class OmOrder extends DataEntity<OmOrder> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private String saleType;		// 销售类型
	private CrmCustomer customer;		// 客户
	private String content;		// 订单描述
	private Integer num;		// 总数量
	private BigDecimal totalAmt;		// 合计
	private BigDecimal taxAmt;		// 税额
	private BigDecimal otherAmt;		// 其他费用
	private BigDecimal amount;		// 总计金额
	private FiFinanceAccount fiAccount;		// 结算账户
	private BigDecimal bookAmt;		// 订金
	private BigDecimal receiveAmt;		// 回款金额
	private String isInvoice;		// 是否开票
	private BigDecimal invoiceAmt;		// 开票金额
	private BigDecimal profitAmt;		// 毛利润
	private String status;		// 审核状态
	private User dealBy;		// 经办人 负责人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private User ownBy;         //负责人

	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private Date beginCreateDate;		// 开始 制单时间
	private Date endCreateDate;		// 结束 制单时间
	private Date beginAuditDate;		// 开始 审核时间
	private Date endAuditDate;		// 结束 审核时间
	private List<OmOrderDetail> omOrderDetailList = Lists.newArrayList();		// 子表列表
	private String delSelectIds;//被删除的子表id 
	
	private String name;		// 单号
	public OmOrder() {
		super();
	}

	public OmOrder(String id){
		super(id);
	}

	@Length(min=1, max=30, message="单号长度必须介于 1 和 30 之间")
	@ExcelField(title="单号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=0, max=1, message="销售类型长度必须介于 0 和 1 之间")
	@ExcelField(title="销售类型", dictType="sale_type", align=2, sort=2)
	public String getSaleType() {
		return saleType;
	}

	public void setSaleType(String saleType) {
		this.saleType = saleType;
	}
	
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=3)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=50, message="内容长度必须介于 0 和 50 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ExcelField(title="总数量", align=2, sort=5)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="合计", align=2, sort=6)
	public BigDecimal getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(BigDecimal totalAmt) {
		this.totalAmt = totalAmt;
	}
	
	@ExcelField(title="税额", align=2, sort=7)
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	@ExcelField(title="其他费用", align=2, sort=8)
	public BigDecimal getOtherAmt() {
		return otherAmt;
	}

	public void setOtherAmt(BigDecimal otherAmt) {
		this.otherAmt = otherAmt;
	}
	
	@ExcelField(title="总计金额", align=2, sort=9)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@ExcelField(title="结算账户", fieldType=FiFinanceAccount.class, value="fiAccount.name", align=2, sort=10)
	public FiFinanceAccount getFiAccount() {
		return fiAccount;
	}

	public void setFiAccount(FiFinanceAccount fiAccount) {
		this.fiAccount = fiAccount;
	}
	
	@ExcelField(title="订金", align=2, sort=11)
	public BigDecimal getBookAmt() {
		return bookAmt;
	}

	public void setBookAmt(BigDecimal bookAmt) {
		this.bookAmt = bookAmt;
	}
	
	@ExcelField(title="回款金额", align=2, sort=12)
	public BigDecimal getReceiveAmt() {
		return receiveAmt;
	}

	public void setReceiveAmt(BigDecimal receiveAmt) {
		this.receiveAmt = receiveAmt;
	}
	
	@Length(min=0, max=1, message="是否开票长度必须介于 0 和 1 之间")
	@ExcelField(title="是否开票", dictType="yes_no", align=2, sort=13)
	public String getIsInvoice() {
		return isInvoice;
	}

	public void setIsInvoice(String isInvoice) {
		this.isInvoice = isInvoice;
	}
	
	@ExcelField(title="开票金额", align=2, sort=14)
	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public void setInvoiceAmt(BigDecimal invoiceAmt) {
		this.invoiceAmt = invoiceAmt;
	}
	
	@ExcelField(title="毛利润", align=2, sort=15)
	public BigDecimal getProfitAmt() {
		return profitAmt;
	}

	public void setProfitAmt(BigDecimal profitAmt) {
		this.profitAmt = profitAmt;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=16)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="经办人", fieldType=User.class, value="dealBy.name", align=2, sort=17)
	public User getDealBy() {
		return dealBy;
	}

	public void setDealBy(User dealBy) {
		this.dealBy = dealBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="业务日期", align=2, sort=18)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=21)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=22)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
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
		
	public Date getBeginAuditDate() {
		return beginAuditDate;
	}

	public void setBeginAuditDate(Date beginAuditDate) {
		this.beginAuditDate = beginAuditDate;
	}
	
	public Date getEndAuditDate() {
		return endAuditDate;
	}

	public void setEndAuditDate(Date endAuditDate) {
		this.endAuditDate = endAuditDate;
	}
		
	public List<OmOrderDetail> getOmOrderDetailList() {
		return omOrderDetailList;
	}

	public void setOmOrderDetailList(List<OmOrderDetail> omOrderDetailList) {
		this.omOrderDetailList = omOrderDetailList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getDelSelectIds() {
		return delSelectIds;
	}

	public void setDelSelectIds(String delSelectIds) {
		this.delSelectIds = delSelectIds;
	}

	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
}