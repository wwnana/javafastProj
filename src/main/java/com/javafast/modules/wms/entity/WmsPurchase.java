/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 采购单Entity
 * @author javafast
 * @version 2017-07-07
 */
public class WmsPurchase extends DataEntity<WmsPurchase> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 单号
	private WmsSupplier supplier;		// 供应商
	private String content;		// 内容
	private Integer num;		// 数量
	private BigDecimal totalAmt;		// 合计
	private BigDecimal taxAmt;		// 税额
	private BigDecimal otherAmt;		// 其他费用
	private BigDecimal amount;		// 总计金额
	
	private String status;		// 审核状态
	private User dealBy;		// 经办人
	private Date dealDate;		// 业务日期
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间
	private Date beginDealDate;		// 开始 业务日期
	private Date endDealDate;		// 结束 业务日期
	private List<WmsPurchaseDetail> wmsPurchaseDetailList = Lists.newArrayList();		// 子表列表
	private String delSelectIds;//被删除的子表id 
	
	private String name;		// 单号
	public WmsPurchase() {
		super();
	}

	public WmsPurchase(String id){
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
	
	@ExcelField(title="供应商", align=2, sort=2, fieldType=WmsSupplier.class, value="supplier.name")
	public WmsSupplier getSupplier() {
		return supplier;
	}

	public void setSupplier(WmsSupplier supplier) {
		this.supplier = supplier;
	}
	
	@Length(min=0, max=50, message="内容长度必须介于 0 和 50 之间")
	@ExcelField(title="内容", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ExcelField(title="数量", align=2, sort=4)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="合计", align=2, sort=5)
	public BigDecimal getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(BigDecimal totalAmt) {
		this.totalAmt = totalAmt;
	}
	
	@ExcelField(title="税额", align=2, sort=6)
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	@ExcelField(title="其他费用", align=2, sort=7)
	public BigDecimal getOtherAmt() {
		return otherAmt;
	}

	public void setOtherAmt(BigDecimal otherAmt) {
		this.otherAmt = otherAmt;
	}
	
	@NotNull(message="总计金额不能为空")
	@ExcelField(title="总计金额", align=2, sort=8)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=10)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="经办人", fieldType=User.class, value="dealBy.name", align=2, sort=11)
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
		
	public List<WmsPurchaseDetail> getWmsPurchaseDetailList() {
		return wmsPurchaseDetailList;
	}

	public void setWmsPurchaseDetailList(List<WmsPurchaseDetail> wmsPurchaseDetailList) {
		this.wmsPurchaseDetailList = wmsPurchaseDetailList;
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
}