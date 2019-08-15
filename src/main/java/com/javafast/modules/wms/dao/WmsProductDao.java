/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsProduct;

/**
 * 产品DAO接口
 * @author javafast
 * @version 2017-07-04
 */
@MyBatisDao
public interface WmsProductDao extends CrudDao<WmsProduct> {
	
}