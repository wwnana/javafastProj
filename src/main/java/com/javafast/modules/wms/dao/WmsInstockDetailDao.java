/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsInstockDetail;

/**
 * 入库单DAO接口
 * @author javafast
 * @version 2017-07-07
 */
@MyBatisDao
public interface WmsInstockDetailDao extends CrudDao<WmsInstockDetail> {
	
}