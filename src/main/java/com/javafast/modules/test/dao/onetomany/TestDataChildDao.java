/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.dao.onetomany;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.onetomany.TestDataChild;

/**
 * 订单信息DAO接口
 * @author javafast
 * @version 2017-07-16
 */
@MyBatisDao
public interface TestDataChildDao extends CrudDao<TestDataChild> {
	
}