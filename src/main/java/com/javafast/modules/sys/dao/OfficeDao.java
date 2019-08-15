package com.javafast.modules.sys.dao;

import java.util.List;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.Office;

/**
 * 机构DAO接口
 */
@MyBatisDao
public interface OfficeDao extends TreeDao<Office> {
	
	public Office getByCode(String code);
	
	public List<Office> findOfficeList(Office office);
}
