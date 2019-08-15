/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.sys.entity.User;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 出库单Entity
 * @author javafast
 * @version 2017-07-07
 */
public class WmsOutstock extends DataEntity<WmsOutstock> {
	
	private static final long serialVersionUID = 1L;
	private String outstockType;		// 出库单类型 0：销售出库，1：采购退货出库，2：调拨出库
	private String no;		// 单号
	private OmOrder order;		// 关联订单号
	private CrmCustomer customer;		// 客户
	private WmsSupplier supplier;		// 供应商
	private String content;		// 内容
	private Integer num;		// 数量
	private Integer realNum;   //已出库数量
	private Integer diffNum;		// 差异数
	private WmsWarehouse warehouse;		// 出库仓库
	private String status;		// 审核状态
	private User dealBy;		// 经办人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private Date beginCreateDate;		// 开始 制单时间
	private Date endCreateDate;		// 结束 制单时间
	private Date beginAuditDate;		// 开始 审核时间
	private Date endAuditDate;		// 结束 审核时间
	private List<WmsOutstockDetail> wmsOutstockDetailList = Lists.newArrayList();		// 子表列表
	
	public WmsOutstock() {
		super();
	}

	public WmsOutstock(String id){
		super(id);
	}

	@Length(min=1, max=1, message="出库单类型长度必须介于 1 和 1 之间")
	@ExcelField(title="出库单类型", dictType="outstock_type", align=2, sort=1)
	public String getOutstockType() {
		return outstockType;
	}

	public void setOutstockType(String outstockType) {
		this.outstockType = outstockType;
	}
	
	@Length(min=1, max=30, message="单号长度必须介于 1 和 30 之间")
	@ExcelField(title="单号", align=2, sort=2)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@ExcelField(title="关联订单号", align=2, sort=3, fieldType=OmOrder.class, value="order.name")
	public OmOrder getOrder() {
		return order;
	}

	public void setOrder(OmOrder order) {
		this.order = order;
	}
	
	@ExcelField(title="供应商", fieldType=WmsSupplier.class, value="supplier.name", align=2, sort=4)
	public WmsSupplier getSupplier() {
		return supplier;
	}

	public void setSupplier(WmsSupplier supplier) {
		this.supplier = supplier;
	}
	
	@Length(min=0, max=50, message="内容长度必须介于 0 和 50 之间")
	@ExcelField(title="内容", align=2, sort=5)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ExcelField(title="数量", align=2, sort=6)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="出库仓库", align=2, sort=7, fieldType=WmsWarehouse.class, value="warehouse.name")
	public WmsWarehouse getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(WmsWarehouse warehouse) {
		this.warehouse = warehouse;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=8)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="经办人", fieldType=User.class, value="dealBy.name", align=2, sort=9)
	public User getDealBy() {
		return dealBy;
	}

	public void setDealBy(User dealBy) {
		this.dealBy = dealBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="业务日期", align=2, sort=10)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="审核人", fieldType=User.class, value="auditBy.name", align=2, sort=13)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=14)
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
		
	public List<WmsOutstockDetail> getWmsOutstockDetailList() {
		return wmsOutstockDetailList;
	}

	public void setWmsOutstockDetailList(List<WmsOutstockDetail> wmsOutstockDetailList) {
		this.wmsOutstockDetailList = wmsOutstockDetailList;
	}

	public Integer getDiffNum() {
		return diffNum;
	}

	public void setDiffNum(Integer diffNum) {
		this.diffNum = diffNum;
	}
	
	public Integer getRealNum() {
		return realNum;
	}

	public void setRealNum(Integer realNum) {
		this.realNum = realNum;
	}

	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
}