package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProjectRecord;

/**
 * 项目DAO接口
 * @author javafast
 * @version 2018-05-18
 */
@MyBatisDao
public interface OaProjectRecordDao extends CrudDao<OaProjectRecord> {
	
}