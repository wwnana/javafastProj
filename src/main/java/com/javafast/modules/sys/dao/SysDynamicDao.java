package com.javafast.modules.sys.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.SysDynamic;

/**
 * 动态DAO接口
 */
@MyBatisDao
public interface SysDynamicDao extends CrudDao<SysDynamic> {
	
}