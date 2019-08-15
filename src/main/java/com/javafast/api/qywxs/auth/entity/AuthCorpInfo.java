package com.javafast.api.qywxs.auth.entity;

import java.io.Serializable;

/**
 * 授权方企业信息
 * @author JavaFast
 */
public class AuthCorpInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String corpid;//企业微信id
	
	private String corp_name;//企业微信名称
	
	private String corp_type;//企业微信类型，认证号：verified, 注册号：unverified
	
	private String corp_square_logo_url;//企业微信方形头像
	
	private int corp_user_max;//企业微信用户规模
	
	private int corp_agent_max;//授权用户规模
	
	private String corp_full_name;//所绑定的企业微信主体名称
	
	private long verified_end_time;//认证到期时间
	
	private int subject_type;//企业类型，1. 企业; 2. 政府以及事业单位; 3. 其他组织, 4.团队号
	
	private String corp_wxqrcode;//授权方企业微信二维码
	
	private String corp_scale;//企业规模。当企业未设置该属性时，值为空
	
	private String corp_industry;//企业所属行业。当企业未设置该属性时，值为空
	
	private String corp_sub_industry;//企业所属子行业。当企业未设置该属性时，值为空

	public String getCorpid() {
		return corpid;
	}

	public void setCorpid(String corpid) {
		this.corpid = corpid;
	}

	public String getCorp_name() {
		return corp_name;
	}

	public void setCorp_name(String corp_name) {
		this.corp_name = corp_name;
	}

	public String getCorp_type() {
		return corp_type;
	}

	public void setCorp_type(String corp_type) {
		this.corp_type = corp_type;
	}

	public String getCorp_square_logo_url() {
		return corp_square_logo_url;
	}

	public void setCorp_square_logo_url(String corp_square_logo_url) {
		this.corp_square_logo_url = corp_square_logo_url;
	}

	public int getCorp_user_max() {
		return corp_user_max;
	}

	public void setCorp_user_max(int corp_user_max) {
		this.corp_user_max = corp_user_max;
	}

	public int getCorp_agent_max() {
		return corp_agent_max;
	}

	public void setCorp_agent_max(int corp_agent_max) {
		this.corp_agent_max = corp_agent_max;
	}

	public String getCorp_full_name() {
		return corp_full_name;
	}

	public void setCorp_full_name(String corp_full_name) {
		this.corp_full_name = corp_full_name;
	}

	public long getVerified_end_time() {
		return verified_end_time;
	}

	public void setVerified_end_time(long verified_end_time) {
		this.verified_end_time = verified_end_time;
	}

	public int getSubject_type() {
		return subject_type;
	}

	public void setSubject_type(int subject_type) {
		this.subject_type = subject_type;
	}

	public String getCorp_wxqrcode() {
		return corp_wxqrcode;
	}

	public void setCorp_wxqrcode(String corp_wxqrcode) {
		this.corp_wxqrcode = corp_wxqrcode;
	}

	public String getCorp_scale() {
		return corp_scale;
	}

	public void setCorp_scale(String corp_scale) {
		this.corp_scale = corp_scale;
	}

	public String getCorp_industry() {
		return corp_industry;
	}

	public void setCorp_industry(String corp_industry) {
		this.corp_industry = corp_industry;
	}

	public String getCorp_sub_industry() {
		return corp_sub_industry;
	}

	public void setCorp_sub_industry(String corp_sub_industry) {
		this.corp_sub_industry = corp_sub_industry;
	}
	
	
}
