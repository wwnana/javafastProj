/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.dao.grid;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.grid.TestData;

/**
 * 业务数据DAO接口
 * @author javafast
 * @version 2017-07-21
 */
@MyBatisDao
public interface TestDataDao extends CrudDao<TestData> {
	
}