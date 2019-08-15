package com.javafast.modules.oa.service;

import java.util.List;

import com.javafast.modules.sys.entity.User;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.entity.OaWorkLogRule;
import com.javafast.modules.oa.dao.OaWorkLogRuleDao;

/**
 * 汇报规则Service
 * @author javafast
 * @version 2018-07-17
 */
@Service
@Transactional(readOnly = true)
public class OaWorkLogRuleService extends CrudService<OaWorkLogRuleDao, OaWorkLogRule> {

	public OaWorkLogRule get(String id) {
		return super.get(id);
	}
	
	public List<OaWorkLogRule> findList(OaWorkLogRule oaWorkLogRule) {
		dataScopeFilter(oaWorkLogRule);//加入权限过滤
		return super.findList(oaWorkLogRule);
	}
	
	public Page<OaWorkLogRule> findPage(Page<OaWorkLogRule> page, OaWorkLogRule oaWorkLogRule) {
		dataScopeFilter(oaWorkLogRule);//加入权限过滤
		return super.findPage(page, oaWorkLogRule);
	}
	
	@Transactional(readOnly = false)
	public void save(OaWorkLogRule oaWorkLogRule) {
		super.save(oaWorkLogRule);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaWorkLogRule oaWorkLogRule) {
		super.delete(oaWorkLogRule);
	}
	
}