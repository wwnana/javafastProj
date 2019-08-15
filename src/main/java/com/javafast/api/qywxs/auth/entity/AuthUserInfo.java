package com.javafast.api.qywxs.auth.entity;

import java.io.Serializable;

/**
 * 授权管理员的信息
 * @author JavaFast
 */
public class AuthUserInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String email;//授权管理员的邮箱（仅为外部管理员，该字段有返回值）
	
	private String userid;//授权管理员的userid，可能为空（内部管理员一定有，不可更改）
	
	private String name;//授权管理员的name，可能为空（内部管理员一定有，不可更改）
	
	private String avatar;//授权管理员的头像url

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}
	
	
}
