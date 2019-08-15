package com.javafast.modules.gen.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.gen.entity.GenReportColumn;

/**
 * 图表配置DAO接口
 */
@MyBatisDao
public interface GenReportColumnDao extends CrudDao<GenReportColumn> {
	
}