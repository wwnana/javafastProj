package com.javafast.modules.crm.dao;

import com.javafast.modules.crm.entity.CrmCustomer;
import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmDocument;

/**
 * 附件管理DAO接口
 * @author javafast
 * @version 2018-04-27
 */
@MyBatisDao
public interface CrmDocumentDao extends CrudDao<CrmDocument> {
	
	public Long findCount(CrmDocument crmDocument);
}