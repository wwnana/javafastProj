package com.javafast.modules.gen.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.gen.entity.GenTable;

/**
 * 业务表DAO接口
 */
@MyBatisDao
public interface GenTableDao extends CrudDao<GenTable> {
	
}
