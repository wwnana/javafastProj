package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonExpenseDetail;

/**
 * 报销单DAO接口
 */
@MyBatisDao
public interface OaCommonExpenseDetailDao extends CrudDao<OaCommonExpenseDetail> {
	
}