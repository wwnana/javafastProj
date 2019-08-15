package com.javafast.api.qywxs.auth.entity;

import java.io.Serializable;

public class PermanentInfo implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String access_token;//授权方（企业）access_token,最长为512字节
	
	private String expires_in;//授权方（企业）access_token超时时间
	
	private String permanent_code;//企业微信永久授权码,最长为512字节
	
	private AuthCorpInfo authCorpInfo;//授权方企业信息
	
	private AuthInfo authInfo;//授权的应用信息
	
	private AuthUserInfo authUserInfo;//授权管理员的信息

	public String getAccess_token() {
		return access_token;
	}

	public void setAccess_token(String access_token) {
		this.access_token = access_token;
	}

	public String getExpires_in() {
		return expires_in;
	}

	public void setExpires_in(String expires_in) {
		this.expires_in = expires_in;
	}

	public String getPermanent_code() {
		return permanent_code;
	}

	public void setPermanent_code(String permanent_code) {
		this.permanent_code = permanent_code;
	}

	public AuthCorpInfo getAuthCorpInfo() {
		return authCorpInfo;
	}

	public void setAuthCorpInfo(AuthCorpInfo authCorpInfo) {
		this.authCorpInfo = authCorpInfo;
	}

	public AuthUserInfo getAuthUserInfo() {
		return authUserInfo;
	}

	public void setAuthUserInfo(AuthUserInfo authUserInfo) {
		this.authUserInfo = authUserInfo;
	}

	public AuthInfo getAuthInfo() {
		return authInfo;
	}

	public void setAuthInfo(AuthInfo authInfo) {
		this.authInfo = authInfo;
	}
	
	
}
