package com.javafast.modules.hr.dao;

import com.javafast.modules.sys.entity.Office;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrPositionChange;

/**
 * 调岗DAO接口
 * @author javafast
 * @version 2018-07-05
 */
@MyBatisDao
public interface HrPositionChangeDao extends CrudDao<HrPositionChange> {
	
}