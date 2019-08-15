/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.entity.ui;

import org.hibernate.validator.constraints.Length;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.test.entity.one.TestOne;
import com.javafast.modules.test.entity.tree.TestTree;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * UI标签Entity
 * @author javafast
 * @version 2017-08-22
 */
public class TestUielement extends DataEntity<TestUielement> {
	
	private static final long serialVersionUID = 1L;
	private TestOne product;		// 列表选择器
	private TestTree productType;		// 树形选择器
	private String sex;		// 数据字典radio
	private String sex2;		// 数据字典select
	private String tags;		// 多选下拉标签
	private String tags2;		// 数据字典checkbox
	private User user;		// 人员选择
	private Office office;		// 部门选择
	private String image;		// 单图片上传
	private String image2;		// 多图片上传
	private String file;		// 单文件上传
	private String file2;		// 多文件上传
	private String content;		// 富文本编辑器
	
	public TestUielement() {
		super();
	}

	public TestUielement(String id){
		super(id);
	}

	@ExcelField(title="列表选择器", align=2, sort=1)
	public TestOne getProduct() {
		return product;
	}

	public void setProduct(TestOne product) {
		this.product = product;
	}
	
	@ExcelField(title="树形选择器", align=2, sort=2)
	public TestTree getProductType() {
		return productType;
	}

	public void setProductType(TestTree productType) {
		this.productType = productType;
	}
	
	@Length(min=0, max=1, message="数据字典radio长度必须介于 0 和 1 之间")
	@ExcelField(title="数据字典radio", dictType="sex", align=2, sort=3)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@Length(min=0, max=50, message="数据字典select长度必须介于 0 和 50 之间")
	@ExcelField(title="数据字典select", dictType="sex", align=2, sort=4)
	public String getSex2() {
		return sex2;
	}

	public void setSex2(String sex2) {
		this.sex2 = sex2;
	}
	
	@Length(min=0, max=50, message="多选下拉标签长度必须介于 0 和 50 之间")
	@ExcelField(title="多选下拉标签", dictType="color", align=2, sort=5)
	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}
	
	@Length(min=0, max=50, message="数据字典checkbox长度必须介于 0 和 50 之间")
	@ExcelField(title="数据字典checkbox", dictType="color", align=2, sort=6)
	public String getTags2() {
		return tags2;
	}

	public void setTags2(String tags2) {
		this.tags2 = tags2;
	}
	
	@ExcelField(title="人员选择", fieldType=User.class, value="user.name", align=2, sort=7)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="部门选择", fieldType=Office.class, value="office.name", align=2, sort=8)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=0, max=1000, message="单图片上传长度必须介于 0 和 1000 之间")
	@ExcelField(title="单图片上传", align=2, sort=9)
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}
	
	@Length(min=0, max=1000, message="多图片上传长度必须介于 0 和 1000 之间")
	@ExcelField(title="多图片上传", align=2, sort=10)
	public String getImage2() {
		return image2;
	}

	public void setImage2(String image2) {
		this.image2 = image2;
	}
	
	@Length(min=0, max=1000, message="单文件上传长度必须介于 0 和 1000 之间")
	@ExcelField(title="单文件上传", align=2, sort=11)
	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}
	
	@Length(min=0, max=1000, message="多文件上传长度必须介于 0 和 1000 之间")
	@ExcelField(title="多文件上传", align=2, sort=12)
	public String getFile2() {
		return file2;
	}

	public void setFile2(String file2) {
		this.file2 = file2;
	}
	
	@Length(min=0, max=10000, message="富文本编辑器长度必须介于 0 和 10000 之间")
	@ExcelField(title="富文本编辑器", align=2, sort=13)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}