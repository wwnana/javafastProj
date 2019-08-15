package com.javafast.modules.report.dao;

import org.apache.ibatis.annotations.Param;

import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.report.entity.CrmDataOwn;

@MyBatisDao
public interface CrmDataOwnDao {

	public void updateClueDataOwnBy(CrmDataOwn crmDataOwn);
	
	//
	public void updateCustomerDataOwnBy(CrmDataOwn crmDataOwn);
	
	public void updateContacterDataOwnBy(CrmDataOwn crmDataOwn);
	
	public void updateChanceDataOwnBy(CrmDataOwn crmDataOwn);
	
	public void updateQuoteDataOwnBy(CrmDataOwn crmDataOwn);
	
	public void updateContractDataOwnBy(CrmDataOwn crmDataOwn);
}
