package com.javafast.modules.sys.entity;


import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 系统配置Entity
 * @author javafast
 * @version 2018-05-24
 */
public class SysConfig extends DataEntity<SysConfig> {
	
	private static final long serialVersionUID = 1L;
	private String mailSmtp;		// 邮箱服务器地址
	private String mailPort;		// 邮箱服务器端口
	private String mailName;		// 系统邮箱地址
	private String mailPassword;		// 系统邮箱密码
	private String smsName;		// 短信用户名
	private String smsPassword;		// 短信密码
	private String accountId;		// 企业编号
	private int wxAgentid;       //企业微信应用ID
	private String wxCorpid;		// 企业微信企业ID
	private String wxCorpsecret;		// 企业微信管理组的凭证密钥
	private String wxAccessToken;		// 企业微信获取到的凭证
	private Integer wxExpiresIn;		// 企业微信凭证的有效时间（秒）
	private String wxStatus;          //企业微信生效状态，0未生效，1生效
	private Date wxTokenDate;         //企业微信token更新时间
	
	private String checkinSecret;//打卡应用的Secret
	private String approvalSecret;//审批应用的Secret
	
	
	
	public SysConfig() {
		super();
	}

	public SysConfig(String id){
		super(id);
	}

	@Length(min=0, max=50, message="邮箱服务器地址长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱服务器地址", align=2, sort=1)
	public String getMailSmtp() {
		return mailSmtp;
	}

	public void setMailSmtp(String mailSmtp) {
		this.mailSmtp = mailSmtp;
	}
	
	@Length(min=0, max=50, message="邮箱服务器端口长度必须介于 0 和 50 之间")
	@ExcelField(title="邮箱服务器端口", align=2, sort=2)
	public String getMailPort() {
		return mailPort;
	}

	public void setMailPort(String mailPort) {
		this.mailPort = mailPort;
	}
	
	@Length(min=0, max=50, message="系统邮箱地址长度必须介于 0 和 50 之间")
	@ExcelField(title="系统邮箱地址", align=2, sort=3)
	public String getMailName() {
		return mailName;
	}

	public void setMailName(String mailName) {
		this.mailName = mailName;
	}
	
	@Length(min=0, max=50, message="系统邮箱密码长度必须介于 0 和 50 之间")
	@ExcelField(title="系统邮箱密码", align=2, sort=4)
	public String getMailPassword() {
		return mailPassword;
	}

	public void setMailPassword(String mailPassword) {
		this.mailPassword = mailPassword;
	}
	
	@Length(min=0, max=50, message="短信用户名长度必须介于 0 和 50 之间")
	@ExcelField(title="短信用户名", align=2, sort=5)
	public String getSmsName() {
		return smsName;
	}

	public void setSmsName(String smsName) {
		this.smsName = smsName;
	}
	
	@Length(min=0, max=50, message="短信密码长度必须介于 0 和 50 之间")
	@ExcelField(title="短信密码", align=2, sort=6)
	public String getSmsPassword() {
		return smsPassword;
	}

	public void setSmsPassword(String smsPassword) {
		this.smsPassword = smsPassword;
	}
	
	@Length(min=0, max=30, message="企业编号长度必须介于 0 和 30 之间")
	@ExcelField(title="企业编号", align=2, sort=7)
	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	
	@Length(min=0, max=50, message="企业微信企业ID长度必须介于 0 和 50 之间")
	@ExcelField(title="企业微信企业ID", align=2, sort=8)
	public String getWxCorpid() {
		return wxCorpid;
	}

	public void setWxCorpid(String wxCorpid) {
		this.wxCorpid = wxCorpid;
	}
	
	@Length(min=0, max=50, message="企业微信管理组的凭证密钥长度必须介于 0 和 50 之间")
	@ExcelField(title="企业微信管理组的凭证密钥", align=2, sort=9)
	public String getWxCorpsecret() {
		return wxCorpsecret;
	}

	public void setWxCorpsecret(String wxCorpsecret) {
		this.wxCorpsecret = wxCorpsecret;
	}
	
	@Length(min=0, max=512, message="企业微信获取到的凭证长度必须介于 0 和 512 之间")
	@ExcelField(title="企业微信获取到的凭证", align=2, sort=10)
	public String getWxAccessToken() {
		return wxAccessToken;
	}

	public void setWxAccessToken(String wxAccessToken) {
		this.wxAccessToken = wxAccessToken;
	}
	
	@ExcelField(title="企业微信凭证的有效时间（秒）", align=2, sort=11)
	public Integer getWxExpiresIn() {
		return wxExpiresIn;
	}

	public void setWxExpiresIn(Integer wxExpiresIn) {
		this.wxExpiresIn = wxExpiresIn;
	}

	public String getWxStatus() {
		return wxStatus;
	}

	public void setWxStatus(String wxStatus) {
		this.wxStatus = wxStatus;
	}

	public Date getWxTokenDate() {
		return wxTokenDate;
	}

	public void setWxTokenDate(Date wxTokenDate) {
		this.wxTokenDate = wxTokenDate;
	}

	public int getWxAgentid() {
		return wxAgentid;
	}

	public void setWxAgentid(int wxAgentid) {
		this.wxAgentid = wxAgentid;
	}

	public String getCheckinSecret() {
		return checkinSecret;
	}

	public void setCheckinSecret(String checkinSecret) {
		this.checkinSecret = checkinSecret;
	}

	public String getApprovalSecret() {
		return approvalSecret;
	}

	public void setApprovalSecret(String approvalSecret) {
		this.approvalSecret = approvalSecret;
	}

	
	
}