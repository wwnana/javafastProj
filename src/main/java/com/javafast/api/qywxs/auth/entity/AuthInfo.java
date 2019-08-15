package com.javafast.api.qywxs.auth.entity;

import java.io.Serializable;

/**
 * 授权的应用信息
 * @author syh
 *
 */
public class AuthInfo implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer agentid;//授权方应用id
	
	private String name;//授权方应用名字
	
	private String square_logo_url;//授权方应用方形头像
	
	private String round_logo_url;//授权方应用圆形头像

	public Integer getAgentid() {
		return agentid;
	}

	public void setAgentid(Integer agentid) {
		this.agentid = agentid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSquare_logo_url() {
		return square_logo_url;
	}

	public void setSquare_logo_url(String square_logo_url) {
		this.square_logo_url = square_logo_url;
	}

	public String getRound_logo_url() {
		return round_logo_url;
	}

	public void setRound_logo_url(String round_logo_url) {
		this.round_logo_url = round_logo_url;
	}
	
	
}
