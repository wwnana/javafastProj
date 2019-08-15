package com.javafast.modules.test.service.validation;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.test.entity.validation.TestValidation;
import com.javafast.modules.test.dao.validation.TestValidationDao;

/**
 * 校验测试表单Service
 * @author javafast
 * @version 2018-07-18
 */
@Service
@Transactional(readOnly = true)
public class TestValidationService extends CrudService<TestValidationDao, TestValidation> {

	public TestValidation get(String id) {
		return super.get(id);
	}
	
	public List<TestValidation> findList(TestValidation testValidation) {
		return super.findList(testValidation);
	}
	
	public Page<TestValidation> findPage(Page<TestValidation> page, TestValidation testValidation) {
		return super.findPage(page, testValidation);
	}
	
	@Transactional(readOnly = false)
	public void save(TestValidation testValidation) {
		super.save(testValidation);
	}
	
	@Transactional(readOnly = false)
	public void delete(TestValidation testValidation) {
		super.delete(testValidation);
	}
	
}