/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.dao;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.fi.entity.FiReceiveAble;

/**
 * 应收款DAO接口
 * @author javafast
 * @version 2017-07-14
 */
@MyBatisDao
public interface FiReceiveAbleDao extends CrudDao<FiReceiveAble> {
	
	/**
	 * 查询记录数
	 * @param fiReceiveAble
	 * @return
	 */
	public Long findCount(FiReceiveAble fiReceiveAble);
}