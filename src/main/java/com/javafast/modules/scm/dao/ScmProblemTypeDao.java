/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.dao;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.scm.entity.ScmProblemType;

/**
 * 常见问题分类DAO接口
 * @author javafast
 * @version 2017-08-18
 */
@MyBatisDao
public interface ScmProblemTypeDao extends TreeDao<ScmProblemType> {
	
}