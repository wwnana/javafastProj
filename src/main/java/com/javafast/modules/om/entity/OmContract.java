/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 合同Entity
 * @author javafast
 * @version 2017-07-13
 */
public class OmContract extends DataEntity<OmContract> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 合同编号
	private String name;		// 主题
	private OmOrder order;		// 销售订单
	private CrmQuote quote;		// 报价单
	private CrmChance chance;		// 商机
	private CrmCustomer customer;		// 客户
	private BigDecimal amount;		// 总金额
	private Date dealDate;		// 签约日期
	private Date deliverDate;		// 交付时间
	private Date startDate;		// 生效时间
	private Date endDate;		// 到期时间
	private User ownBy;		// 销售负责人
	private User auditBy;		// 审核人
	private Date auditDate;    //审核时间
	private String notes;		// 正文
	private String files;		// 附件
	private String status;		// 状态
	
	private Date beginDealDate;		// 开始 签约日期
	private Date endDealDate;		// 结束 签约日期
	private Date beginDeliverDate;		// 开始 交付时间
	private Date endDeliverDate;		// 结束 交付时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	private List<OmOrderDetail> omOrderDetailList = Lists.newArrayList();		// 子表列表
	private String delSelectIds;//被删除的子表id 
	
	public OmContract() {
		super();
	}

	public OmContract(String id){
		super(id);
	}

	@Length(min=1, max=30, message="合同编号长度必须介于 1 和 30 之间")
	@ExcelField(title="合同编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=0, max=50, message="主题长度必须介于 0 和 50 之间")
	@ExcelField(title="主题", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public OmOrder getOrder() {
		return order;
	}

	public void setOrder(OmOrder order) {
		this.order = order;
	}
	
	@ExcelField(title="报价单", fieldType=CrmQuote.class, value="quote.no", align=2, sort=4)
	public CrmQuote getQuote() {
		return quote;
	}

	public void setQuote(CrmQuote quote) {
		this.quote = quote;
	}
	
	@ExcelField(title="商机", fieldType=CrmChance.class, value="chance.name", align=2, sort=5)
	public CrmChance getChance() {
		return chance;
	}

	public void setChance(CrmChance chance) {
		this.chance = chance;
	}
	
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=6)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@ExcelField(title="总金额", align=2, sort=7)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="签约日期", align=2, sort=8)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="交付时间", align=2, sort=9)
	public Date getDeliverDate() {
		return deliverDate;
	}

	public void setDeliverDate(Date deliverDate) {
		this.deliverDate = deliverDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="生效时间", align=2, sort=10)
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="到期时间", align=2, sort=11)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@ExcelField(title="销售负责人", fieldType=User.class, value="ownBy.name", align=2, sort=12)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=100000, message="正文长度必须介于 0 和 100000 之间")
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	@Length(min=0, max=2000, message="附件长度必须介于 0 和 2000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=15)
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
		
	public Date getBeginDeliverDate() {
		return beginDeliverDate;
	}

	public void setBeginDeliverDate(Date beginDeliverDate) {
		this.beginDeliverDate = beginDeliverDate;
	}
	
	public Date getEndDeliverDate() {
		return endDeliverDate;
	}

	public void setEndDeliverDate(Date endDeliverDate) {
		this.endDeliverDate = endDeliverDate;
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
	
	public List<OmOrderDetail> getOmOrderDetailList() {
		return omOrderDetailList;
	}

	public void setOmOrderDetailList(List<OmOrderDetail> omOrderDetailList) {
		this.omOrderDetailList = omOrderDetailList;
	}
		
	public String getDelSelectIds() {
		return delSelectIds;
	}

	public void setDelSelectIds(String delSelectIds) {
		this.delSelectIds = delSelectIds;
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
}