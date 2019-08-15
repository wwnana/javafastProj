/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.entity;

import javax.validation.constraints.NotNull;

import java.math.BigDecimal;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.wms.entity.WmsProduct;

/**
 * 销售退单Entity
 * @author javafast
 * @version 2017-07-08
 */
public class OmReturnorderDetail extends DataEntity<OmReturnorderDetail> {
	
	private static final long serialVersionUID = 1L;
	private OmReturnorder returnorder;		// 所属销售退单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 单位
	private BigDecimal price;		// 单价(元)
	private Integer num;		// 数量
	private BigDecimal amount;		// 金额(元)
	private BigDecimal taxRate;		// 税率
	private BigDecimal taxAmt;		// 税额
	private Integer sort;       //排序
	
	public OmReturnorderDetail() {
		super();
	}

	public OmReturnorderDetail(String id){
		super(id);
	}

	public OmReturnorderDetail(OmReturnorder returnorder){
		this.returnorder = returnorder;
	}

	public OmReturnorder getReturnorder() {
		return returnorder;
	}

	public void setReturnorder(OmReturnorder returnorder) {
		this.returnorder = returnorder;
	}
	
	@NotNull(message="产品不能为空")
	@ExcelField(title="产品", align=2, sort=2)
	public WmsProduct getProduct() {
		return product;
	}

	public void setProduct(WmsProduct product) {
		this.product = product;
	}
	
	@Length(min=0, max=30, message="单位长度必须介于 0 和 30 之间")
	@ExcelField(title="单位", align=2, sort=3)
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