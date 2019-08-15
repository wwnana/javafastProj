package com.javafast.api.qywx.core.api;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywx.core.entity.AccessToken;

/**
 * 企业微信 - 获取access_token
 * @author JavaFast
 */
public class WxAccessTokenAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxAccessTokenAPI.class);
	
	//获取access_token的接口地址（GET）   
	public final static String access_token_url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=CorpID&corpsecret=SECRET";  
	
	/**
	 * 企业微信获取access_token
	 * @param corpId
	 * @param corpSecret
	 * @return
	 */
	public static AccessToken getAccessToken(String corpId, String corpSecret){
		
		 AccessToken accessToken = null; 
		 
		 //1.拼接请求URL
		 String requestUrl = access_token_url.replace("CorpID", corpId).replace("SECRET", corpSecret);  
		 
		 //2.调用微信接口
		 JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
		 
		 if (null != jsonObject) {
			 
			 try {
				 
				 //3. 获取响应内容
				 accessToken = new AccessToken();
				 accessToken.setAccessToken(jsonObject.getString("access_token"));
				 accessToken.setExpiresIn(jsonObject.getIntValue("expires_in"));
				 accessToken.setTimestamp(DateUtils.getCurrentTimestamp());
				 logger.info("[ACCESSTOKEN]", "企业微信获取ACCESSTOKEN成功:{}", new Object[]{accessToken});
			 } catch (Exception e) { 
				 e.printStackTrace();
				 //4.错误消息处理
				 int errcode = jsonObject.getIntValue("errcode");
		         String errmsg = jsonObject.getString("errmsg");
				 logger.info("[ACCESSTOKEN]", "企业微信获取ACCESSTOKEN失败 errcode:{} errmsg:{}", new Object[]{errcode,errmsg});
			 }
		 }
		 
		 return accessToken;
	}
}
