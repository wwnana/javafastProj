/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.entity.onetomany;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.test.entity.tree.TestTree;

import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 订单信息Entity
 * @author javafast
 * @version 2017-07-16
 */
public class TestDataMain extends DataEntity<TestDataMain> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private String saleType;		// 销售类型
	private BigDecimal amount;		// 订单总额(元)
	private BigDecimal invoiceAmt;		// 开票金额(元)
	private User dealBy;		// 经办人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private String status;		// 审核状态
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private List<TestDataChild> testDataChildList = Lists.newArrayList();		// 子表列表
	
	private String delSelectIds;//被删除的子表id 
	
	public TestDataMain() {
		super();
	}

	public TestDataMain(String id){
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
	
	@Length(min=1, max=1, message="销售类型长度必须介于 1 和 1 之间")
	@ExcelField(title="销售类型", dictType="sale_type", align=2, sort=2)
	public String getSaleType() {
		return saleType;
	}

	public void setSaleType(String saleType) {
		this.saleType = saleType;
	}
	
	@NotNull(message="订单总额(元)不能为空")
	@ExcelField(title="订单总额(元)", align=2, sort=3)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@ExcelField(title="开票金额(元)", align=2, sort=4)
	public BigDecimal getInvoiceAmt() {
		return invoiceAmt;
	}

	public void setInvoiceAmt(BigDecimal invoiceAmt) {
		this.invoiceAmt = invoiceAmt;
	}
	
	@NotNull(message="经办人不能为空")
	@ExcelField(title="经办人", fieldType=User.class, value="dealBy.name", align=2, sort=5)
	public User getDealBy() {
		return dealBy;
	}

	public void setDealBy(User dealBy) {
		this.dealBy = dealBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="业务日期不能为空")
	@ExcelField(title="业务日期", align=2, sort=6)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=9)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=10)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=11)
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
		
	public List<TestDataChild> getTestDataChildList() {
		return testDataChildList;
	}

	public void setTestDataChildList(List<TestDataChild> testDataChildList) {
		this.testDataChildList = testDataChildList;
	}

	public String getDelSelectIds() {
		return delSelectIds;
	}

	public void setDelSelectIds(String delSelectIds) {
		this.delSelectIds = delSelectIds;
	}
}