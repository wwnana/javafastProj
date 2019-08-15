/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.scm.entity.ScmProblem;
import com.javafast.modules.scm.dao.ScmProblemDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 常见问题Service
 * @author javafast
 * @version 2017-08-18
 */
@Service
@Transactional(readOnly = true)
public class ScmProblemService extends CrudService<ScmProblemDao, ScmProblem> {

	public ScmProblem get(String id) {
		return super.get(id);
	}
	
	public List<ScmProblem> findList(ScmProblem scmProblem) {
		dataScopeFilter(scmProblem);//加入数据权限过滤
		return super.findList(scmProblem);
	}
	
	public Page<ScmProblem> findPage(Page<ScmProblem> page, ScmProblem scmProblem) {
		dataScopeFilter(scmProblem);//加入数据权限过滤
		return super.findPage(page, scmProblem);
	}
	
	@Transactional(readOnly = false)
	public void save(ScmProblem scmProblem) {
		//文本域转码
		if (StringUtils.isNotBlank(scmProblem.getContent())){
			scmProblem.setContent(StringEscapeUtils.unescapeHtml4(scmProblem.getContent()));
		}	
		super.save(scmProblem);
	}
	
	@Transactional(readOnly = false)
	public void delete(ScmProblem scmProblem) {
		super.delete(scmProblem);
	}
	
}