/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsStock;

/**
 * 产品库存DAO接口
 * @author javafast
 * @version 2017-07-05
 */
@MyBatisDao
public interface WmsStockDao extends CrudDao<WmsStock> {
	
	public List<WmsStock> getProductStock(WmsStock wmsStock);
	
	public List<WmsStock> findWarnList(WmsStock wmsStock);
}