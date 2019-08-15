package com.javafast.modules.crm.entity;

import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.wms.entity.WmsProduct;

/**
 * 报价单Entity
 */
public class CrmQuoteDetail extends DataEntity<CrmQuoteDetail> {
	
	private static final long serialVersionUID = 1L;
	private CrmQuote quote;		// 报价单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 基本单位
	private BigDecimal price;		// 单价
	private Integer num;		// 数量
	private BigDecimal amt;		// 金额
	private Integer sort;       //排序
	
	public CrmQuoteDetail() {
		super();
	}

	public CrmQuoteDetail(String id){
		super(id);
	}

	public CrmQuoteDetail(CrmQuote quote){
		this.quote = quote;
	}

	public CrmQuote getQuote() {
		return quote;
	}

	public void setQuote(CrmQuote quote) {
		this.quote = quote;
	}
	
	@ExcelField(title="产品", align=2, sort=2)
	public WmsProduct getProduct() {
		return product;
	}

	public void setProduct(WmsProduct product) {
		this.product = product;
	}
	
	@ExcelField(title="单价", align=2, sort=3)
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
	
	@ExcelField(title="金额", align=2, sort=5)
	public BigDecimal getAmt() {
		return amt;
	}

	public void setAmt(BigDecimal amt) {
		this.amt = amt;
	}
	
	@ExcelField(title="基本单位", align=2, sort=3)
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
}