package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户Entity
 */
public class CrmCustomer extends DataEntity<CrmCustomer> {

	private static final long serialVersionUID = 1L;
	private String name; // 客户名称
	private String customerType; // 客户分类
	private String customerStatus; // 客户状态 0潜在、1：开发中，2：成交、3：失效
	private String customerLevel; // 客户级别
	private String contacterName; // 首要联系人
	private String mobile; // 联系手机
	private Date nextcontactDate; // 下次联系时间
	private String nextcontactNote; // 下次联系内容
	private User ownBy; // 负责人
	private String tags;// 客户标签
	private String isStar; // 是否关注,1:关注，0：默认不关注

	// 客户详情
	private String industryType; // 客户行业
	private String sourType; // 客户来源
	private String natureType; // 公司性质
	private String scaleType; // 企业规模
	private Integer coin; // 积分
	private String phone; // 客户电话
	private String fax; // 传真
	private String province; // 省
	private String city; // 市
	private String dict; // 区
	private String address; // 地址
	private String bankaccountname; // 开户行
	private String bankaccountno; // 开户账号

	// 首要联系人
	private CrmContacter crmContacter;
	private String crmClueId; // 来源销售线索

	private String isPool; // 是否公海,1:是，0：默认否

	private BigDecimal totalChanceAmt; // 商机总额
	private BigDecimal totalOrderAmt; // 订单总额
	private BigDecimal totalReceiveAmt; // 回款总额
	private BigDecimal totalRefundAmt; // 退款总额

	// 查询条件
	private Date beginNextcontactDate; // 开始 下次联系时间
	private Date endNextcontactDate; // 结束 下次联系时间
	private Date beginCreateDate; // 开始 创建时间
	private Date endCreateDate; // 结束 创建时间
	private Date beginUpdateDate; // 开始 更新时间
	private Date endUpdateDate; // 结束 更新时间

	public CrmCustomer() {
		super();
	}

	public CrmCustomer(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "客户名称长度必须介于 1 和 50 之间")
	@ExcelField(title = "客户名称", align = 2, sort = 1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Length(min = 0, max = 1, message = "客户分类长度必须介于 0 和 1 之间")
	@ExcelField(title = "客户分类", dictType = "customer_type", align = 2, sort = 3, type = 1)
	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	@Length(min = 0, max = 1, message = "客户状态长度必须介于 0 和 1 之间")
	@ExcelField(title = "客户状态", dictType = "customer_status", align = 2, sort = 3, type=1)
	public String getCustomerStatus() {
		return customerStatus;
	}

	public void setCustomerStatus(String customerStatus) {
		this.customerStatus = customerStatus;
	}

	@Length(min = 0, max = 1, message = "客户级别长度必须介于 0 和 1 之间")
	@ExcelField(title = "客户级别", dictType = "customer_level", align = 2, sort = 4, type=1)
	public String getCustomerLevel() {
		return customerLevel;
	}

	public void setCustomerLevel(String customerLevel) {
		this.customerLevel = customerLevel;
	}

	@Length(min = 0, max = 30, message = "首要联系人长度必须介于 0 和 30 之间")
	@ExcelField(title = "首要联系人", align = 2, sort = 5)
	public String getContacterName() {
		return contacterName;
	}

	public void setContacterName(String contacterName) {
		this.contacterName = contacterName;
	}

	@Length(min = 0, max = 20, message = "首要联系人手机长度必须介于 0 和 20 之间")
	@ExcelField(title = "首要联系人手机", align = 2, sort = 6)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title = "下次联系时间", align = 2, sort = 7, type = 1)
	public Date getNextcontactDate() {
		return nextcontactDate;
	}

	public void setNextcontactDate(Date nextcontactDate) {
		this.nextcontactDate = nextcontactDate;
	}

	@Length(min = 0, max = 50, message = "下次联系内容长度必须介于 0 和 50 之间")
	@ExcelField(title = "下次联系内容", align = 2, sort = 8, type = 1)
	public String getNextcontactNote() {
		return nextcontactNote;
	}

	public void setNextcontactNote(String nextcontactNote) {
		this.nextcontactNote = nextcontactNote;
	}

	@ExcelField(title = "负责人", fieldType = User.class, value = "ownBy.name", align = 2, sort = 100, type = 1)
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

	public String getIsStar() {
		return isStar;
	}

	public void setIsStar(String isStar) {
		this.isStar = isStar;
	}

	@Length(min = 0, max = 50, message = "客户标签长度必须介于 0 和 50 之间")
	@ExcelField(title = "客户标签", align = 2, sort = 10, type = 1)
	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	@Length(min = 0, max = 2, message = "客户行业长度必须介于 0 和 2 之间")
	@ExcelField(title = "客户行业", dictType = "industry_type", align = 2, sort = 11, type = 1)
	public String getIndustryType() {
		return industryType;
	}

	public void setIndustryType(String industryType) {
		this.industryType = industryType;
	}

	@Length(min = 0, max = 2, message = "客户来源长度必须介于 0 和 2 之间")
	@ExcelField(title = "客户来源", dictType = "sour_type", align = 2, sort = 12, type = 1)
	public String getSourType() {
		return sourType;
	}

	public void setSourType(String sourType) {
		this.sourType = sourType;
	}

	@Length(min = 0, max = 2, message = "公司性质长度必须介于 0 和 2 之间")
	@ExcelField(title = "公司性质", dictType = "nature_type", align = 2, sort = 13, type = 1)
	public String getNatureType() {
		return natureType;
	}

	public void setNatureType(String natureType) {
		this.natureType = natureType;
	}

	@Length(min = 0, max = 20, message = "企业规模长度必须介于 0 和 20 之间")
	@ExcelField(title = "企业规模", dictType = "scale_type", align = 2, sort = 14, type = 1)
	public String getScaleType() {
		return scaleType;
	}

	public void setScaleType(String scaleType) {
		this.scaleType = scaleType;
	}

	public Integer getCoin() {
		return coin;
	}

	public void setCoin(Integer coin) {
		this.coin = coin;
	}

	@Length(min = 0, max = 20, message = "客户电话长度必须介于 0 和 20 之间")
	@ExcelField(title = "客户电话", align = 2, sort = 16)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	@Length(min = 0, max = 20, message = "传真长度必须介于 0 和 20 之间")
	@ExcelField(title = "传真", align = 2, sort = 17, type = 1)
	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	@Length(min = 0, max = 20, message = "省长度必须介于 0 和 20 之间")
	@ExcelField(title = "省", align = 2, sort = 18, type = 1)
	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	@Length(min = 0, max = 20, message = "市长度必须介于 0 和 20 之间")
	@ExcelField(title = "市", align = 2, sort = 19, type = 1)
	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	@Length(min = 0, max = 20, message = "区长度必须介于 0 和 20 之间")
	@ExcelField(title = "区", align = 2, sort = 20, type = 1)
	public String getDict() {
		return dict;
	}

	public void setDict(String dict) {
		this.dict = dict;
	}

	@Length(min = 0, max = 50, message = "地址长度必须介于 0 和 50 之间")
	@ExcelField(title = "地址", align = 2, sort = 21)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@Length(min = 0, max = 50, message = "开户行长度必须介于 0 和50 之间")
	public String getBankaccountname() {
		return bankaccountname;
	}

	public void setBankaccountname(String bankaccountname) {
		this.bankaccountname = bankaccountname;
	}

	@Length(min = 0, max = 50, message = "开户账号长度必须介于 0 和50 之间")
	public String getBankaccountno() {
		return bankaccountno;
	}

	public void setBankaccountno(String bankaccountno) {
		this.bankaccountno = bankaccountno;
	}

	public CrmContacter getCrmContacter() {
		return crmContacter;
	}

	public void setCrmContacter(CrmContacter crmContacter) {
		this.crmContacter = crmContacter;
	}

	public String getIsPool() {
		return isPool;
	}

	public void setIsPool(String isPool) {
		this.isPool = isPool;
	}

	public String getCrmClueId() {
		return crmClueId;
	}

	public void setCrmClueId(String crmClueId) {
		this.crmClueId = crmClueId;
	}

	public BigDecimal getTotalChanceAmt() {
		return totalChanceAmt;
	}

	public void setTotalChanceAmt(BigDecimal totalChanceAmt) {
		this.totalChanceAmt = totalChanceAmt;
	}

	public BigDecimal getTotalOrderAmt() {
		return totalOrderAmt;
	}

	public void setTotalOrderAmt(BigDecimal totalOrderAmt) {
		this.totalOrderAmt = totalOrderAmt;
	}

	public BigDecimal getTotalReceiveAmt() {
		return totalReceiveAmt;
	}

	public void setTotalReceiveAmt(BigDecimal totalReceiveAmt) {
		this.totalReceiveAmt = totalReceiveAmt;
	}

	public BigDecimal getTotalRefundAmt() {
		return totalRefundAmt;
	}

	public void setTotalRefundAmt(BigDecimal totalRefundAmt) {
		this.totalRefundAmt = totalRefundAmt;
	}

	public Date getBeginUpdateDate() {
		return beginUpdateDate;
	}

	public void setBeginUpdateDate(Date beginUpdateDate) {
		this.beginUpdateDate = beginUpdateDate;
	}

	public Date getEndUpdateDate() {
		return endUpdateDate;
	}

	public void setEndUpdateDate(Date endUpdateDate) {
		this.endUpdateDate = endUpdateDate;
	}
}