package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrResumeRecord;

/**
 * 简历权限DAO接口
 * @author javafast
 * @version 2018-07-06
 */
@MyBatisDao
public interface HrResumeRecordDao extends CrudDao<HrResumeRecord> {
	
}