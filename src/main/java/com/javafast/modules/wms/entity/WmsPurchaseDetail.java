/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import javax.validation.constraints.NotNull;

import java.math.BigDecimal;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 采购单Entity
 * @author javafast
 * @version 2017-07-07
 */
public class WmsPurchaseDetail extends DataEntity<WmsPurchaseDetail> {
	
	private static final long serialVersionUID = 1L;
	private WmsPurchase purchase;		// 所属采购单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 基本单位
	private BigDecimal price;		// 单价(元)
	private Integer num;		// 数量
	private BigDecimal amount;		// 金额(元)
	private BigDecimal taxRate;		// 税率
	private BigDecimal taxAmt;		// 税额
	private Integer sort;       //排序
	
	public WmsPurchaseDetail() {
		super();
	}

	public WmsPurchaseDetail(String id){
		super(id);
	}

	public WmsPurchaseDetail(WmsPurchase purchase){
		this.purchase = purchase;
	}

	public WmsPurchase getPurchase() {
		return purchase;
	}

	public void setPurchase(WmsPurchase purchase) {
		this.purchase = purchase;
	}
	
	@NotNull(message="产品不能为空")
	@ExcelField(title="产品", align=2, sort=2)
	public WmsProduct getProduct() {
		return product;
	}

	public void setProduct(WmsProduct product) {
		this.product = product;
	}
	
	@ExcelField(title="基本单位", align=2, sort=3)
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	
	@ExcelField(title="单价(元)", align=2, sort=3)
	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	
	@ExcelField(title="数量", align=2, sort=4)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="金额(元)", align=2, sort=5)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@ExcelField(title="税率", align=2, sort=6)
	public BigDecimal getTaxRate() {
		return taxRate;
	}

	public void setTaxRate(BigDecimal taxRate) {
		this.taxRate = taxRate;
	}
	
	@ExcelField(title="税额", align=2, sort=7)
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
}