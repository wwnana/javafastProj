package com.javafast.modules.crm.dao;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;

/**
 * 联系人DAO接口
 */
@MyBatisDao
public interface CrmContacterDao extends CrudDao<CrmContacter> {

	/**
	 * 查询记录数
	 * @param crmContacter
	 * @return
	 */
	public Long findCount(CrmContacter crmContacter);
	
	/**
	 * 更新所有者和所有者部门信息
	 * @param crmContacter
	 */
	public void updateOwnBy(CrmContacter crmContacter);
	
	/**
	 * 更新客户下面的联系人为非首要
	 * @param crmContacter
	 */
	public void updateNotDefault(CrmContacter crmContacter);
	
	/**
	 * 放入公海
	 * @param crmContacter
	 */
	public void throwToPool(CrmContacter crmContacter);
	
}