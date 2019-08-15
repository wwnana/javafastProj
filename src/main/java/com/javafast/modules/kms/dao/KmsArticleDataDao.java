/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.kms.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.kms.entity.KmsArticleData;

/**
 * 知识详情DAO接口
 * @author javafast
 * @version 2017-08-03
 */
@MyBatisDao
public interface KmsArticleDataDao extends CrudDao<KmsArticleData> {
	
}