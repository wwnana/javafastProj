package com.javafast.api.qywxs.message.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.message.entity.MessageText;
import com.javafast.api.qywx.message.entity.MessageTextData;

/**
 * 企业微信 - 消息
 * @author JavaFast
 */
public class WxMessageAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxMessageAPI.class);
	
	//发送应用消息 POST（HTTPS）
	private static String message_send_url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=ACCESS_TOKEN";
	
	/**
	 * 发送文本信息
	 * @param text
	 * @param accessToken
	 * @return
	 */
	public static boolean sendTextMessage(MessageText text, String accessToken) {
		
		// 1.拼装发送信息的url  
	    String requestUrl = message_send_url.replace("ACCESS_TOKEN", accessToken);
	    
	    // 2.将信息对象转换成json字符串  
	    String jsonText = JSONObject.toJSONString(text);
	    
	    //3.调用接口发送消息
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonText);	    
	   
	    logger.info("[CREATEMESSAGE]", "发送文本信息sendMessage response:{}", new Object[]{jsonObject.toJSONString()});
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	        if(errcode == 0){
	        	return true;
	        }
	    }
	    return false;
	}
}
