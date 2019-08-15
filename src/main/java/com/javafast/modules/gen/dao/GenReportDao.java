package com.javafast.modules.gen.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.gen.entity.GenReport;

/**
 * 图表配置DAO接口
 */
@MyBatisDao
public interface GenReportDao extends CrudDao<GenReport> {
	
	public List<Map<String, Object>> findBySql(GenReport genReport);
}