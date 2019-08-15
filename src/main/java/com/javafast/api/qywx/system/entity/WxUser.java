package com.javafast.api.qywx.system.entity;

import java.io.Serializable;

import com.alibaba.fastjson.JSONObject;

/**
 * 企业微信 - 成员
 * @author JavaFast
 */
public class WxUser implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String userid;//(必须)成员UserID。对应管理端的帐号，企业内必须唯一。不区分大小写，长度为1~64个字节
	private String name;//(必须)成员名称。长度为1~64个字节 
	private Integer[] department;//(必须)成员所属部门id列表,不超过20个
	private String mobile;//手机号码。企业内必须唯一，mobile/email二者不能同时为空
	private String position;//职位信息。长度为0~64个字节
	private String gender;//性别。1表示男性，2表示女性
	private String email;//邮箱。长度不超过64个字节，且为有效的email格式。企业内必须唯一，mobile/email二者不能同时为空
	private String telephone;//座机。由1-32位的纯数字或’-‘号组成。
	private Integer enable;//启用/禁用成员。1表示启用成员，0表示禁用成员 
	private String avatar_mediaid;//成员头像的mediaid，通过多媒体接口上传图片获得的mediaid
	private String avatar;//头像url。注：如果要获取小图将url最后的"/0"改成"/64"即可   创建的时候不需要这个字段 也可以使用transient来取消序列化
	private Integer status;//关注状态 1=已关注，2=已禁用，4=未关注   创建的时候不需要这个字段 也可以使用transient来取消序列化
	private JSONObject extattr;//扩展属性。扩展属性需要在WEB管理端创建后才生效，否则忽略未知属性的赋值
	
	private String weixinid;//微信号。企业内必须唯一。（注意：是微信号，不是微信的名字）
	private String qr_code;//员工个人二维码，扫描可添加为外部联系人；第三方仅通讯录应用可获取
	
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
	public Integer[] getDepartment() {
		return department;
	}
	public void setDepartment(Integer[] department) {
		this.department = department;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
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
	public String getWeixinid() {
		return weixinid;
	}
	public void setWeixinid(String weixinid) {
		this.weixinid = weixinid;
	}
	public Integer getEnable() {
		return enable;
	}
	public void setEnable(Integer enable) {
		this.enable = enable;
	}
	public String getAvatar_mediaid() {
		return avatar_mediaid;
	}
	public void setAvatar_mediaid(String avatar_mediaid) {
		this.avatar_mediaid = avatar_mediaid;
	}
	public String getAvatar() {
		return avatar;
	}
	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public JSONObject getExtattr() {
		return extattr;
	}
	public void setExtattr(JSONObject extattr) {
		this.extattr = extattr;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getQr_code() {
		return qr_code;
	}
	public void setQr_code(String qr_code) {
		this.qr_code = qr_code;
	}
	
}
