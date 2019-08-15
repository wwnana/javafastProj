/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.service.onetomany;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.test.entity.onetomany.TestDataMain;
import com.javafast.modules.test.dao.onetomany.TestDataMainDao;
import com.javafast.modules.test.entity.onetomany.TestDataChild;
import com.javafast.modules.test.dao.onetomany.TestDataChildDao;

/**
 * 订单信息Service
 * @author javafast
 * @version 2017-07-16
 */
@Service
@Transactional(readOnly = true)
public class TestDataMainService extends CrudService<TestDataMainDao, TestDataMain> {

	@Autowired
	private TestDataChildDao testDataChildDao;
	
	public TestDataMain get(String id) {
		TestDataMain testDataMain = super.get(id);
		testDataMain.setTestDataChildList(testDataChildDao.findList(new TestDataChild(testDataMain)));
		return testDataMain;
	}
	
	public List<TestDataMain> findList(TestDataMain testDataMain) {
		return super.findList(testDataMain);
	}
	
	public Page<TestDataMain> findPage(Page<TestDataMain> page, TestDataMain testDataMain) {
		return super.findPage(page, testDataMain);
	}
	
	@Transactional(readOnly = false)
	public void save(TestDataMain testDataMain) {
		//保存主表
		super.save(testDataMain);
		
		//删除明细
		testDataChildDao.delete(new TestDataChild(testDataMain));
		
		//添加明细
		for (TestDataChild testDataChild : testDataMain.getTestDataChildList()){
			
			if(StringUtils.isNotBlank(testDataChild.getId()) && testDataMain.getDelSelectIds()!=null && testDataMain.getDelSelectIds().contains(","+testDataChild.getId()+",")){
				continue;			
			}
			
			testDataChild.setOrder(testDataMain);
			testDataChild.preInsert();
			testDataChildDao.insert(testDataChild);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(TestDataMain testDataMain) {
		super.delete(testDataMain);
		testDataChildDao.delete(new TestDataChild(testDataMain));
	}
	
}