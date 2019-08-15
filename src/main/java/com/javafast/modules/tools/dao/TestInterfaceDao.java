package com.javafast.modules.tools.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.tools.entity.TestInterface;

/**
 * 接口DAO接口
 */
@MyBatisDao
public interface TestInterfaceDao extends CrudDao<TestInterface> {
	
}