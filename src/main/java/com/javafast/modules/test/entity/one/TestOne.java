package com.javafast.modules.test.entity.one;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.test.entity.tree.TestTree;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 商品信息(单表)Entity
 * @author javafast
 * @version 2018-07-30
 */
public class TestOne extends DataEntity<TestOne> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 商品编码
	private String name;		// 商品名称
	private TestTree testTree;		// 商品分类
	private String unitType;		// 基本单位
	private String spec;		// 规格
	private String color;		// 颜色
	private String size;		// 尺寸
	private String productImg;		// 商品图片
	private BigDecimal salePrice;		// 标准价格
	private BigDecimal batchPrice;		// 批发价
	private String content;		// 商品描述
	private String status;		// 状态
	
	public TestOne() {
		super();
	}

	public TestOne(String id){
		super(id);
	}

	@Length(min=1, max=30, message="商品编码长度必须介于 1 和 30 之间")
	@ExcelField(title="商品编码", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="商品名称长度必须介于 1 和 50 之间")
	@ExcelField(title="商品名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@NotNull(message="商品分类不能为空")
	@ExcelField(title="商品分类", align=2, sort=3)
	public TestTree getTestTree() {
		return testTree;
	}

	public void setTestTree(TestTree testTree) {
		this.testTree = testTree;
	}
	
	@Length(min=0, max=2, message="基本单位长度必须介于 0 和 2 之间")
	@ExcelField(title="基本单位", dictType="unit_type", align=2, sort=4)
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	
	@Length(min=0, max=30, message="规格长度必须介于 0 和 30 之间")
	@ExcelField(title="规格", align=2, sort=5)
	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}
	
	@Length(min=0, max=30, message="颜色长度必须介于 0 和 30 之间")
	@ExcelField(title="颜色", align=2, sort=6)
	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
	@Length(min=0, max=30, message="尺寸长度必须介于 0 和 30 之间")
	@ExcelField(title="尺寸", align=2, sort=7)
	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}
	
	@Length(min=0, max=500, message="商品图片长度必须介于 0 和 500 之间")
	public String getProductImg() {
		return productImg;
	}

	public void setProductImg(String productImg) {
		this.productImg = productImg;
	}
	
	@ExcelField(title="标准价格", align=2, sort=9)
	public BigDecimal getSalePrice() {
		return salePrice;
	}

	public void setSalePrice(BigDecimal salePrice) {
		this.salePrice = salePrice;
	}
	
	@ExcelField(title="批发价", align=2, sort=10)
	public BigDecimal getBatchPrice() {
		return batchPrice;
	}

	public void setBatchPrice(BigDecimal batchPrice) {
		this.batchPrice = batchPrice;
	}
	
	@Length(min=0, max=10000, message="商品描述长度必须介于 0 和 10000 之间")
	@ExcelField(title="商品描述", align=2, sort=11)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=12)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}