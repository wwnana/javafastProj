package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 销售线索Entity
 * @author javafast
 * @version 2019-02-15
 */
public class CrmClue extends DataEntity<CrmClue> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 公司
	private String contacterName;		// 联系人姓名
	private String sex;		// 性别
	private String mobile;		// 联系手机
	private String email;		// 邮箱
	private String jobType;		// 职务
	private String sourType;		// 线索来源
	private String industryType;		// 所属行业
	private String natureType;		// 企业性质
	private String scaleType;		// 企业规模
	private String province;		// 省
	private String city;		// 市
	private String dict;		// 区
	private String address;		// 详细地址
	private Date nextcontactDate;		// 下次联系时间
	private String nextcontactNote;		// 下次联系内容
	private String isPool;		// 是否为公海
	private User ownBy;		// 所有者
	private Date beginNextcontactDate;		// 开始 下次联系时间
	private Date endNextcontactDate;		// 结束 下次联系时间
	
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private String field1;         //备用字段1 是否转化，转化为客户后，关联客户ID
	private String field2;         //备用字段2 是否开通企业版，开通后，关联企业userId
	
	private CrmCustomer crmCustomer;//转化为客户
	private String isChange; //是否已经转化
	
	private CrmMarket crmMarket;//市场活动
	
	public CrmClue() {
		super();
	}

	public CrmClue(String id){
		super(id);
	}

	@Length(min=1, max=50, message="公司长度必须介于 1 和 50 之间")
	@ExcelField(title="公司", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=30, message="联系人姓名长度必须介于 0 和 30 之间")
	@ExcelField(title="联系人姓名", align=2, sort=2)
	public String getContacterName() {
		return contacterName;
	}

	public void setContacterName(String contacterName) {
		this.contacterName = contacterName;
	}
	
	@Length(min=0, max=1, message="性别长度必须介于 0 和 1 之间")
	@ExcelField(title="性别", dictType="sex", align=2, sort=3, type=1)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@Length(min=0, max=20, message="联系手机长度必须介于 0 和 20 之间")
	@ExcelField(title="联系手机", align=2, sort=4)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=50, message="邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱", align=2, sort=5)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=20, message="职务长度必须介于 0 和 20 之间")
	@ExcelField(title="职务", align=2, sort=6)
	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}
	
	@Length(min=0, max=3, message="线索来源长度必须介于 0 和 3 之间")
	@ExcelField(title="线索来源", dictType="sour_type", align=2, sort=7, type=1)
	public String getSourType() {
		return sourType;
	}

	public void setSourType(String sourType) {
		this.sourType = sourType;
	}
	
	@Length(min=0, max=3, message="所属行业长度必须介于 0 和 3 之间")
	@ExcelField(title="所属行业", dictType="industry_type", align=2, sort=8, type=1)
	public String getIndustryType() {
		return industryType;
	}

	public void setIndustryType(String industryType) {
		this.industryType = industryType;
	}
	
	@Length(min=0, max=3, message="企业性质长度必须介于 0 和 3 之间")
	@ExcelField(title="企业性质", dictType="nature_type", align=2, sort=9, type=1)
	public String getNatureType() {
		return natureType;
	}

	public void setNatureType(String natureType) {
		this.natureType = natureType;
	}
	
	@Length(min=0, max=3, message="企业规模长度必须介于 0 和 3 之间")
	@ExcelField(title="企业规模", dictType="scale_type", align=2, sort=10, type=1)
	public String getScaleType() {
		return scaleType;
	}

	public void setScaleType(String scaleType) {
		this.scaleType = scaleType;
	}
	
	@Length(min=0, max=30, message="省长度必须介于 0 和 30 之间")
	@ExcelField(title="省", dictType="", align=2, sort=11, type=1)
	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}
	
	@Length(min=0, max=30, message="市长度必须介于 0 和 30 之间")
	@ExcelField(title="市", dictType="", align=2, sort=12, type=1)
	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}
	
	@Length(min=0, max=30, message="区长度必须介于 0 和 30 之间")
	@ExcelField(title="区", dictType="", align=2, sort=13, type=1)
	public String getDict() {
		return dict;
	}

	public void setDict(String dict) {
		this.dict = dict;
	}
	
	@Length(min=0, max=50, message="详细地址长度必须介于 0 和 50 之间")
	@ExcelField(title="详细地址", align=2, sort=14)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="下次联系时间", align=2, sort=16, type=1)
	public Date getNextcontactDate() {
		return nextcontactDate;
	}

	public void setNextcontactDate(Date nextcontactDate) {
		this.nextcontactDate = nextcontactDate;
	}
	
	@Length(min=0, max=50, message="下次联系内容长度必须介于 0 和 50 之间")
	@ExcelField(title="下次联系内容", align=2, sort=17, type=1)
	public String getNextcontactNote() {
		return nextcontactNote;
	}

	public void setNextcontactNote(String nextcontactNote) {
		this.nextcontactNote = nextcontactNote;
	}
	
	@Length(min=0, max=1, message="是否为公海长度必须介于 0 和 1 之间")
	@ExcelField(title="是否为公海", dictType="yes_no", align=2, sort=18, type=1)
	public String getIsPool() {
		return isPool;
	}

	public void setIsPool(String isPool) {
		this.isPool = isPool;
	}
	
	@ExcelField(title="所有者", fieldType=User.class, value="ownBy.name", align=2, sort=19, type=1)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	public Date getBeginNextcontactDate() {
		return beginNextcontactDate;
	}

	public void setBeginNextcontactDate(Date beginNextcontactDate) {
		this.beginNextcontactDate = beginNextcontactDate;
	}
	
	public Date getEndNextcontactDate() {
		return endNextcontactDate;
	}

	public void setEndNextcontactDate(Date endNextcontactDate) {
		this.endNextcontactDate = endNextcontactDate;
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

	public CrmCustomer getCrmCustomer() {
		return crmCustomer;
	}

	public void setCrmCustomer(CrmCustomer crmCustomer) {
		this.crmCustomer = crmCustomer;
	}

	public String getIsChange() {
		return isChange;
	}

	public void setIsChange(String isChange) {
		this.isChange = isChange;
	}

	public String getField1() {
		return field1;
	}

	public void setField1(String field1) {
		this.field1 = field1;
	}

	public String getField2() {
		return field2;
	}

	public void setField2(String field2) {
		this.field2 = field2;
	}

	public CrmMarket getCrmMarket() {
		return crmMarket;
	}

	public void setCrmMarket(CrmMarket crmMarket) {
		this.crmMarket = crmMarket;
	}
		
}