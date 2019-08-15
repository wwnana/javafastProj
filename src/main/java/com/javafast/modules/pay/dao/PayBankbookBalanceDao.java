package com.javafast.modules.pay.dao;

import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.pay.entity.PayBankbookBalance;

/**
 * 电子钱包余额DAO接口
 * @author javafast
 * @version 2018-05-15
 */
@MyBatisDao
public interface PayBankbookBalanceDao extends CrudDao<PayBankbookBalance> {
	
	/**
	 * 行锁查询
	 * @param payBankbookBalance
	 * @return
	 */
	public PayBankbookBalance getPayBankbookBalanceForUpdate(PayBankbookBalance payBankbookBalance);
}