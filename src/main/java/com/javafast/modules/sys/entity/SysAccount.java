package com.javafast.modules.sys.entity;

import java.math.BigDecimal;
import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 企业帐户Entity
 */
public class SysAccount extends DataEntity<SysAccount> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 公司名称
	private String enname;		// 英文名
	private String mobile;		// 注册手机
	private String phone;		// 注册电话
	private String email;		// 注册邮箱
	private String fax;		//传真
	private String address;		//地址
	private String adminUserId;		// 管理员账号
	private Integer maxUserNum;		// 授权用户数
	private Integer nowUserNum;		// 当前用户数
	private String status;		// 可用状态 0正常，1冻结
	private String logo;    //LOGO
	private String neturl;  //网址
	private String bankaccountname; //开户行
	private String bankaccountno; //开户账号
	private String systemName;		// 系统名称
	private String apiSecret; //	Access Key Secret
	private String payStatus;		// 付费状态: 0未付费，1付费, 2 欠费
	private String smsStatus; //开通短信提醒功能 0 否，1是
	private BigDecimal balance;		// 帐户余额
	
	//企业微信相关信息
	private String permanentCode;//企业微信永久授权码,最长为512字节
	private String userid;//授权管理员的userid，可能为空（内部管理员一定有，不可更改）
	private String corpid;//企业微信id
	private String corpName;//企业微信名称
	private String corpType;//企业微信类型，认证号：verified, 注册号：unverified
	private String corpWxqrcode;//授权方企业微信二维码
	private String corpScale;//企业规模。当企业未设置该属性时，值为空
	private String corpIndustry;//企业所属行业。当企业未设置该属性时，值为空
	private Integer agentid;//授权方应用id
	
	private String crmRetrievePeriod;  //客户回收周期，客户X天未联系自动入公海
	private String crmContactRemindPeriod;   //客户联系提醒周期，客户X天未联系提醒
	
	//查询条件
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public SysAccount() {
		super();
	}

	public SysAccount(String id){
		super(id);
	}

	@Length(min=0, max=30, message="公司名称长度必须介于 0 和 30 之间")
	@ExcelField(title="公司名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=20, message="手机长度必须介于 0 和 20 之间")
	@ExcelField(title="手机", align=2, sort=2)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=20, message="电话长度必须介于 0 和 20 之间")
	@ExcelField(title="电话", align=2, sort=3)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	@Length(min=0, max=30, message="邮箱长度必须介于 0 和 30 之间")
	@ExcelField(title="邮箱", align=2, sort=4)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=64, message="管理员账号长度必须介于 0 和 64 之间")
	@ExcelField(title="管理员账号", align=2, sort=5)
	public String getAdminUserId() {
		return adminUserId;
	}

	public void setAdminUserId(String adminUserId) {
		this.adminUserId = adminUserId;
	}
	
	@ExcelField(title="授权用户数", align=2, sort=6)
	public Integer getMaxUserNum() {
		return maxUserNum;
	}

	public void setMaxUserNum(Integer maxUserNum) {
		this.maxUserNum = maxUserNum;
	}
	
	@ExcelField(title="当前用户数", align=2, sort=7)
	public Integer getNowUserNum() {
		return nowUserNum;
	}

	public void setNowUserNum(Integer nowUserNum) {
		this.nowUserNum = nowUserNum;
	}
	
	@Length(min=0, max=2, message="状态长度必须介于 0 和 2 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=8)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getApiSecret() {
		return apiSecret;
	}

	public void setApiSecret(String apiSecret) {
		this.apiSecret = apiSecret;
	}

	@Length(min=0, max=30, message="系统名称长度必须介于 0 和 30 之间")
	public String getSystemName() {
		return systemName;
	}

	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}

	@Length(min=0, max=30, message="传真长度必须介于 0 和 30 之间")
	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	@Length(min=0, max=50, message="地址长度必须介于 0 和50 之间")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getEnname() {
		return enname;
	}

	public void setEnname(String enname) {
		this.enname = enname;
	}

	@Length(min=0, max=200, message="logo长度必须介于 0 和200 之间")
	public String getLogo() {
		return logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}

	@Length(min=0, max=50, message="网址长度必须介于 0 和50 之间")
	public String getNeturl() {
		return neturl;
	}

	public void setNeturl(String neturl) {
		this.neturl = neturl;
	}

	@Length(min=0, max=50, message="开户行长度必须介于 0 和50 之间")
	public String getBankaccountname() {
		return bankaccountname;
	}

	public void setBankaccountname(String bankaccountname) {
		this.bankaccountname = bankaccountname;
	}

	@Length(min=0, max=50, message="开户账号长度必须介于 0 和50 之间")
	public String getBankaccountno() {
		return bankaccountno;
	}

	public void setBankaccountno(String bankaccountno) {
		this.bankaccountno = bankaccountno;
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

	public String getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	public String getSmsStatus() {
		return smsStatus;
	}

	public void setSmsStatus(String smsStatus) {
		this.smsStatus = smsStatus;
	}

	public BigDecimal getBalance() {
		return balance;
	}

	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}

	public String getPermanentCode() {
		return permanentCode;
	}

	public void setPermanentCode(String permanentCode) {
		this.permanentCode = permanentCode;
	}

	public String getCorpid() {
		return corpid;
	}

	public void setCorpid(String corpid) {
		this.corpid = corpid;
	}

	public String getCorpName() {
		return corpName;
	}

	public void setCorpName(String corpName) {
		this.corpName = corpName;
	}

	public String getCorpType() {
		return corpType;
	}

	public void setCorpType(String corpType) {
		this.corpType = corpType;
	}

	public String getCorpWxqrcode() {
		return corpWxqrcode;
	}

	public void setCorpWxqrcode(String corpWxqrcode) {
		this.corpWxqrcode = corpWxqrcode;
	}

	public String getCorpScale() {
		return corpScale;
	}

	public void setCorpScale(String corpScale) {
		this.corpScale = corpScale;
	}

	public String getCorpIndustry() {
		return corpIndustry;
	}

	public void setCorpIndustry(String corpIndustry) {
		this.corpIndustry = corpIndustry;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public Integer getAgentid() {
		return agentid;
	}

	public void setAgentid(Integer agentid) {
		this.agentid = agentid;
	}

	public String getCrmRetrievePeriod() {
		return crmRetrievePeriod;
	}

	public void setCrmRetrievePeriod(String crmRetrievePeriod) {
		this.crmRetrievePeriod = crmRetrievePeriod;
	}

	public String getCrmContactRemindPeriod() {
		return crmContactRemindPeriod;
	}

	public void setCrmContactRemindPeriod(String crmContactRemindPeriod) {
		this.crmContactRemindPeriod = crmContactRemindPeriod;
	}
}