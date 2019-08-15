/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.dao;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.wms.entity.WmsAllotDetail;

/**
 * 调拨单DAO接口
 * @author javafast
 * @version 2018-01-11
 */
@MyBatisDao
public interface WmsAllotDetailDao extends CrudDao<WmsAllotDetail> {
	
}