package com.javafast.api.qywxs.auth.api;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywxs.auth.entity.AuthCorpInfo;
import com.javafast.api.qywxs.auth.entity.AuthInfo;
import com.javafast.api.qywxs.auth.entity.AuthUserInfo;
import com.javafast.api.qywxs.auth.entity.PermanentInfo;

/**
 * 企业微信服务商 - 授权相关
 * @author JavaFast
 */
public class WxSuiteAuthAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxSuiteAuthAPI.class);
	
	//获取预授权码 GET（HTTPS）
	public final static String get_pre_auth_code_url = "https://qyapi.weixin.qq.com/cgi-bin/service/get_pre_auth_code?suite_access_token=SUITE_ACCESS_TOKEN";  
	
	//通过临时授权码获取企业永久授权码 POST（HTTPS）
	public final static String get_permanent_code = "https://qyapi.weixin.qq.com/cgi-bin/service/get_permanent_code?suite_access_token=SUITE_ACCESS_TOKEN";
	
	//通过永久授权码换取企业微信的授权信息
	public final static String get_permanent_info = "https://qyapi.weixin.qq.com/cgi-bin/service/get_auth_info?suite_access_token=SUITE_ACCESS_TOKEN";
	
	/**
	 * 获取预授权码 
	 * @param suiteAccessToken 第三方应用access_token
	 * @return 
	 */
	public static String getPreAuthCode(String suiteAccessToken){
		
		//1.请求URL
		String requestUrl = get_pre_auth_code_url.replace("SUITE_ACCESS_TOKEN", suiteAccessToken);
		
		//2.调用微信接口
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
		
		if (null != jsonObject) {
			 
			try {
				
				//3.获取预授权码 
				return jsonObject.getString("pre_auth_code");
			} catch (Exception e) {
				e.printStackTrace();
				String errmsg = jsonObject.getString("errmsg");
				logger.info("获取预授权码失败："+errmsg);
			}
		}
		return null;
	}
	
	/**
	 * 通过临时授权码获取企业永久授权信息
	 * @param suiteAccessToken 第三方应用suite_access_token
	 * @param auth_code 临时授权码
	 * @return
	 */
	public static PermanentInfo getPermanentCode(String suiteAccessToken, String authCode){
		
		String requestUrl = get_permanent_code.replace("SUITE_ACCESS_TOKEN", suiteAccessToken);
		
		//1.请求参数
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("auth_code", authCode);
		 
		//2.调用微信接口，发送请求
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam.toJSONString());
		if (null != jsonObject) {
			
			int errcode = jsonObject.getIntValue("errcode");	
			if(errcode == 0){
				
				//3.读取响应信息
				Gson gson = new Gson();
				PermanentInfo permanentInfo = new PermanentInfo();
				
				String access_token = jsonObject.getString("access_token");
		    	String expires_in = jsonObject.getString("expires_in");
		    	String permanent_code = jsonObject.getString("permanent_code");
		    	String auth_corp_info = jsonObject.getString("auth_corp_info");//授权方企业信息
		    	String auth_user_info = jsonObject.getString("auth_user_info");//授权方管理员信息
		    	
		    	//授权信息。如果是通讯录应用，且没开启实体应用，是没有该项的。通讯录应用拥有企业通讯录的全部信息读写权限
		    	JSONObject auth_info = jsonObject.getJSONObject("auth_info");
		    	//授权的应用信息，注意是一个数组，但仅旧的多应用套件授权时会返回多个agent，对新的单应用授权，永远只返回一个agent
		    	JSONArray agent = auth_info.getJSONArray("agent");
		    	if(agent != null && agent.size() > 0){
		    		AuthInfo authInfo = gson.fromJson(agent.getString(0), new TypeToken<AuthInfo>(){}.getType());
		    		permanentInfo.setAuthInfo(authInfo);
		    	}
		    	
		    	permanentInfo.setAccess_token(access_token);
		    	permanentInfo.setExpires_in(expires_in);
		    	permanentInfo.setPermanent_code(permanent_code);
		    	
		    	AuthCorpInfo authCorpInfo = gson.fromJson(auth_corp_info, new TypeToken<AuthCorpInfo>(){}.getType());
		    	AuthUserInfo authUserInfo = gson.fromJson(auth_user_info, new TypeToken<AuthUserInfo>(){}.getType());
		    	permanentInfo.setAuthCorpInfo(authCorpInfo);
		    	permanentInfo.setAuthUserInfo(authUserInfo);
		    	
		    	return permanentInfo;
			}else{
				
				String errmsg = jsonObject.getString("errmsg");
				logger.info("获取企业永久授权信息出错："+errmsg);
			}
		}
		return null;
	}
	
	/**
	 * 通过永久授权码换取企业微信的授权信息
	 * @param suiteAccessToken 第三方应用suite_access_token
	 * @param auth_corpid 授权方corpid
	 * @param permanent_code 永久授权码
	 * @return
	 */
	public static PermanentInfo getPermanentInfo(String suiteAccessToken, String authCorpid, String permanentCode){
		
		String requestUrl = get_permanent_info.replace("SUITE_ACCESS_TOKEN", suiteAccessToken);
		
		//1.请求参数
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("auth_corpid", authCorpid);
		jsonParam.put("permanent_code", permanentCode);
		 
		//2.调用微信接口，发送请求
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam.toJSONString());
		if (null != jsonObject) {
			
			int errcode = jsonObject.getIntValue("errcode");	
			if(errcode == 0){
				
				//3.读取响应信息
				Gson gson = new Gson();
				PermanentInfo permanentInfo = new PermanentInfo();
				
				//授权方企业信息
				String auth_corp_info = jsonObject.getString("auth_corp_info");//
				AuthCorpInfo authCorpInfo = gson.fromJson(auth_corp_info, new TypeToken<AuthCorpInfo>(){}.getType());
				permanentInfo.setAuthCorpInfo(authCorpInfo);
				
				//授权信息。如果是通讯录应用，且没开启实体应用，是没有该项的。通讯录应用拥有企业通讯录的全部信息读写权限
		    	JSONObject auth_info = jsonObject.getJSONObject("auth_info");
		    	//授权的应用信息，注意是一个数组，但仅旧的多应用套件授权时会返回多个agent，对新的单应用授权，永远只返回一个agent
		    	JSONArray agent = auth_info.getJSONArray("agent");
		    	if(agent != null && agent.size() > 0){
		    		AuthInfo authInfo = gson.fromJson(agent.getString(0), new TypeToken<AuthInfo>(){}.getType());
		    		permanentInfo.setAuthInfo(authInfo);
		    	}
				
				return permanentInfo;
			}
		}
		
		return null;
	}
}
