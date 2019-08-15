/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.kms.dao;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.kms.entity.KmsCategory;

/**
 * 栏目DAO接口
 * @author javafast
 * @version 2017-08-03
 */
@MyBatisDao
public interface KmsCategoryDao extends TreeDao<KmsCategory> {
	
}