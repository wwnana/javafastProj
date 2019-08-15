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
import com.javafast.modules.crm.entity.CrmCustomer;

/**
 * 客户DAO接口
 */
@MyBatisDao
public interface CrmCustomerDao extends CrudDao<CrmCustomer> {
	
	/**
	 * 查询记录数
	 * @param crmCustomer
	 * @return
	 */
	public Long findCount(CrmCustomer crmCustomer);
	
	/**
	 * 查询回收站客户
	 * @param page
	 * @param crmCustomer
	 * @return
	 */
	public List<CrmCustomer> findDelList(CrmCustomer crmCustomer);
	
	/**
	 * 还原客户
	 * @param crmCustomer
	 */
	public void replay(CrmCustomer crmCustomer);
	
	/**
	 * 更新负责人
	 * @param crmCustomer
	 */
	public void updateOwnBy(CrmCustomer crmCustomer);
	
	/**
	 * 放入公海
	 * @param crmCustomer
	 */
	public void throwToPool(CrmCustomer crmCustomer);
	
	public List<CrmCustomer> findListForExport(CrmCustomer crmCustomer);
	
	/**
	 * 更新客户状态
	 * @param crmCustomer
	 */
	public void updateStatus(CrmCustomer crmCustomer);
	
	/**
	 * 查询超N天未联系的客户
	 * @param accountId
	 * @param dayNum 天
	 * @return
	 */
	public List<CrmCustomer> findOverdueList(@Param("accountId") String accountId, @Param("dayNum") Integer dayNum);
	
	/**
	 * 根据名称获取客户列表
	 * @param accountId
	 * @param name
	 * @param id 原ID，修改时候有值
	 * @return
	 */
	public List<CrmCustomer> findListByCustomerName(@Param("accountId") String accountId, @Param("name") String name, @Param("id") String id);
	
	/**
	 * 查询客户概况统计
	 * @param id
	 * @return
	 */
	public CrmCustomer getGeneralCountByCustomer(@Param("id") String id);
}