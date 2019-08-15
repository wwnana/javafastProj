/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.om.dao;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.om.entity.OmOrderDetail;

/**
 * 销售订单DAO接口
 * @author javafast
 * @version 2017-07-14
 */
@MyBatisDao
public interface OmOrderDetailDao extends CrudDao<OmOrderDetail> {
	
}