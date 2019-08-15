package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmContactRecord;

/**
 * 跟进记录DAO接口
 */
@MyBatisDao
public interface CrmContactRecordDao extends CrudDao<CrmContactRecord> {
	
	/**
	 * 查询记录数
	 * @param crmContactRecord
	 * @return
	 */
	public Long findCount(CrmContactRecord crmContactRecord);
}