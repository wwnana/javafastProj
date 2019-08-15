package com.javafast.modules.oa.dao;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonBorrow;

/**
 * 借款单DAO接口
 */
@MyBatisDao
public interface OaCommonBorrowDao extends CrudDao<OaCommonBorrow> {
	
}