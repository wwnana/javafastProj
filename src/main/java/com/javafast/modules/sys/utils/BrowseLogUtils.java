package com.javafast.modules.sys.utils;

import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.sys.service.SysBrowseLogService;


/**
 * 浏览记录工具类
 * @author 1002377
 *
 */
public class BrowseLogUtils {

	private static SysBrowseLogService sysBrowseLogService = SpringContextHolder.getBean(SysBrowseLogService.class);
	
	/**
	 * 
	 * @param targetType 目标类型   1:客户,2：联系人,3：商机，4：报价，5：合同
	 * @param targetId 目标ID
	 * @param targetName 目标名称
	 */
	public static void addBrowseLog(String targetType, String targetId, String targetName){
		
		sysBrowseLogService.add(targetType, targetId, targetName);
	}
}
