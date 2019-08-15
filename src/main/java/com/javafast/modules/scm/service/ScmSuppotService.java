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
import com.javafast.modules.scm.entity.ScmSuppot;
import com.javafast.modules.scm.dao.ScmSuppotDao;

/**
 * 客户服务Service
 * @author javafast
 * @version 2017-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScmSuppotService extends CrudService<ScmSuppotDao, ScmSuppot> {

	public ScmSuppot get(String id) {
		return super.get(id);
	}
	
	public List<ScmSuppot> findList(ScmSuppot scmSuppot) {
		dataScopeFilter(scmSuppot);//加入数据权限过滤
		return super.findList(scmSuppot);
	}
	
	public Page<ScmSuppot> findPage(Page<ScmSuppot> page, ScmSuppot scmSuppot) {
		dataScopeFilter(scmSuppot);//加入数据权限过滤
		return super.findPage(page, scmSuppot);
	}
	
	@Transactional(readOnly = false)
	public void save(ScmSuppot scmSuppot) {
		super.save(scmSuppot);
	}
	
	@Transactional(readOnly = false)
	public void delete(ScmSuppot scmSuppot) {
		super.delete(scmSuppot);
	}
	
}