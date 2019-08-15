/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsPurchase;

/**
 * 采购单DAO接口
 * @author javafast
 * @version 2017-07-07
 */
@MyBatisDao
public interface WmsPurchaseDao extends CrudDao<WmsPurchase> {
	
}