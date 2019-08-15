/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.scm.entity.ScmProblem;

/**
 * 常见问题DAO接口
 * @author javafast
 * @version 2017-08-18
 */
@MyBatisDao
public interface ScmProblemDao extends CrudDao<ScmProblem> {
	
}