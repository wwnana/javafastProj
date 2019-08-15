/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.entity.FiFinanceJournal;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.fi.dao.FiFinanceAccountDao;
import com.javafast.modules.fi.dao.FiFinanceJournalDao;

/**
 * 资金流水Service
 * @author javafast
 * @version 2017-07-16
 */
@Service
@Transactional(readOnly = true)
public class FiFinanceJournalService extends CrudService<FiFinanceJournalDao, FiFinanceJournal> {

	@Autowired
	FiFinanceAccountDao fiFinanceAccountDao;
	
	public FiFinanceJournal get(String id) {
		return super.get(id);
	}
	
	public List<FiFinanceJournal> findList(FiFinanceJournal fiFinanceJournal) {
		dataScopeFilter(fiFinanceJournal);//加入数据权限过滤
		return super.findList(fiFinanceJournal);
	}
	
	public Page<FiFinanceJournal> findPage(Page<FiFinanceJournal> page, FiFinanceJournal fiFinanceJournal) {
		dataScopeFilter(fiFinanceJournal);//加入数据权限过滤
		return super.findPage(page, fiFinanceJournal);
	}
	
	@Transactional(readOnly = false)
	public void save(FiFinanceJournal fiFinanceJournal) {
		super.save(fiFinanceJournal);
	}
	
	@Transactional(readOnly = false)
	public void delete(FiFinanceJournal fiFinanceJournal) {
		super.delete(fiFinanceJournal);
	}
	
	/**
	 * 存入
	 * @param fiAccountId 账户ID
	 * @param moneyType 资金类别  10.存款，20：提款，30：销售订单收入，35：采购退货收入，40：采购支出，45：销售退货支出
	 * @param money 交易金额
	 * @param notes 摘要
	 * @param uniqueCode 唯一码
	 * @param operateUser 操作人
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	public void saveDeposit(String fiAccountId, String moneyType, BigDecimal money, String notes, String uniqueCode, User operateUser) throws Exception {
		
		//1.账户行锁
		FiFinanceAccount fiFinanceAccount = fiFinanceAccountDao.getFiFinanceAccountForUpdate(new FiFinanceAccount(fiAccountId));
		if(fiFinanceAccount == null){
			throw new Exception("账户不存在");
		}
		
		//2.计算交易后的余额 = 账户余额+存入金额
		BigDecimal balance = fiFinanceAccount.getBalance().add(money);
		
		//3.创建交易明细
		FiFinanceJournal tempFiFinanceJournal = dao.findUniqueByProperty("unique_code", uniqueCode);
		if(tempFiFinanceJournal != null){
			throw new Exception("重复交易");
		}
		
		FiFinanceJournal fiFinanceJournal = new FiFinanceJournal();
		fiFinanceJournal.setFiaccount(fiFinanceAccount);
		fiFinanceJournal.setDealType("A");
		fiFinanceJournal.setDealDate(new Date());
		fiFinanceJournal.setMoneyType(moneyType);
		fiFinanceJournal.setMoney(money);
		fiFinanceJournal.setBalance(balance);
		fiFinanceJournal.setNotes(notes);
		fiFinanceJournal.setUniqueCode(uniqueCode);		
		fiFinanceJournal.setCreateBy(operateUser);
		fiFinanceJournal.setCreateDate(new Date());		
		fiFinanceJournal.setId(IdUtils.getId());
		fiFinanceJournal.setAccountId(fiFinanceAccount.getAccountId());
		dao.insert(fiFinanceJournal);
		
		//4.修改账户余额
		fiFinanceAccount.setBalance(balance);
		fiFinanceAccountDao.updateBalance(fiFinanceAccount);
	}
	
	/**
	 * 取出
	 * @param fiAccountId 账户ID
	 * @param moneyType 资金类别
	 * @param money 交易金额
	 * @param notes 摘要
	 * @param uniqueCode 唯一码
	 * @param operateUser 操作人
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	public void saveWithdraw(String fiAccountId, String moneyType, BigDecimal money, String notes, String uniqueCode, User operateUser) throws Exception {
		
		//1.账户行锁
		FiFinanceAccount fiFinanceAccount = fiFinanceAccountDao.getFiFinanceAccountForUpdate(new FiFinanceAccount(fiAccountId));
		if(fiFinanceAccount == null){
			throw new Exception("账户不存在");
		}
		
		//2.判断余额是否足够
		if(fiFinanceAccount.getBalance().compareTo(money) == -1){
			throw new Exception("账户余额不足");
		}
		
		//2.计算交易后的余额 = 账户余额 - 取出金额
		BigDecimal balance = fiFinanceAccount.getBalance().subtract(money);
		
		//3.创建交易明细
		FiFinanceJournal tempFiFinanceJournal = dao.findUniqueByProperty("unique_code", uniqueCode);
		if(tempFiFinanceJournal != null){
			throw new Exception("重复交易");
		}
		
		FiFinanceJournal fiFinanceJournal = new FiFinanceJournal();
		fiFinanceJournal.setFiaccount(fiFinanceAccount);
		fiFinanceJournal.setDealType("D");
		fiFinanceJournal.setDealDate(new Date());
		fiFinanceJournal.setMoneyType(moneyType);
		fiFinanceJournal.setMoney(money);
		fiFinanceJournal.setBalance(balance);
		fiFinanceJournal.setNotes(notes);
		fiFinanceJournal.setUniqueCode(uniqueCode);		
		fiFinanceJournal.setCreateBy(operateUser);
		fiFinanceJournal.setCreateDate(new Date());		
		fiFinanceJournal.setId(IdUtils.getId());
		fiFinanceJournal.setAccountId(fiFinanceAccount.getAccountId());
		dao.insert(fiFinanceJournal);
		
		//4.修改账户余额
		fiFinanceAccount.setBalance(balance);
		fiFinanceAccountDao.updateBalance(fiFinanceAccount);
	}
}