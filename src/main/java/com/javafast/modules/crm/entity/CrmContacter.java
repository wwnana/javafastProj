package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;

/**
 * 联系人Entity
 */
public class CrmContacter extends DataEntity<CrmContacter> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomer customer;		// 所属客户
	private String name;		// 姓名
	private String sex;		// 性别
	private Date birthday;		// 生日
	private String roleType;    //角色
	private String jobType;		// 职务
	private String mobile;		// 手机
	private String tel;		// 电话
	private String email;		// 邮箱
	private String wx;		// 微信
	private String qq;		// QQ
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private User ownBy;		// 负责人
	
	private String isDefault; //是否首要联系人
	
	public CrmContacter() {
		super();
	}

	public CrmContacter(String id){
		super(id);
	}

	@ExcelField(title="所属客户", align=2, sort=1, fieldType=CrmCustomer.class, value="customer.name")
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=30, message="姓名长度必须介于 0 和 30 之间")
	@ExcelField(title="姓名", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=2, message="性别长度必须介于 0 和 2 之间")
	@ExcelField(title="性别", dictType="sex", align=2, sort=3)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="生日", align=2, sort=4)
	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
	
	@Length(min=0, max=20, message="职务长度必须介于 0 和 20 之间")
	@ExcelField(title="职务", align=2, sort=5)
	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}
	
	@Length(min=0, max=20, message="手机长度必须介于 0 和 20 之间")
	@ExcelField(title="手机", align=2, sort=6)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=20, message="电话长度必须介于 0 和 20 之间")
	@ExcelField(title="电话", align=2, sort=7)
	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}
	
	@Length(min=0, max=50, message="邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱", align=2, sort=8)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=20, message="微信长度必须介于 0 和 20 之间")
	@ExcelField(title="微信", align=2, sort=9)
	public String getWx() {
		return wx;
	}

	public void setWx(String wx) {
		this.wx = wx;
	}
	
	@Length(min=0, max=20, message="QQ长度必须介于 0 和 20 之间")
	@ExcelField(title="QQ", align=2, sort=10)
	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
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

	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}

	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}

	@Length(min = 0, max = 1, message = "角色长度必须介于 0 和 1 之间")
	@ExcelField(title = "角色", dictType = "role_type", align = 2, sort = 3, type=1)
	public String getRoleType() {
		return roleType;
	}

	public void setRoleType(String roleType) {
		this.roleType = roleType;
	}
		
}