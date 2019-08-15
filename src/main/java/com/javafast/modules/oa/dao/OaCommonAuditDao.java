package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonAudit;

/**
 * 审批流程DAO接口
 */
@MyBatisDao
public interface OaCommonAuditDao extends CrudDao<OaCommonAudit> {
	
}