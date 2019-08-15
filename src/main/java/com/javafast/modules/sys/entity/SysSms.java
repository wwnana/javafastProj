package com.javafast.modules.sys.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 系统短信Entity
 */
public class SysSms extends DataEntity<SysSms> {
	
	private static final long serialVersionUID = 1L;
	private String smsType;		//短信类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 (含密码重置)， 4：密码重置成功通知，    6:验证码登陆验证码，   14:OA审批提醒，20：CRM客户指派提醒
	private String content;		// 短信内容
	private String mobile;		// 手机号码
	private String code;       //验证码
	private String ip;		// 客户端IP
	private String status;		// 成功状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public SysSms() {
		super();
	}

	public SysSms(String id){
		super(id);
	}

	@Length(min=0, max=5, message="短信类型长度必须介于 0 和 5 之间")
	@ExcelField(title="短信类型", dictType="sms_type", align=2, sort=1)
	public String getSmsType() {
		return smsType;
	}

	public void setSmsType(String smsType) {
		this.smsType = smsType;
	}
	
	@Length(min=0, max=100, message="短信内容长度必须介于 0 和 100 之间")
	@ExcelField(title="短信内容", align=2, sort=2)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=11, message="手机号码长度必须介于 0 和 11 之间")
	@ExcelField(title="手机号码", align=2, sort=3)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=20, message="客户端IP长度必须介于 0 和 20 之间")
	@ExcelField(title="客户端IP", align=2, sort=4)
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}
	
	@Length(min=0, max=1, message="成功状态长度必须介于 0 和 1 之间")
	@ExcelField(title="成功状态", dictType="yes_no", align=2, sort=5)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
		
}