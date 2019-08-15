package com.javafast.modules.test.dao.validation;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.validation.TestValidation;

/**
 * 校验测试表单DAO接口
 * @author javafast
 * @version 2018-07-18
 */
@MyBatisDao
public interface TestValidationDao extends CrudDao<TestValidation> {
	
}