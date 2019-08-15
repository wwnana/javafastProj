/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.service.grid;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdGen;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.test.entity.grid.TestData;
import com.javafast.modules.test.dao.grid.TestDataDao;

/**
 * 业务数据Service
 * @author javafast
 * @version 2017-07-21
 */
@Service
@Transactional(readOnly = true)
public class TestDataService extends CrudService<TestDataDao, TestData> {

	public TestData get(String id) {
		return super.get(id);
	}
	
	public List<TestData> findList(TestData testData) {
		return super.findList(testData);
	}
	
	public Page<TestData> findPage(Page<TestData> page, TestData testData) {
		return super.findPage(page, testData);
	}
	
	@Transactional(readOnly = false)
	public void save(TestData testData) {
		super.save(testData);
	}
	
	@Transactional(readOnly = false)
	public void delete(TestData testData) {
		super.delete(testData);
	}

	@Transactional(readOnly = false)
	public void add(TestData testData) {
		
		testData.setId(IdGen.randomLong()+"");
		dao.insert(testData);
	}
	
	public List<TestData> findAllList(){
		return dao.findAllList(new TestData());
	}
}