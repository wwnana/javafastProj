/**
 * Copyright 2015-2020
 */
package com.javafast.modules.test.entity.grid;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 业务数据Entity
 * @author javafast
 * @version 2017-07-21
 */
public class TestData extends DataEntity<TestData> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 姓名
	private String sex;		// 性别
	private Integer age;		// 年龄
	private String mobile;		// 手机号码
	private String email;		// 电子邮箱
	private String address;		// 联系地址
	private String createName;		// 创建者
	private String updateName;		// 更新者
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public TestData() {
		super();
	}

	public TestData(String id){
		super(id);
	}

	@Length(min=1, max=30, message="姓名长度必须介于 1 和 30 之间")
	@ExcelField(title="姓名", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=1, message="性别长度必须介于 1 和 1 之间")
	@ExcelField(title="性别", dictType="sex", align=2, sort=2)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@NotNull(message="年龄不能为空")
	@ExcelField(title="年龄", align=2, sort=3)
	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}
	
	@Length(min=1, max=11, message="手机号码长度必须介于 1 和 11 之间")
	@ExcelField(title="手机号码", align=2, sort=4)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=50, message="电子邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="电子邮箱", align=2, sort=5)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=50, message="联系地址长度必须介于 0 和 50 之间")
	@ExcelField(title="联系地址", align=2, sort=6)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=30, message="创建者长度必须介于 0 和 30 之间")
	@ExcelField(title="创建者", align=2, sort=8)
	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}
	
	@Length(min=0, max=30, message="更新者长度必须介于 0 和 30 之间")
	@ExcelField(title="更新者", align=2, sort=11)
	public String getUpdateName() {
		return updateName;
	}

	public void setUpdateName(String updateName) {
		this.updateName = updateName;
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