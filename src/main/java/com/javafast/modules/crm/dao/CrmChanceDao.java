package com.javafast.modules.crm.dao;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmChance;

/**
 * 商机DAO接口
 */
@MyBatisDao
public interface CrmChanceDao extends CrudDao<CrmChance> {

	/**
	 * 查询记录数
	 * @param crmChance
	 * @return
	 */
	public Long findCount(CrmChance crmChance);
}