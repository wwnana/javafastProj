package com.javafast.api.qywxs.oauth.entity;

/**
 * 第三方根据code获取企业成员信息
 * 
 * @author syh
 *
 */
public class OauthUserInfo {
	
	private String errcode;
	private String errmsg;
	private String CorpId;//用户所属企业的corpid
	private String UserId;//用户在企业内的UserID，如果该企业与第三方应用有授权关系时，返回明文UserId，否则返回密文UserId
	private String DeviceId;//手机设备号(由企业微信在安装时随机生成，删除重装会改变，升级不受影响)
	private String user_ticket;//成员票据，最大为512字节。scope为snsapi_userinfo或snsapi_privateinfo，且用户在应用可见范围之内时返回此参数。后续利用该参数可以获取用户信息或敏感信息，参见“第三方使用user_ticket获取成员详情”。
	private String expires_in;

	public String getErrcode() {
		return errcode;
	}

	public void setErrcode(String errcode) {
		this.errcode = errcode;
	}

	public String getErrmsg() {
		return errmsg;
	}

	public void setErrmsg(String errmsg) {
		this.errmsg = errmsg;
	}

	public String getCorpId() {
		return CorpId;
	}

	public void setCorpId(String corpId) {
		CorpId = corpId;
	}

	public String getUserId() {
		return UserId;
	}

	public void setUserId(String userId) {
		UserId = userId;
	}

	public String getDeviceId() {
		return DeviceId;
	}

	public void setDeviceId(String deviceId) {
		DeviceId = deviceId;
	}

	public String getUser_ticket() {
		return user_ticket;
	}

	public void setUser_ticket(String user_ticket) {
		this.user_ticket = user_ticket;
	}

	public String getExpires_in() {
		return expires_in;
	}

	public void setExpires_in(String expires_in) {
		this.expires_in = expires_in;
	}
}
