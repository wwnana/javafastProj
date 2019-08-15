package com.javafast.modules.oa.dao;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonLeave;

/**
 * 请假单DAO接口
 */
@MyBatisDao
public interface OaCommonLeaveDao extends CrudDao<OaCommonLeave> {
	
}