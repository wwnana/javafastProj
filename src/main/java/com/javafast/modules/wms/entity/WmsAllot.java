/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 调拨单Entity
 * @author javafast
 * @version 2018-01-11
 */
public class WmsAllot extends DataEntity<WmsAllot> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private Integer num;		// 总数量
	private Integer realNum;		// 已完成数
	private WmsWarehouse outWarehouse;		// 调出仓库
	private WmsWarehouse inWarehouse;		// 调入出库
	private String logisticsCompany;		// 物流公司
	private String logisticsNo;		// 物流单号
	private BigDecimal logisticsAmount;		// 运费
	private FiFinanceAccount fiAccount;		// 支付账户
	private String status;		// 审核状态
	private User dealBy;		// 经办人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private List<WmsAllotDetail> wmsAllotDetailList = Lists.newArrayList();		// 子表列表
	
	public WmsAllot() {
		super();
	}

	public WmsAllot(String id){
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
	
	@ExcelField(title="总数量", align=2, sort=2)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="已完成数", align=2, sort=3)
	public Integer getRealNum() {
		return realNum;
	}

	public void setRealNum(Integer realNum) {
		this.realNum = realNum;
	}
	
	@ExcelField(title="调出仓库", align=2, sort=4)
	public WmsWarehouse getOutWarehouse() {
		return outWarehouse;
	}

	public void setOutWarehouse(WmsWarehouse outWarehouse) {
		this.outWarehouse = outWarehouse;
	}
	
	@ExcelField(title="调入出库", align=2, sort=5)
	public WmsWarehouse getInWarehouse() {
		return inWarehouse;
	}

	public void setInWarehouse(WmsWarehouse inWarehouse) {
		this.inWarehouse = inWarehouse;
	}
	
	@Length(min=0, max=50, message="物流公司长度必须介于 0 和 50 之间")
	@ExcelField(title="物流公司", align=2, sort=6)
	public String getLogisticsCompany() {
		return logisticsCompany;
	}

	public void setLogisticsCompany(String logisticsCompany) {
		this.logisticsCompany = logisticsCompany;
	}
	
	@Length(min=0, max=50, message="物流单号长度必须介于 0 和 50 之间")
	@ExcelField(title="物流单号", align=2, sort=7)
	public String getLogisticsNo() {
		return logisticsNo;
	}

	public void setLogisticsNo(String logisticsNo) {
		this.logisticsNo = logisticsNo;
	}
	
	@ExcelField(title="运费", align=2, sort=8)
	public BigDecimal getLogisticsAmount() {
		return logisticsAmount;
	}

	public void setLogisticsAmount(BigDecimal logisticsAmount) {
		this.logisticsAmount = logisticsAmount;
	}
	
	@ExcelField(title="支付账户", align=2, sort=9)
	public FiFinanceAccount getFiAccount() {
		return fiAccount;
	}

	public void setFiAccount(FiFinanceAccount fiAccount) {
		this.fiAccount = fiAccount;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=10)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="经办人", align=2, sort=11)
	public User getDealBy() {
		return dealBy;
	}

	public void setDealBy(User dealBy) {
		this.dealBy = dealBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="业务日期", align=2, sort=12)
	public Date getDealDate() {
		return dealDate;
	}

	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	
	@ExcelField(title="审核人", align=2, sort=15)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核时间", align=2, sort=16)
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
		
	public List<WmsAllotDetail> getWmsAllotDetailList() {
		return wmsAllotDetailList;
	}

	public void setWmsAllotDetailList(List<WmsAllotDetail> wmsAllotDetailList) {
		this.wmsAllotDetailList = wmsAllotDetailList;
	}
}