/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 出库单Entity
 * @author javafast
 * @version 2017-07-07
 */
public class WmsOutstockDetail extends DataEntity<WmsOutstockDetail> {
	
	private static final long serialVersionUID = 1L;
	private WmsOutstock instock;		// 所属出库单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 单位
	private Integer num;		// 数量
	private Integer outstockNum;		// 已出库数量
	private Integer diffNum;		// 未出库数量
	private Integer sort;       //排序
	
	public WmsOutstockDetail() {
		super();
	}

	public WmsOutstockDetail(String id){
		super(id);
	}

	public WmsOutstockDetail(WmsOutstock instock){
		this.instock = instock;
	}

	public WmsOutstock getInstock() {
		return instock;
	}

	public void setInstock(WmsOutstock instock) {
		this.instock = instock;
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
	
	@ExcelField(title="数量", align=2, sort=4)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="已出库数量", align=2, sort=5)
	public Integer getOutstockNum() {
		return outstockNum;
	}

	public void setOutstockNum(Integer outstockNum) {
		this.outstockNum = outstockNum;
	}
	
	@ExcelField(title="未出库数量", align=2, sort=6)
	public Integer getDiffNum() {
		return diffNum;
	}

	public void setDiffNum(Integer diffNum) {
		this.diffNum = diffNum;
	}
	
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
}