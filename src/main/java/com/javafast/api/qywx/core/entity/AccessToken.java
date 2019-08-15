package com.javafast.api.qywx.core.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 微信通用接口凭证 
 * @author JavaFast
 */
public class AccessToken implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// 获取到的凭证  
    private String accessToken;  
    
    // 凭证有效时间，单位：秒  
    private int expiresIn;
    
    //时间戳
    private long timestamp;
    
    //企业微信应用ID
    private int wxAgentid;

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	} 
    
	public int getExpiresIn() {
		return expiresIn;
	}

	public void setExpiresIn(int expiresIn) {
		this.expiresIn = expiresIn;
	}
	
	public int getWxAgentid() {
		return wxAgentid;
	}

	public void setWxAgentid(int wxAgentid) {
		this.wxAgentid = wxAgentid;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}

	public String toString() {
		return "AccessToken [accesstoken=" + accessToken + ", expiresIn=" + expiresIn + ", timestamp=" + timestamp + "]";
	}
}
