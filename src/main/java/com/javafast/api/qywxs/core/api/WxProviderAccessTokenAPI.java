package com.javafast.api.qywxs.core.api;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.HttpRequestUtils;

/**
 * 企业微信服务商-获取服务商的token
 * @author JavaFast
 */
public class WxProviderAccessTokenAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxProviderAccessTokenAPI.class);
	
	//获取access_token的接口地址（POST）   
	public final static String access_token_url = "https://qyapi.weixin.qq.com/cgi-bin/service/get_provider_token";  
		
	/**
	 * 获取企业微信服务商access_token
	 * @param corpid 服务商的corpid
	 * @param provider_secret
	 * @return
	 */
	public static AccessToken getAccessToken(String corpid, String provider_secret){
		
		 AccessToken accessToken = null; 
		 
		 //1.请求参数
		 JSONObject jsonParam = new JSONObject();
		 jsonParam.put("corpid", corpid);
		 jsonParam.put("provider_secret", provider_secret);
		 
		 //2.调用接口，发送消息
		 JSONObject jsonObject = HttpRequestUtils.httpsRequest(access_token_url, "POST", jsonParam.toJSONString());
		 
		 if (null != jsonObject) {
				 
			 try {
				 
				 //3.获取响应内容
				 accessToken = new AccessToken();
				 accessToken.setAccessToken(jsonObject.getString("provider_access_token"));
				 accessToken.setExpiresIn(jsonObject.getIntValue("expires_in"));
				 accessToken.setTimestamp(DateUtils.getCurrentTimestamp());
				 logger.info("[ACCESSTOKEN]", "获取企业微信服务商provider_access_token成功:{}", new Object[]{accessToken});
			 } catch (Exception e) { 
				 e.printStackTrace();
				//4.错误消息处理
				 int errcode = jsonObject.getIntValue("errcode");
		         String errmsg = jsonObject.getString("errmsg");
				 logger.info("[ACCESSTOKEN]", "获取企业微信服务商provider_access_token失败 errcode:{} errmsg:{}", new Object[]{errcode,errmsg});
			 }
		 }
		 
		 return accessToken;
	}
}
