package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonFlow;

/**
 * 流程配置DAO接口
 */
@MyBatisDao
public interface OaCommonFlowDao extends CrudDao<OaCommonFlow> {
	
}