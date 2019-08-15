package com.javafast.modules.echarts.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.echarts.entity.PieClass;

/**
 * 饼图DAO接口
 */
@MyBatisDao
public interface PieClassDao extends CrudDao<PieClass> {

	
}