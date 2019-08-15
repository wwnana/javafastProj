package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrRecruit;

/**
 * 招聘任务DAO接口
 * @author javafast
 * @version 2018-06-29
 */
@MyBatisDao
public interface HrRecruitDao extends CrudDao<HrRecruit> {
	
}