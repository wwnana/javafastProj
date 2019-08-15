/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 产品Entity
 * @author javafast
 * @version 2017-07-04
 */
public class WmsProduct extends DataEntity<WmsProduct> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 产品编号
	private String name;		// 产品名称
	private String code;		// 产品条码
	private WmsProductType productType;		// 产品分类
	private String unitType;		// 基本单位
	private String spec;		// 规格
	private String color;		// 颜色
	private String size;		// 尺寸
	private String customField1;		// 自定义属性1
	private String customField2;		// 自定义属性2
	private String productImg;		// 产品图片
	private BigDecimal salePrice;		// 标准价格
	private BigDecimal batchPrice;		// 批发价
	private BigDecimal minPrice;		// 最低售价
	private BigDecimal costPrice;		// 参考成本价
	private Integer minStock;		// 最低库存量
	private Integer maxStock;		// 最高库存量
	private String status;		// 状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	private Integer initStock;//初期库存
	private WmsWarehouse initWarehouse;		// 初期仓库
	
	private WmsProductData wmsProductData;
	
	public WmsProduct() {
		super();
	}

	public WmsProduct(String id){
		super(id);
	}

	@Length(min=1, max=30, message="产品编号长度必须介于 1 和 30 之间")
	@ExcelField(title="产品编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="产品名称长度必须介于 1 和 50 之间")
	@ExcelField(title="产品名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="产品条码长度必须介于 0 和 50 之间")
	@ExcelField(title="产品条码", align=2, sort=3)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
	@ExcelField(title="产品分类", align=2, sort=4, fieldType=WmsProductType.class, value="productType.name", type=1)
	public WmsProductType getProductType() {
		return productType;
	}

	public void setProductType(WmsProductType productType) {
		this.productType = productType;
	}
	
	@Length(min=0, max=2, message="基本单位长度必须介于 0 和 2 之间")
	@ExcelField(title="基本单位", dictType="unit_type", align=2, sort=5, type=1)
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	
	@Length(min=0, max=30, message="规格长度必须介于 0 和 30 之间")
	@ExcelField(title="规格", align=2, sort=6)
	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}
	
	@Length(min=0, max=30, message="颜色长度必须介于 0 和 30 之间")
	@ExcelField(title="颜色", align=2, sort=7)
	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
	@Length(min=0, max=30, message="尺寸长度必须介于 0 和 30 之间")
	@ExcelField(title="尺寸", align=2, sort=8)
	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}
	
	@Length(min=0, max=30, message="自定义属性1长度必须介于 0 和 30 之间")
	@ExcelField(title="自定义属性1", align=2, sort=9)
	public String getCustomField1() {
		return customField1;
	}

	public void setCustomField1(String customField1) {
		this.customField1 = customField1;
	}
	
	@Length(min=0, max=30, message="自定义属性2长度必须介于 0 和 30 之间")
	@ExcelField(title="自定义属性2", align=2, sort=10)
	public String getCustomField2() {
		return customField2;
	}

	public void setCustomField2(String customField2) {
		this.customField2 = customField2;
	}
	
	@Length(min=0, max=200, message="产品图片长度必须介于 0 和 200 之间")
	@ExcelField(title="产品图片", align=2, sort=11, type=1)
	public String getProductImg() {
		return productImg;
	}

	public void setProductImg(String productImg) {
		this.productImg = productImg;
	}
	
	@ExcelField(title="标准价格", align=2, sort=12)
	public BigDecimal getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(BigDecimal salePrice) {
		this.salePrice = salePrice;
	}
	
	@ExcelField(title="批发价", align=2, sort=13)
	public BigDecimal getBatchPrice() {
		return batchPrice;
	}

	public void setBatchPrice(BigDecimal batchPrice) {
		this.batchPrice = batchPrice;
	}
	
	@ExcelField(title="最低售价", align=2, sort=14)
	public BigDecimal getMinPrice() {
		return minPrice;
	}

	public void setMinPrice(BigDecimal minPrice) {
		this.minPrice = minPrice;
	}
	
	@ExcelField(title="参考成本价", align=2, sort=15)
	public BigDecimal getCostPrice() {
		return costPrice;
	}

	public void setCostPrice(BigDecimal costPrice) {
		this.costPrice = costPrice;
	}
	
	@ExcelField(title="最低库存量", align=2, sort=16)
	public Integer getMinStock() {
		return minStock;
	}

	public void setMinStock(Integer minStock) {
		this.minStock = minStock;
	}
	
	@ExcelField(title="最高库存量", align=2, sort=17)
	public Integer getMaxStock() {
		return maxStock;
	}

	public void setMaxStock(Integer maxStock) {
		this.maxStock = maxStock;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=18, type=1)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public WmsProductData getWmsProductData() {
		return wmsProductData;
	}

	public void setWmsProductData(WmsProductData wmsProductData) {
		this.wmsProductData = wmsProductData;
	}

	public Integer getInitStock() {
		return initStock;
	}

	public void setInitStock(Integer initStock) {
		this.initStock = initStock;
	}

	public WmsWarehouse getInitWarehouse() {
		return initWarehouse;
	}

	public void setInitWarehouse(WmsWarehouse initWarehouse) {
		this.initWarehouse = initWarehouse;
	}
		
}