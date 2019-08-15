/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 调拨单Entity
 * @author javafast
 * @version 2018-01-11
 */
public class WmsAllotDetail extends DataEntity<WmsAllotDetail> {
	
	private static final long serialVersionUID = 1L;
	private WmsAllot wmsAllot;		// 所属调拨单 父类
	private WmsProduct product;		// 产品
	private String unitType;		// 基本单位
	private Integer num;		// 数量
	private Integer sort;		// 排序
	
	public WmsAllotDetail() {
		super();
	}

	public WmsAllotDetail(String id){
		super(id);
	}

	public WmsAllotDetail(WmsAllot wmsAllot){
		this.wmsAllot = wmsAllot;
	}

	public WmsAllot getWmsAllot() {
		return wmsAllot;
	}

	public void setWmsAllot(WmsAllot wmsAllot) {
		this.wmsAllot = wmsAllot;
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
	
	@ExcelField(title="数量", align=2, sort=3)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@ExcelField(title="排序", align=2, sort=5)
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
}