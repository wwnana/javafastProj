/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsProductType;

/**
 * 产品分类DAO接口
 * @author javafast
 * @version 2017-07-04
 */
@MyBatisDao
public interface WmsProductTypeDao extends TreeDao<WmsProductType> {
	
}