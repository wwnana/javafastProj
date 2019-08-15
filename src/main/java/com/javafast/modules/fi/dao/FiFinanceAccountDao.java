/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.fi.entity.FiFinanceAccount;

/**
 * 结算账户DAO接口
 * @author javafast
 * @version 2017-07-07
 */
@MyBatisDao
public interface FiFinanceAccountDao extends CrudDao<FiFinanceAccount> {
	
	/**
	 * 获取行锁记录
	 * @param fiFinanceAccount
	 * @return
	 */
	public FiFinanceAccount getFiFinanceAccountForUpdate(FiFinanceAccount fiFinanceAccount);
	
	/**
	 * 更新余额
	 * @param fiFinanceAccount
	 */
	public void updateBalance(FiFinanceAccount fiFinanceAccount);
	
	/**
	 * 更新默认数据
	 * @param fiFinanceAccount
	 */
	public void updateDefaultData(FiFinanceAccount fiFinanceAccount);
}