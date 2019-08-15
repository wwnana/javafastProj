package com.javafast.modules.qw.utils;

import java.util.Date;
import java.util.List;

import com.javafast.common.config.Global;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.message.api.WxMessageAPI;
import com.javafast.api.qywx.message.entity.MessageText;
import com.javafast.api.qywx.message.entity.MessageTextData;
import com.javafast.api.qywx.system.api.WxDepartmentAPI;
import com.javafast.api.qywx.system.api.WxUserAPI;
import com.javafast.api.qywx.system.entity.WxDepartment;
import com.javafast.api.qywx.system.entity.WxUser;
import com.javafast.modules.sys.dao.OfficeDao;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.SysConfigDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.OfficeService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 企业微信工具类
 * @author JavaFast
 */
public class WorkWeixinUtils {

	private static SysConfigDao sysConfigDao = SpringContextHolder.getBean(SysConfigDao.class);
	
	public static final String CACHE_QYWX_ACCESS_TOKEN = "qywx_access_token";
	public static final String CACHE_SYS_CONFIG = "sys_config";
	public static final String ACCOUNT_CACHE_ID_ = "id_";
	
	/**
	 * 获取企业配置信息 (缓存优先)
	 * @return
	 */
	public static SysConfig getSysConfig(String accountId){
		
		//从缓存中获取企业配置信息
		SysConfig sysConfig = (SysConfig) CacheUtils.get(CACHE_SYS_CONFIG, ACCOUNT_CACHE_ID_ + accountId);
		if(sysConfig == null){
			
			//从数据库获取企业配置信息
			sysConfig = sysConfigDao.get(accountId);
			CacheUtils.put(CACHE_SYS_CONFIG, ACCOUNT_CACHE_ID_ + accountId, sysConfig);
		}
		return sysConfig;
	}
	
	/**
	 * 获取企业微信access_token (缓存优先)
	 * @return
	 */
	public static AccessToken getAccessToken(String accountId){
		
		//1.优先从缓存中读取
		AccessToken accessToken = (AccessToken) CacheUtils.get(CACHE_QYWX_ACCESS_TOKEN, ACCOUNT_CACHE_ID_ + accountId);
		if (accessToken != null) {
			//判断缓存中的accessToken是否过期
			if (((DateUtils.getCurrentTimestamp() - accessToken.getTimestamp()) / 1000) < accessToken.getExpiresIn()){
				return accessToken;
			}
		}
		
		//获取企业配置信息
		SysConfig sysConfig = getSysConfig(accountId);
		
		if(sysConfig != null){
			
			//2.从企业微信接口获取企业微信access_token
			accessToken = WxAccessTokenAPI.getAccessToken(sysConfig.getWxCorpid(), sysConfig.getWxCorpsecret());
			if(accessToken != null){
				
				//把信息更新到数据库
				sysConfig.setWxAccessToken(accessToken.getAccessToken());
				sysConfig.setWxExpiresIn(accessToken.getExpiresIn());
				sysConfig.setWxStatus("1");
				sysConfig.setWxTokenDate(new Date());
				accessToken.setWxAgentid(sysConfig.getWxAgentid());
				sysConfigDao.update(sysConfig);
				
				//3.把信息更新到缓存
				CacheUtils.put(CACHE_QYWX_ACCESS_TOKEN, ACCOUNT_CACHE_ID_ + accountId, accessToken);
				CacheUtils.put(CACHE_SYS_CONFIG, ACCOUNT_CACHE_ID_ + accountId, sysConfig);
				return accessToken;
			}
		}		
		
		return null;
	}
	
	
}
