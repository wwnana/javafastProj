/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.test.service.ui;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.hibernate.validator.constraints.Length;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.test.entity.ui.TestUielement;
import com.javafast.modules.test.dao.ui.TestUielementDao;

/**
 * UI标签Service
 * @author javafast
 * @version 2017-08-22
 */
@Service
@Transactional(readOnly = true)
public class TestUielementService extends CrudService<TestUielementDao, TestUielement> {

	public TestUielement get(String id) {
		return super.get(id);
	}
	
	public List<TestUielement> findList(TestUielement testUielement) {
		return super.findList(testUielement);
	}
	
	public Page<TestUielement> findPage(Page<TestUielement> page, TestUielement testUielement) {
		return super.findPage(page, testUielement);
	}
	
	@Transactional(readOnly = false)
	public void save(TestUielement testUielement) {
		//文本域转码
		if (testUielement.getContent()!=null){
			testUielement.setContent(StringEscapeUtils.unescapeHtml4(testUielement.getContent()));
		}
		super.save(testUielement);
	}
	
	@Transactional(readOnly = false)
	public void delete(TestUielement testUielement) {
		super.delete(testUielement);
	}
	
}