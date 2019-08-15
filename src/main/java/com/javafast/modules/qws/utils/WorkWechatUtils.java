package com.javafast.modules.qws.utils;

import org.apache.commons.lang3.StringUtils;

import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywxs.core.api.WxCorpAccessTokenAPI;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 在第三方应用企业工具 （第三方）
 * @author syh
 *
 */
public class WorkWechatUtils {

	// 企业access_token 缓存名称
	public static final String CACHE_WORK_WECHAT_ACCESS_TOKEN = "work_wechat_access_token";
	public static final String CACHE_ACCOUNT_ID_ = "account_id_";
	
	private static SysAccountDao sysAccountDao = SpringContextHolder.getBean(SysAccountDao.class);
	
	/**
	 * 根据企业编号获取AccessToken
	 * @param accountId
	 * @return
	 */
	public static AccessToken getAccessToken(String accountId) {

		//1.优先从缓存中读取
		AccessToken accessToken = (AccessToken) CacheUtils.get(CACHE_WORK_WECHAT_ACCESS_TOKEN, CACHE_ACCOUNT_ID_ + accountId);
		if (accessToken != null) {
			//判断缓存中的accessToken是否过期
			if (((DateUtils.getCurrentTimestamp() - accessToken.getTimestamp()) / 1000) < accessToken.getExpiresIn()){
				return accessToken;
			}
		}
		
		SysAccount sysAccount = sysAccountDao.get(accountId);
		if(sysAccount != null && StringUtils.isNotBlank(sysAccount.getCorpid())){
			
			// 2.从企业微信接口获取企业微信access_token
			AccessToken suiteAccessToken = SuiteUtils.getSuiteAccessToken();
			if (suiteAccessToken != null && StringUtils.isNotBlank(suiteAccessToken.getAccessToken()) ) {
				accessToken = WxCorpAccessTokenAPI.getCorpAccessToken(suiteAccessToken.getAccessToken(), sysAccount.getCorpid(), sysAccount.getPermanentCode());
				if (accessToken != null) {

					//3.加入缓存
					CacheUtils.put(CACHE_WORK_WECHAT_ACCESS_TOKEN, CACHE_ACCOUNT_ID_ + accountId, accessToken);
				}
			}			
		}

		return accessToken;
	}
}
