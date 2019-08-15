package com.javafast.modules.qws.utils;

import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.qws.dao.QwsSuiteNoticeDao;
import com.javafast.modules.qws.entity.QwsSuiteNotice;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywxs.core.api.WxProviderAccessTokenAPI;

/**
 * 企业微信服务商工具类  （第三方）
 * @author JavaFast
 */
public class ProviderUtils {

	private static QwsSuiteNoticeDao qwsSuiteNoticeDao = SpringContextHolder.getBean(QwsSuiteNoticeDao.class);
	
	//企业微信服务商access_token 缓存名称
	public static final String CACHE_PROVIDER_ACCESS_TOKEN = "provider_access_token";

	/**
	 * 获取企业微信服务商access_token 
	 * @return
	 */
	public static AccessToken getProviderAccessToken(){
		
		//1.优先从缓存中读取
		AccessToken accessToken = (AccessToken) CacheUtils.get(CACHE_PROVIDER_ACCESS_TOKEN);
		if (accessToken != null) {
			//判断缓存中的accessToken是否过期
			if (((DateUtils.getCurrentTimestamp() - accessToken.getTimestamp()) / 1000) < accessToken.getExpiresIn()){
				return accessToken;
			}
		}
		
		//2.从企业微信接口获取企业微信access_token
		accessToken = WxProviderAccessTokenAPI.getAccessToken(ProviderConstantUtils.corpId, ProviderConstantUtils.providerSecret);
		if(accessToken != null){
			
			//3.设置缓存
			CacheUtils.put(CACHE_PROVIDER_ACCESS_TOKEN, accessToken);
		}
		
		return accessToken;
	}
	
	/**
	 * 记录指令回调消息
	 * @param qwsSuiteNotice
	 */
	public static void saveQwsSuiteNotice(QwsSuiteNotice qwsSuiteNotice){
		
		if (qwsSuiteNotice.getIsNewRecord()){
			qwsSuiteNotice.preInsert();
			qwsSuiteNoticeDao.insert(qwsSuiteNotice);
		}else{
			qwsSuiteNotice.preUpdate();
			qwsSuiteNoticeDao.update(qwsSuiteNotice);
		}
	}
}
