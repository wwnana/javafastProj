/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.om.dao;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.om.entity.OmContract;

/**
 * 合同DAO接口
 * @author javafast
 * @version 2017-07-13
 */
@MyBatisDao
public interface OmContractDao extends CrudDao<OmContract> {
	
	/**
	 * 查询记录数
	 * @param omContract
	 * @return
	 */
	public Long findCount(OmContract omContract);
}