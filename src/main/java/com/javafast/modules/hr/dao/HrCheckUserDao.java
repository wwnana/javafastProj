package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrCheckUser;

/**
 * 打卡规则用户DAO接口
 * @author javafast
 * @version 2018-07-08
 */
@MyBatisDao
public interface HrCheckUserDao extends CrudDao<HrCheckUser> {
	
}