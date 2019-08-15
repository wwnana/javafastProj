package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrRecruit;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrResume;

/**
 * 简历DAO接口
 * @author javafast
 * @version 2018-06-29
 */
@MyBatisDao
public interface HrResumeDao extends CrudDao<HrResume> {
	
}