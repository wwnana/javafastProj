package com.javafast.modules.test.entity.validation;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 校验测试表单Entity
 * @author javafast
 * @version 2018-07-18
 */
public class TestValidation extends DataEntity<TestValidation> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 非空
	private String num;		// 金额
	private Integer num2;		// 整数
	private Date newDate;		// 日期
	private Date date2;		// 时间
	private String mobile;		// 手机号码
	private String email;		// 邮箱
	private String url;		// 网址
	
	public TestValidation() {
		super();
	}

	public TestValidation(String id){
		super(id);
	}

	@Length(min=0, max=50, message="非空长度必须介于 0 和 50 之间")
	@ExcelField(title="非空", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="金额", align=2, sort=2)
	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}
	
	@ExcelField(title="整数", align=2, sort=3)
	public Integer getNum2() {
		return num2;
	}

	public void setNum2(Integer num2) {
		this.num2 = num2;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="日期", align=2, sort=4)
	public Date getNewDate() {
		return newDate;
	}

	public void setNewDate(Date newDate) {
		this.newDate = newDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="时间", align=2, sort=5)
	public Date getDate2() {
		return date2;
	}

	public void setDate2(Date date2) {
		this.date2 = date2;
	}
	
	@Length(min=0, max=11, message="手机号码长度必须介于 0 和 11 之间")
	@ExcelField(title="手机号码", align=2, sort=6)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=50, message="邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱", align=2, sort=7)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=64, message="网址长度必须介于 0 和 64 之间")
	@ExcelField(title="网址", align=2, sort=8)
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
}