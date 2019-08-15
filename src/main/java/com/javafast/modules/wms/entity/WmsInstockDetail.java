/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 入库单Entity
 * @author javafast
 * @version 2017-07-07
 */
public class WmsInstockDetail extends DataEntity<WmsInstockDetail> {
	
	private static final long serialVersionUID = 1L;
	private WmsInstock instock;		// 所属进货单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 基本单位
	private Integer instockNum;		// 已入库数量
	private Integer num;		// 数量
	private Integer diffNum;		// 未入库数量
	private Integer sort;       //排序
	
	public WmsInstockDetail() {
		super();
	}

	public WmsInstockDetail(String id){
		super(id);
	}

	public WmsInstockDetail(WmsInstock instock){
		this.instock = instock;
	}

	public WmsInstock getInstock() {
		return instock;
	}

	public void setInstock(WmsInstock instock) {
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
	
	@ExcelField(title="基本单位", align=2, sort=3)
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	
	@ExcelField(title="已入库数量", align=2, sort=3)
	public Integer getInstockNum() {
		return instockNum;
	}

	public void setInstockNum(Integer instockNum) {
		this.instockNum = instockNum;
	}
	
	@NotNull(message="数量不能为空")
	@ExcelField(title="数量", align=2, sort=4)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="未入库数量", align=2, sort=5)
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