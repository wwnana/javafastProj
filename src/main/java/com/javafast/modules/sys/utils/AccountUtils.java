package com.javafast.modules.sys.utils;

import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.sys.dao.SysConfigDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.service.SysAccountService;

public class AccountUtils {

	private static SysAccountService sysAccountService = SpringContextHolder.getBean(SysAccountService.class);
	
	private static SysConfigDao sysConfigDao = SpringContextHolder.getBean(SysConfigDao.class);
	
	/**
	 * 校验
	 * @param accountId
	 * @param apiSecret
	 * @return
	 */
	public static boolean checkKeySecret(String accountId, String apiSecret){
		
		SysAccount sysAccount = sysAccountService.get(accountId);
		if(sysAccount != null){
			
			if(apiSecret.equals(sysAccount.getApiSecret())){
				
				return true;
			}
		}
				
		return false;
	}
	
	/**
	 * 获取当前用户配置
	 * @param accountId
	 * @return
	 */
	public static SysConfig getSysConfig(String accountId){
		
		SysConfig sysConfig = sysConfigDao.get(accountId);
		if(sysConfig != null){
			return sysConfig;
		}
		return null;
	}
}
