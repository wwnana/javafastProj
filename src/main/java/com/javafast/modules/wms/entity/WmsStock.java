/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.fi.entity.FiFinanceAccount;

/**
 * 产品库存Entity
 * @author javafast
 * @version 2017-07-05
 */
public class WmsStock extends DataEntity<WmsStock> {
	
	private static final long serialVersionUID = 1L;
	private WmsProduct product;		// 产品
	private WmsWarehouse warehouse;		// 仓库
	private Integer stockNum;		// 库存数
	private Integer warnNum;		// 预警数
	
	//查询条件
	private String productId;
	private String warehouseId;
	
	public WmsStock() {
		super();
	}

	public WmsStock(String id){
		super(id);
	}
	
	public WmsStock(String productId, String warehouseId){
		this.productId = productId;
		this.warehouseId = warehouseId;
	}

	@ExcelField(title="产品", fieldType=WmsProduct.class, align=2, sort=1, value="product.name")
	public WmsProduct getProduct() {
		return product;
	}

	public void setProduct(WmsProduct product) {
		this.product = product;
	}
	
	@ExcelField(title="仓库", align=2, sort=2, fieldType=WmsWarehouse.class, value="warehouse.name")
	public WmsWarehouse getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(WmsWarehouse warehouse) {
		this.warehouse = warehouse;
	}
	
	@ExcelField(title="库存数", align=2, sort=3)
	public Integer getStockNum() {
		return stockNum;
	}

	public void setStockNum(Integer stockNum) {
		this.stockNum = stockNum;
	}
	
	@ExcelField(title="预警数", align=2, sort=4)
	public Integer getWarnNum() {
		return warnNum;
	}

	public void setWarnNum(Integer warnNum) {
		this.warnNum = warnNum;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getWarehouseId() {
		return warehouseId;
	}

	public void setWarehouseId(String warehouseId) {
		this.warehouseId = warehouseId;
	}
	
}