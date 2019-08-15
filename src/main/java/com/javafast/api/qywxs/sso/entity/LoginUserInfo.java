package com.javafast.api.qywxs.sso.entity;

import java.io.Serializable;

/**
 * 登录用户信息
 * @author syh
 *
 */
public class LoginUserInfo implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String usertype;//登录用户的类型：1.创建者 2.内部系统管理员 3.外部系统管理员 4.分级管理员 5.成员
	private UserInfo userInfo;
	private CorpInfo corpInfo;
	
	public String getUsertype() {
		return usertype;
	}
	public void setUsertype(String usertype) {
		this.usertype = usertype;
	}
	public UserInfo getUserInfo() {
		return userInfo;
	}
	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}
	public CorpInfo getCorpInfo() {
		return corpInfo;
	}
	public void setCorpInfo(CorpInfo corpInfo) {
		this.corpInfo = corpInfo;
	}
	
	
}
