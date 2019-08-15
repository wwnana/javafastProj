/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.oa.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.entity.OaNote;
import com.javafast.modules.oa.dao.OaNoteDao;

/**
 * 便签Service
 * @author javafast
 * @version 2017-07-16
 */
@Service
@Transactional(readOnly = true)
public class OaNoteService extends CrudService<OaNoteDao, OaNote> {

	public OaNote get(String id) {
		return super.get(id);
	}
	
	public List<OaNote> findList(OaNote oaNote) {
		return super.findList(oaNote);
	}
	
	public Page<OaNote> findPage(Page<OaNote> page, OaNote oaNote) {
		return super.findPage(page, oaNote);
	}
	
	@Transactional(readOnly = false)
	public void save(OaNote oaNote) {
		dao.insert(oaNote);
	}
	
	@Transactional(readOnly = false)
	public void update(OaNote oaNote) {
		dao.update(oaNote);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaNote oaNote) {
		super.delete(oaNote);
	}
	
}