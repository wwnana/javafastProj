package com.javafast.api.qywxs.core.api;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.HttpRequestUtils;

/**
 * 该API用于获取第三方应用凭证（suite_access_token）。
 * @author syh
 *
 */
public class WxSuiteAccessTokenAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxSuiteAccessTokenAPI.class);
	
	//获取第三方应用凭证（suite_access_token） POST（HTTPS）
	public final static String access_token_url = "https://qyapi.weixin.qq.com/cgi-bin/service/get_suite_token";  
	
	/**
	 * 获取第三方应用凭证（suite_access_token）
	 * @param suiteId 以ww或wx开头应用id（对应于旧的以tj开头的套件id）
	 * @param suiteSecret 应用secret
	 * @param suiteTicket 企业微信后台推送的ticket
	 * @return
	 */
	public static AccessToken getAccessToken(String suiteId, String suiteSecret, String suiteTicket){
		
		 AccessToken accessToken = null; 
		 
		 //1.请求参数
		 JSONObject jsonParam = new JSONObject();
		 jsonParam.put("suite_id", suiteId);
		 jsonParam.put("suite_secret", suiteSecret);
		 jsonParam.put("suite_ticket", suiteTicket);
		 
		 //2.调用接口，发送消息
		 JSONObject jsonObject = HttpRequestUtils.httpsRequest(access_token_url, "POST", jsonParam.toJSONString());

		 if (null != jsonObject) {
			 
			 try {
				 
				 //3.获取响应内容
				 accessToken = new AccessToken();
				 accessToken.setAccessToken(jsonObject.getString("suite_access_token"));
				 accessToken.setExpiresIn(jsonObject.getIntValue("expires_in"));
				 accessToken.setTimestamp(DateUtils.getCurrentTimestamp());
				 logger.info("[ACCESSTOKEN]", "获取第三方应用凭证suite_access_token成功:{}", new Object[]{accessToken});
			 } catch (Exception e) { 
				 e.printStackTrace();
				 //4.错误消息处理
				 int errcode = jsonObject.getIntValue("errcode");
		         String errmsg = jsonObject.getString("errmsg");
				 logger.info("[ACCESSTOKEN]", "获取第三方应用凭证suite_access_token失败 errcode:{} errmsg:{}", new Object[]{errcode,errmsg});
			 }
		 }
		 
		 return accessToken;
	}
}
