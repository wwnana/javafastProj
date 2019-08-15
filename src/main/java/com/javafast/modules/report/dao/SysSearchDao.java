package com.javafast.modules.report.dao;

import java.util.List;

import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.report.entity.SysSearch;

/**
 * 全局搜索DAO接口
 * @author shi
 * @version 2016-06-28
 */
@MyBatisDao
public interface SysSearchDao {

	/**
	 * 搜索
	 * @param sysSearch
	 * @return
	 */
	public List<SysSearch> findList(SysSearch sysSearch);
	
}