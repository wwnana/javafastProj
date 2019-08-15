/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.dao.onetomany;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.User;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.onetomany.TestDataMain;

/**
 * 订单信息DAO接口
 * @author javafast
 * @version 2017-07-16
 */
@MyBatisDao
public interface TestDataMainDao extends CrudDao<TestDataMain> {
	
}