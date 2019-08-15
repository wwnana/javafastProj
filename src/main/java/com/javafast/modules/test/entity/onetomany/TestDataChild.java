/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.entity.onetomany;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.test.entity.one.TestOne;

/**
 * 订单信息Entity
 * @author javafast
 * @version 2017-07-16
 */
public class TestDataChild extends DataEntity<TestDataChild> {
	
	private static final long serialVersionUID = 1L;
	private TestDataMain order;		// 所属订单 父类
	private TestOne product;		// 商品
	private String unitType;		// 单位
	private BigDecimal price;		// 单价(元)
	private Integer num;		// 数量
	private BigDecimal amount;		// 金额(元)
	
	public TestDataChild() {
		super();
	}

	public TestDataChild(String id){
		super(id);
	}

	public TestDataChild(TestDataMain order){
		this.order = order;
	}

	public TestDataMain getOrder() {
		return order;
	}

	public void setOrder(TestDataMain order) {
		this.order = order;
	}
	
	@NotNull(message="商品不能为空")
	@ExcelField(title="商品", fieldType=TestOne.class, value="product.name", align=2, sort=2)
	public TestOne getProduct() {
		return product;
	}

	public void setProduct(TestOne product) {
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
	
	@NotNull(message="单价(元)不能为空")
	@ExcelField(title="单价(元)", align=2, sort=4)
	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	
	@NotNull(message="数量不能为空")
	@ExcelField(title="数量", align=2, sort=5)
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@NotNull(message="金额(元)不能为空")
	@ExcelField(title="金额(元)", align=2, sort=6)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
}