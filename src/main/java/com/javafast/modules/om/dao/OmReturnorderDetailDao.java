/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.om.dao;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.om.entity.OmReturnorderDetail;

/**
 * 销售退单DAO接口
 * @author javafast
 * @version 2017-07-08
 */
@MyBatisDao
public interface OmReturnorderDetailDao extends CrudDao<OmReturnorderDetail> {
	
}