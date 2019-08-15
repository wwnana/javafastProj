package com.javafast.api.qywxs.sso.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;
import com.javafast.api.qywxs.sso.entity.LoginUserInfo;
import com.javafast.common.utils.HttpRequestUtils;

/**
 * 获取登录用户信息
 * @author syh
 *
 */
public class SuiteUserAPI {

	private static final Logger logger = LoggerFactory.getLogger(SuiteUserAPI.class);
	
	//获取登录用户信息 POST（HTTPS）
	private static String get_login_info_url = "https://qyapi.weixin.qq.com/cgi-bin/service/get_login_info?access_token=PROVIDER_ACCESS_TOKEN";

	/**
	 * 获取登录用户信息
	 * @param providerAccessToken
	 * @param authCode
	 * @return
	 */
	public static LoginUserInfo getLoginInfo(String providerAccessToken, String authCode) {

		LoginUserInfo loginUserInfo = null;
		
		// 1.拼装url
		String requestUrl = get_login_info_url.replace("PROVIDER_ACCESS_TOKEN", providerAccessToken);

		// 2.请求参数
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("auth_code", authCode);

		// 3.调用接口
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam.toJSONString());

		if (null != jsonObject) {

			try {

				//4.获取用户登录信息
				loginUserInfo = JSONObject.toJavaObject(jsonObject, LoginUserInfo.class);
			} catch (Exception e) {
				e.printStackTrace();
				int errcode = jsonObject.getIntValue("errcode");
				String errmsg = jsonObject.getString("errmsg");
				logger.info("[get_login_info]", "获取登录用户信息失败 errcode:{} errmsg:{}", new Object[]{errcode,errmsg});
			}
		}
		
		return loginUserInfo;
	}
}
