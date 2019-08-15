package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaTopicRecord;

/**
 * 话题DAO接口
 * @author javafast
 * @version 2018-06-12
 */
@MyBatisDao
public interface OaTopicRecordDao extends CrudDao<OaTopicRecord> {
	
}