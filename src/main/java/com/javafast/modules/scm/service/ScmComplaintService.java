/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.scm.entity.ScmComplaint;
import com.javafast.modules.scm.dao.ScmComplaintDao;

/**
 * 客户投诉Service
 * @author javafast
 * @version 2017-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScmComplaintService extends CrudService<ScmComplaintDao, ScmComplaint> {

	public ScmComplaint get(String id) {
		return super.get(id);
	}
	
	public List<ScmComplaint> findList(ScmComplaint scmComplaint) {
		dataScopeFilter(scmComplaint);//加入数据权限过滤
		return super.findList(scmComplaint);
	}
	
	public Page<ScmComplaint> findPage(Page<ScmComplaint> page, ScmComplaint scmComplaint) {
		dataScopeFilter(scmComplaint);//加入数据权限过滤
		return super.findPage(page, scmComplaint);
	}
	
	@Transactional(readOnly = false)
	public void save(ScmComplaint scmComplaint) {
		super.save(scmComplaint);
	}
	
	@Transactional(readOnly = false)
	public void delete(ScmComplaint scmComplaint) {
		super.delete(scmComplaint);
	}
	
}