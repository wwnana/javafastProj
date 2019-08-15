package com.javafast.modules.monitor.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.monitor.entity.Monitor;

/**
 * 系统监控DAO接口
 */
@MyBatisDao
public interface MonitorDao extends CrudDao<Monitor> {
	
}