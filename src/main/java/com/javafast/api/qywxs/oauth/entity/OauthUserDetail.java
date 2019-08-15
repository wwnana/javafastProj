package com.javafast.api.qywxs.oauth.entity;

/**
 * 第三方使用user_ticket获取成员详情
 * @author syh
 *
 */
public class OauthUserDetail {

	private String corpid;//用户所属企业的corpid
	private String userid;//成员UserID
	private String name;//成员姓名
	private String mobile;//成员手机号，仅在用户同意snsapi_privateinfo授权时返回
	private String gender;//性别。0表示未定义，1表示男性，2表示女性
	private String email;//成员邮箱，仅在用户同意snsapi_privateinfo授权时返回
	private String avatar;//头像url。注：如果要获取小图将url最后的”/0”改成”/100”即可。仅在用户同意snsapi_privateinfo授权时返回
	private String qr_code;//员工个人二维码（扫描可添加为外部联系人），仅在用户同意snsapi_privateinfo授权时返回
	public String getCorpid() {
		return corpid;
	}
	public void setCorpid(String corpid) {
		this.corpid = corpid;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAvatar() {
		return avatar;
	}
	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}
	public String getQr_code() {
		return qr_code;
	}
	public void setQr_code(String qr_code) {
		this.qr_code = qr_code;
	}
	
	
}
