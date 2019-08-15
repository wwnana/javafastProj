package com.javafast.modules.crm.dao;

import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmQuoteDetail;

/**
 * 报价单DAO接口
 */
@MyBatisDao
public interface CrmQuoteDetailDao extends CrudDao<CrmQuoteDetail> {
	
}