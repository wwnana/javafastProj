/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.scm.entity.ScmCare;
import com.javafast.modules.scm.dao.ScmCareDao;

/**
 * 客户关怀Service
 * @author javafast
 * @version 2017-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScmCareService extends CrudService<ScmCareDao, ScmCare> {

	public ScmCare get(String id) {
		return super.get(id);
	}
	
	public List<ScmCare> findList(ScmCare scmCare) {
		dataScopeFilter(scmCare);//加入数据权限过滤
		return super.findList(scmCare);
	}
	
	public Page<ScmCare> findPage(Page<ScmCare> page, ScmCare scmCare) {
		dataScopeFilter(scmCare);//加入数据权限过滤
		return super.findPage(page, scmCare);
	}
	
	@Transactional(readOnly = false)
	public void save(ScmCare scmCare) {
		super.save(scmCare);
	}
	
	@Transactional(readOnly = false)
	public void delete(ScmCare scmCare) {
		super.delete(scmCare);
	}
	
}