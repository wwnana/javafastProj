/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.wms.entity.WmsWarehouse;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 销售退单Entity
 * @author javafast
 * @version 2017-07-08
 */
public class OmReturnorder extends DataEntity<OmReturnorder> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private String saleType;		// 销售类型
	private CrmCustomer customer;		// 客户
	private OmOrder order;		// 关联销售订单
	private WmsWarehouse warehouse;		// 入库仓库
	private String content;		// 内容
	private Integer num;		// 数量
	private BigDecimal totalAmt;		// 合计
	private BigDecimal taxAmt;		// 税额
	private BigDecimal otherAmt;		// 其他费用
	private BigDecimal amount;		// 总计金额
	private BigDecimal actualAmt;		// 实退金额
	private FiFinanceAccount fiAccount;		// 结算账户
	private String status;		// 审核状态
	private User dealBy;		// 经办人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private List<OmReturnorderDetail> omReturnorderDetailList = Lists.newArrayList();		// 子表列表
	
	public OmReturnorder() {
		super();
	}

	public OmReturnorder(String id){
		super(id);
	}

	@Length(min=0, max=30, message="单号长度必须介于 0 和 30 之间")
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
	
	@ExcelField(title="客户", align=2, sort=3, fieldType=CrmCustomer.class, value="customer.name")
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@ExcelField(title="关联销售订单", fieldType=OmOrder.class, value="order.no", align=2, sort=4)
	public OmOrder getOrder() {
		return order;
	}

	public void setOrder(OmOrder order) {
		this.order = order;
	}
	
	@ExcelField(title="入库仓库", align=2, sort=5, fieldType=WmsWarehouse.class, value="warehouse.name")
	public WmsWarehouse getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(WmsWarehouse warehouse) {
		this.warehouse = warehouse;
	}
	
	@Length(min=0, max=50, message="内容长度必须介于 0 和 50 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ExcelField(title="数量", align=2, sort=7)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="合计", align=2, sort=8)
	public BigDecimal getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(BigDecimal totalAmt) {
		this.totalAmt = totalAmt;
	}
	
	@ExcelField(title="税额", align=2, sort=9)
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	@ExcelField(title="其他费用", align=2, sort=10)
	public BigDecimal getOtherAmt() {
		return otherAmt;
	}

	public void setOtherAmt(BigDecimal otherAmt) {
		this.otherAmt = otherAmt;
	}
	
	@NotNull(message="总计金额不能为空")
	@ExcelField(title="总计金额", align=2, sort=11)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@ExcelField(title="实退金额", align=2, sort=12)
	public BigDecimal getActualAmt() {
		return actualAmt;
	}

	public void setActualAmt(BigDecimal actualAmt) {
		this.actualAmt = actualAmt;
	}
	
	@ExcelField(title="结算账户", align=2, sort=13, fieldType=FiFinanceAccount.class, value="fiAccount.name")
	public FiFinanceAccount getFiAccount() {
		return fiAccount;
	}

	public void setFiAccount(FiFinanceAccount fiAccount) {
		this.fiAccount = fiAccount;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=14)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="经办人", fieldType=User.class, value="dealBy.name", align=2, sort=15)
	public User getDealBy() {
		return dealBy;
	}

	public void setDealBy(User dealBy) {
		this.dealBy = dealBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="业务日期", align=2, sort=16)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
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
		
	public List<OmReturnorderDetail> getOmReturnorderDetailList() {
		return omReturnorderDetailList;
	}

	public void setOmReturnorderDetailList(List<OmReturnorderDetail> omReturnorderDetailList) {
		this.omReturnorderDetailList = omReturnorderDetailList;
	}
}