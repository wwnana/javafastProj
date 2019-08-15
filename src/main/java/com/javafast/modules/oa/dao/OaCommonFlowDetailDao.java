package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaCommonFlowDetail;

/**
 * 流程配置DAO接口
 */
@MyBatisDao
public interface OaCommonFlowDetailDao extends CrudDao<OaCommonFlowDetail> {
	
}