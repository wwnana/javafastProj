/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.scm.entity.ScmProblemType;
import com.javafast.modules.scm.dao.ScmProblemTypeDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 常见问题分类Service
 * @author javafast
 * @version 2017-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScmProblemTypeService extends TreeService<ScmProblemTypeDao, ScmProblemType> {

	public ScmProblemType get(String id) {
		return super.get(id);
	}
	
	public List<ScmProblemType> findList(ScmProblemType scmProblemType) {
		dataScopeFilter(scmProblemType);//加入数据权限过滤
		
		if (StringUtils.isNotBlank(scmProblemType.getParentIds())){
			scmProblemType.setParentIds(","+scmProblemType.getParentIds()+",");
		}
		return super.findList(scmProblemType);
	}
	
	@Transactional(readOnly = false)
	public void save(ScmProblemType scmProblemType) {
		super.save(scmProblemType);
	}
	
	@Transactional(readOnly = false)
	public void delete(ScmProblemType scmProblemType) {
		super.delete(scmProblemType);
	}
	
}