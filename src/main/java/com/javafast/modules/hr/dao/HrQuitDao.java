package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrQuit;

/**
 * 离职DAO接口
 * @author javafast
 * @version 2018-07-06
 */
@MyBatisDao
public interface HrQuitDao extends CrudDao<HrQuit> {
	
}