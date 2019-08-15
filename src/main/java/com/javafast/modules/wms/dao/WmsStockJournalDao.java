/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsStockJournal;

/**
 * 库存流水DAO接口
 * @author javafast
 * @version 2017-07-05
 */
@MyBatisDao
public interface WmsStockJournalDao extends CrudDao<WmsStockJournal> {
	
}