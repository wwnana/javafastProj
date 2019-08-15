/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;


import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsProductData;

/**
 * 产品详情表DAO接口
 * @author javafast
 * @version 2017-10-24
 */
@MyBatisDao
public interface WmsProductDataDao extends CrudDao<WmsProductData> {
	
}