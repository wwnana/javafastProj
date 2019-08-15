package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmInvoice;

/**
 * 开票信息DAO接口
 */
@MyBatisDao
public interface CrmInvoiceDao extends CrudDao<CrmInvoice> {
	
}