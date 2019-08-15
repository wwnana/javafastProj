package com.javafast.api.qywx.audit.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.javafast.api.qywx.audit.entity.WxApproval;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.HttpRequestUtils;

/**
 * 获取审批数据API
 * @author syh
 *
 */
public class WxApprovalAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxApprovalAPI.class);
	
	// 获取审批数据 POST（HTTPS）
	public final static String getapprovaldata_url = "https://qyapi.weixin.qq.com/cgi-bin/corp/getapprovaldata?access_token=ACCESS_TOKEN";

	/**
	 * 获取审批数据
	 * @param accessToken 调用接口凭证。必须使用审批应用的Secret获取access_token
	 * @param starttime 获取审批记录的开始时间。Unix时间戳
	 * @param endtime 获取审批记录的结束时间。Unix时间戳
	 * @return
	 */
	public static WxApproval getApprovalData(String accessToken, Long starttime, Long endtime) {

		// 1.拼装发送信息的url
		String requestUrl = getapprovaldata_url.replace("ACCESS_TOKEN", accessToken);

		// 2.请求参数
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("starttime", starttime);
		jsonParam.put("endtime", endtime);

		// 3.调用接口发送消息
		JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam.toJSONString());
		System.out.println(jsonObject);
		// 请求成功
		if (null != jsonObject && jsonObject.getIntValue("errcode") == 0) {

			try {

				Integer total = jsonObject.getIntValue("total");
				if(total > 0){
					WxApproval wxApproval = JSON.parseObject(jsonObject.toJSONString(), WxApproval.class);
					return wxApproval;
				}
			} catch (Exception e) {
				e.printStackTrace();
				int errcode = jsonObject.getIntValue("errcode");
				String errmsg = jsonObject.getString("errmsg");
				logger.info("[get_login_info]", "获取审批数据失败 errcode:{} errmsg:{}", new Object[] { errcode, errmsg });
			}
		}
		return null;
	}
	
	public static void main(String[] args) {
		//2.获取accssToken
        AccessToken token = WxAccessTokenAPI.getAccessToken("ww93e8ff412e12f35b", "");
        String accessToken = token.getAccessToken();
		Long starttime = DateUtils.date2TimeStamp(DateUtils.parseDate("2017-01-01"));
		Long endtime = DateUtils.date2TimeStamp(DateUtils.parseDate("2018-07-10"));
		WxApproval wxApproval = getApprovalData(accessToken, starttime, endtime);
		System.out.println(wxApproval.getData().get(0).getApply_name());
	}
}
