package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrEmployee;

/**
 * 员工信息DAO接口
 * @author javafast
 * @version 2018-07-03
 */
@MyBatisDao
public interface HrEmployeeDao extends CrudDao<HrEmployee> {
	
}