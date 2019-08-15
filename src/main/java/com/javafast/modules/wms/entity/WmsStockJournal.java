/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 库存流水Entity
 * @author javafast
 * @version 2017-07-05
 */
public class WmsStockJournal extends DataEntity<WmsStockJournal> {
	
	private static final long serialVersionUID = 1L;
	private WmsProduct product;		// 产品
	private String dealType;		// 操作类型
	private Integer num;		// 数量
	private String notes;		// 摘要
	private WmsWarehouse warehouse;		// 仓库
	private String uniqueCode;		// 唯一码
	private Date beginCreateDate;		// 开始 操作日期
	private Date endCreateDate;		// 结束 操作日期
	
	public WmsStockJournal() {
		super();
	}

	public WmsStockJournal(String id){
		super(id);
	}

	@ExcelField(title="产品", align=2, sort=1, fieldType=WmsProduct.class, value = "product.name")
	public WmsProduct getProduct() {
		return product;
	}

	public void setProduct(WmsProduct product) {
		this.product = product;
	}
	
	@Length(min=0, max=1, message="操作类型长度必须介于 0 和 1 之间")
	@ExcelField(title="操作类型", dictType="deal_type", align=2, sort=2)
	public String getDealType() {
		return dealType;
	}

	public void setDealType(String dealType) {
		this.dealType = dealType;
	}
	
	@ExcelField(title="数量", align=2, sort=3)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@Length(min=0, max=50, message="摘要长度必须介于 0 和 50 之间")
	@ExcelField(title="摘要", align=2, sort=4)
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	@ExcelField(title="仓库", align=2, sort=5, fieldType=WmsWarehouse.class, value="warehouse.name")
	public WmsWarehouse getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(WmsWarehouse warehouse) {
		this.warehouse = warehouse;
	}
	
	@Length(min=0, max=50, message="唯一码长度必须介于 0 和 50 之间")
	public String getUniqueCode() {
		return uniqueCode;
	}

	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
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
		
}