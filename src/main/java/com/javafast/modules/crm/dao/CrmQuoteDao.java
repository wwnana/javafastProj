package com.javafast.modules.crm.dao;

import javax.validation.constraints.NotNull;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmQuote;

/**
 * 报价单DAO接口
 */
@MyBatisDao
public interface CrmQuoteDao extends CrudDao<CrmQuote> {
	
	/**
	 * 查询记录数
	 * @param crmQuote
	 * @return
	 */
	public Long findCount(CrmQuote crmQuote);
}