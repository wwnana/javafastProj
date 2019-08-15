package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaTopic;

/**
 * 话题DAO接口
 * @author javafast
 * @version 2018-06-12
 */
@MyBatisDao
public interface OaTopicDao extends CrudDao<OaTopic> {
	
}