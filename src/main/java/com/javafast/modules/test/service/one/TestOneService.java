package com.javafast.modules.test.service.one;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.test.entity.tree.TestTree;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.test.entity.one.TestOne;
import com.javafast.modules.test.dao.one.TestOneDao;

/**
 * 商品信息(单表)Service
 * @author javafast
 * @version 2018-07-30
 */
@Service
@Transactional(readOnly = true)
public class TestOneService extends CrudService<TestOneDao, TestOne> {

	public TestOne get(String id) {
		return super.get(id);
	}
	
	public List<TestOne> findList(TestOne testOne) {
		return super.findList(testOne);
	}
	
	public Page<TestOne> findPage(Page<TestOne> page, TestOne testOne) {
		return super.findPage(page, testOne);
	}
	
	@Transactional(readOnly = false)
	public void save(TestOne testOne) {
		//文本域转码
		if (testOne.getContent()!=null){
			testOne.setContent(StringEscapeUtils.unescapeHtml4(testOne.getContent()));
		}
		super.save(testOne);
	}
	
	@Transactional(readOnly = false)
	public void delete(TestOne testOne) {
		super.delete(testOne);
	}
	
}