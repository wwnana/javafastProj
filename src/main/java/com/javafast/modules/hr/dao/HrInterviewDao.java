package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrInterview;

/**
 * 面试DAO接口
 * @author javafast
 * @version 2018-06-29
 */
@MyBatisDao
public interface HrInterviewDao extends CrudDao<HrInterview> {
	
}