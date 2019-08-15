package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrEmployee;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrSalaryChange;

/**
 * 调薪DAO接口
 * @author javafast
 * @version 2018-07-05
 */
@MyBatisDao
public interface HrSalaryChangeDao extends CrudDao<HrSalaryChange> {
	
}