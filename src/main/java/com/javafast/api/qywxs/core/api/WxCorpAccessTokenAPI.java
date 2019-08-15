package com.javafast.api.qywxs.core.api;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywx.core.entity.AccessToken;

/**
 * 企业在第三方应用-获取企业access_token
 * @author JavaFast
 */
public class WxCorpAccessTokenAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxCorpAccessTokenAPI.class);
	
	//企业在第三方应用获取企业access_token POST
	public final static String get_corp_token_url = "https://qyapi.weixin.qq.com/cgi-bin/service/get_corp_token?suite_access_token=SUITE_ACCESS_TOKEN";  
	
	/**
	 * 企业在第三方应用获取企业access_token
	 * @param suite_access_token 服务商access_token
	 * @param authCorpid 授权方corpid
	 * @param permanentCode 永久授权码
	 * @return
	 */
	public static AccessToken getCorpAccessToken(String suiteAccessToken, String authCorpid, String permanentCode){
		
		 AccessToken accessToken = null; 
		 
		 String requestUrl = get_corp_token_url.replace("SUITE_ACCESS_TOKEN", suiteAccessToken);
		 
		 //1.请求参数
		 JSONObject jsonParam = new JSONObject();
		 jsonParam.put("auth_corpid", authCorpid);
		 jsonParam.put("permanent_code", permanentCode);
		 
		 //2.调用接口，发送消息
		 JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam.toJSONString());
		 System.out.println("企业在第三方应用获取企业access_token,jsonObject"+jsonObject);
		 
		 if (null != jsonObject) {
			 
			 try {
				 
				//3.获取响应内容
				 accessToken = new AccessToken();				 
				 accessToken.setAccessToken(jsonObject.getString("access_token"));
				 accessToken.setExpiresIn(jsonObject.getIntValue("expires_in"));
				 accessToken.setTimestamp(DateUtils.getCurrentTimestamp());
				 logger.info("[ACCESSTOKEN]", "企业在第三方应用获取企业access_token成功:{}", new Object[]{accessToken});
			 } catch (Exception e) { 
				 e.printStackTrace();
				 //4.错误消息处理
				 int errcode = jsonObject.getIntValue("errcode");
		         String errmsg = jsonObject.getString("errmsg");
				 logger.info("[ACCESSTOKEN]", "企业在第三方应用获取企业access_token失败 errcode:{} errmsg:{}", new Object[]{errcode,errmsg});
			 }			 
		 }
		 return accessToken;
	}
}
