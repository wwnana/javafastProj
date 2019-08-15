package com.javafast.modules.crm.dao;

import java.util.List;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmCustomerType;

/**
 * 客户分类DAO接口
 */
@MyBatisDao
public interface CrmCustomerTypeDao extends TreeDao<CrmCustomerType> {
	
	public List<CrmCustomerType> findOneList(CrmCustomerType crmCustomerType);
}