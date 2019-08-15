package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrSalaryDetail;

/**
 * 工资表DAO接口
 * @author javafast
 * @version 2018-07-05
 */
@MyBatisDao
public interface HrSalaryDetailDao extends CrudDao<HrSalaryDetail> {
	
}