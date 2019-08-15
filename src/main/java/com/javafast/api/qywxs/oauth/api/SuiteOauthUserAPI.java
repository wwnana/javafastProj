package com.javafast.api.qywxs.oauth.api;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.qywxs.oauth.entity.OauthUserDetail;
import com.javafast.api.qywxs.oauth.entity.OauthUserInfo;
import com.javafast.common.utils.HttpRequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 获取登录用户信息
 * 
 * @author syh
 *
 */
public class SuiteOauthUserAPI {

	private static final Logger logger = LoggerFactory.getLogger(SuiteOauthUserAPI.class);

	// 第三方根据code获取企业成员信息GET（HTTPS）
	private static String get_login_info_url = "https://qyapi.weixin.qq.com/cgi-bin/service/getuserinfo3rd?access_token=SUITE_ACCESS_TOKEN&code=CODE";

	// 第三方使用user_ticket获取成员详情 POST（HTTPS）
	private static String getuserdetail3rd_url = "https://qyapi.weixin.qq.com/cgi-bin/service/getuserdetail3rd?access_token=SUITE_ACCESS_TOKEN";

	/**
	 * 第三方根据code获取企业成员信息
	 * 
	 * @param suite_access_token
	 *            第三方应用的suite_access_token
	 * @param authCode
	 * @return
	 */
	public static OauthUserInfo getOauthUserInfo(String suiteAccessToken, String authCode) {

		OauthUserInfo oauthUserInfo = null;

		// 拼装url
		String requestUrl = get_login_info_url.replace("SUITE_ACCESS_TOKEN", suiteAccessToken).replace("CODE", authCode);

		// 调用接口
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);

		// 请求成功
		if (null != jsonObject && jsonObject.getIntValue("errcode") == 0) {
			System.out.println("第三方根据code获取企业成员信息 "+jsonObject);
			try {

				oauthUserInfo = JSONObject.toJavaObject(jsonObject, OauthUserInfo.class);
			} catch (Exception e) {
				e.printStackTrace();
				int errcode = jsonObject.getIntValue("errcode");
				String errmsg = jsonObject.getString("errmsg");
				logger.info("[get_login_info]", "获取登录用户信息失败 errcode:{} errmsg:{}", new Object[] { errcode, errmsg });
			}
		}

		return oauthUserInfo;
	}

	/**
	 * 第三方使用user_ticket获取成员详情
	 * @param suiteAccessToken 第三方应用的suite_access_token，参见“获取第三方应用凭证”
	 * @param userTicket 成员票据
	 * @return
	 */
	public static OauthUserDetail getUserDetail(String suiteAccessToken, String userTicket) {
		
		OauthUserDetail oauthUserDetail = null;
		
		// 拼装url
		String requestUrl = getuserdetail3rd_url.replace("SUITE_ACCESS_TOKEN", suiteAccessToken);

		 //请求参数
		 JSONObject jsonParam = new JSONObject();
		 jsonParam.put("user_ticket", userTicket);
		 
		// 调用接口
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", jsonParam.toJSONString());

		logger.info("第三方使用user_ticket获取成员详情"+jsonObject);
		
		// 请求成功
		if (null != jsonObject && jsonObject.getIntValue("errcode") == 0) {

			try {

				oauthUserDetail = JSONObject.toJavaObject(jsonObject, OauthUserDetail.class);
			} catch (Exception e) {
				e.printStackTrace();
				int errcode = jsonObject.getIntValue("errcode");
				String errmsg = jsonObject.getString("errmsg");
				logger.info("[get_login_info]", "第三方使用user_ticket获取成员详情失败 errcode:{} errmsg:{}", new Object[] { errcode, errmsg });
			}
		}
		
		return oauthUserDetail;
	}

}
