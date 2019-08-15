package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaWorkLog;

/**
 * 工作报告DAO接口
 * @author javafast
 * @version 2018-05-03
 */
@MyBatisDao
public interface OaWorkLogDao extends CrudDao<OaWorkLog> {
	
}