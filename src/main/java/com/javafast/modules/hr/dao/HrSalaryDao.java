package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrSalary;

/**
 * 工资表DAO接口
 * @author javafast
 * @version 2018-07-05
 */
@MyBatisDao
public interface HrSalaryDao extends CrudDao<HrSalary> {
	
}