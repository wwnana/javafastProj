package com.javafast.modules.oa.dao;

import com.javafast.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaTaskRecord;

/**
 * 任务DAO接口
 */
@MyBatisDao
public interface OaTaskRecordDao extends CrudDao<OaTaskRecord> {
	
}