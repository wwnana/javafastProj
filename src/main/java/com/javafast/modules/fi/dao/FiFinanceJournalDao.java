/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.fi.entity.FiFinanceJournal;

/**
 * 资金流水DAO接口
 * @author javafast
 * @version 2017-07-16
 */
@MyBatisDao
public interface FiFinanceJournalDao extends CrudDao<FiFinanceJournal> {
	
}