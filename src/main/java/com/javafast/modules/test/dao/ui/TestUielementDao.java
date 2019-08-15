/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.dao.ui;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.ui.TestUielement;

/**
 * UI标签DAO接口
 * @author javafast
 * @version 2017-08-22
 */
@MyBatisDao
public interface TestUielementDao extends CrudDao<TestUielement> {
	
}