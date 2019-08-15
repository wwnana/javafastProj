package com.javafast.modules.oa.dao;

import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaWorkLogRule;

/**
 * 汇报规则DAO接口
 * @author javafast
 * @version 2018-07-17
 */
@MyBatisDao
public interface OaWorkLogRuleDao extends CrudDao<OaWorkLogRule> {
	
}