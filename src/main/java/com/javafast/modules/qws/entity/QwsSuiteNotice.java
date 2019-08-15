package com.javafast.modules.qws.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 指令回调消息Entity
 * @author javafast
 * @version 2018-06-12
 */
public class QwsSuiteNotice extends DataEntity<QwsSuiteNotice> {
	
	private static final long serialVersionUID = 1L;
	private String requestUrl;		// 请求URL
	private String requestBody;		// 消息主体
	private String msgSignature;		// 消息签名
	private String timestamp;		// 时间戳
	private String nonce;		// 随机数
	private String echostr;		// 加密字符串
	private String suiteId;		// 第三方应用的SuiteId
	private String infoType;		// 消息类型
	private String suiteTicket;		// suite_ticket
	private String authCode;		// 临时授权码
	private String authCorpId;		// 授权方的corpid
	private String changeType;		// 通讯录变更类型
	private User user;		// 成员ID
	private String partyId;		// 部门ID
	private String status;		// 处理状态
	private Date beginCreateDate;		// 开始 接收时间
	private Date endCreateDate;		// 结束 接收时间
	
	public QwsSuiteNotice() {
		super();
	}

	public QwsSuiteNotice(String id){
		super(id);
	}

	@Length(min=0, max=1000, message="请求URL长度必须介于 0 和 1000 之间")
	@ExcelField(title="请求URL", align=2, sort=1)
	public String getRequestUrl() {
		return requestUrl;
	}

	public void setRequestUrl(String requestUrl) {
		this.requestUrl = requestUrl;
	}
	
	@Length(min=0, max=5000, message="消息主体长度必须介于 0 和 5000 之间")
	@ExcelField(title="消息主体", align=2, sort=2)
	public String getRequestBody() {
		return requestBody;
	}

	public void setRequestBody(String requestBody) {
		this.requestBody = requestBody;
	}
	
	@Length(min=0, max=512, message="消息签名长度必须介于 0 和 512 之间")
	@ExcelField(title="消息签名", align=2, sort=3)
	public String getMsgSignature() {
		return msgSignature;
	}

	public void setMsgSignature(String msgSignature) {
		this.msgSignature = msgSignature;
	}
	
	@Length(min=0, max=50, message="时间戳长度必须介于 0 和 50 之间")
	@ExcelField(title="时间戳", align=2, sort=4)
	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}
	
	@Length(min=0, max=50, message="随机数长度必须介于 0 和 50 之间")
	@ExcelField(title="随机数", align=2, sort=5)
	public String getNonce() {
		return nonce;
	}

	public void setNonce(String nonce) {
		this.nonce = nonce;
	}
	
	@Length(min=0, max=512, message="加密字符串长度必须介于 0 和 512 之间")
	@ExcelField(title="加密字符串", align=2, sort=6)
	public String getEchostr() {
		return echostr;
	}

	public void setEchostr(String echostr) {
		this.echostr = echostr;
	}
	
	@Length(min=0, max=50, message="第三方应用的SuiteId长度必须介于 0 和 50 之间")
	@ExcelField(title="第三方应用的SuiteId", align=2, sort=7)
	public String getSuiteId() {
		return suiteId;
	}

	public void setSuiteId(String suiteId) {
		this.suiteId = suiteId;
	}
	
	@Length(min=0, max=50, message="消息类型长度必须介于 0 和 50 之间")
	@ExcelField(title="消息类型", align=2, sort=8)
	public String getInfoType() {
		return infoType;
	}

	public void setInfoType(String infoType) {
		this.infoType = infoType;
	}
	
	@Length(min=0, max=512, message="suite_ticket长度必须介于 0 和 512 之间")
	@ExcelField(title="suite_ticket", align=2, sort=9)
	public String getSuiteTicket() {
		return suiteTicket;
	}

	public void setSuiteTicket(String suiteTicket) {
		this.suiteTicket = suiteTicket;
	}
	
	@Length(min=0, max=512, message="临时授权码长度必须介于 0 和 512 之间")
	@ExcelField(title="临时授权码", align=2, sort=10)
	public String getAuthCode() {
		return authCode;
	}

	public void setAuthCode(String authCode) {
		this.authCode = authCode;
	}
	
	@Length(min=0, max=50, message="授权方的corpid长度必须介于 0 和 50 之间")
	@ExcelField(title="授权方的corpid", align=2, sort=11)
	public String getAuthCorpId() {
		return authCorpId;
	}

	public void setAuthCorpId(String authCorpId) {
		this.authCorpId = authCorpId;
	}
	
	@Length(min=0, max=50, message="通讯录变更类型长度必须介于 0 和 50 之间")
	@ExcelField(title="通讯录变更类型", align=2, sort=12)
	public String getChangeType() {
		return changeType;
	}

	public void setChangeType(String changeType) {
		this.changeType = changeType;
	}
	
	@ExcelField(title="成员ID", fieldType=User.class, value="user.name", align=2, sort=13)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=50, message="部门ID长度必须介于 0 和 50 之间")
	@ExcelField(title="部门ID", align=2, sort=14)
	public String getPartyId() {
		return partyId;
	}

	public void setPartyId(String partyId) {
		this.partyId = partyId;
	}
	
	@Length(min=0, max=1, message="处理状态长度必须介于 0 和 1 之间")
	@ExcelField(title="处理状态", dictType="yes_no", align=2, sort=16)
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
		
}