package com.javafast.modules.oa.dao;

import java.math.BigDecimal;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonExpense;

/**
 * 报销单DAO接口
 */
@MyBatisDao
public interface OaCommonExpenseDao extends CrudDao<OaCommonExpense> {
	
}