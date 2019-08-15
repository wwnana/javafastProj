package com.javafast.modules.pay.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.pay.util.BankbookConstants;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.pay.entity.PayBankbookBalance;
import com.javafast.modules.pay.entity.PayBankbookJournal;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.pay.dao.PayBankbookBalanceDao;
import com.javafast.modules.pay.dao.PayBankbookJournalDao;

/**
 * 电子钱包交易明细Service
 * @author javafast
 * @version 2018-05-15
 */
@Service
@Transactional(readOnly = true)
public class PayBankbookJournalService extends CrudService<PayBankbookJournalDao, PayBankbookJournal> {

	@Autowired
	PayBankbookBalanceDao payBankbookBalanceDao;
	
	public PayBankbookJournal get(String id) {
		return super.get(id);
	}
	
	public List<PayBankbookJournal> findList(PayBankbookJournal payBankbookJournal) {
		return super.findList(payBankbookJournal);
	}
	
	public Page<PayBankbookJournal> findPage(Page<PayBankbookJournal> page, PayBankbookJournal payBankbookJournal) {
		return super.findPage(page, payBankbookJournal);
	}
	
	@Transactional(readOnly = false)
	public void save(PayBankbookJournal payBankbookJournal) {
		super.save(payBankbookJournal);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayBankbookJournal payBankbookJournal) {
		super.delete(payBankbookJournal);
	}
	
	/**
	 * 存入
	 * @param money 交易金额
	 * @param moneyType 资金类别
	 * @param notes 摘要
	 * @param uniqueCode 交易唯一订单号
	 * @param createBy 操作人
	 * @param accountId 账号
	 * @return
	 */
	@Transactional(readOnly = false)
	public String PayBankbookDeposit(BigDecimal money, String moneyType, String notes, String uniqueCode, User createBy, String accountId){
		
		if(money.compareTo(BigDecimal.ZERO) == -1 || money.compareTo(BigDecimal.ZERO) == 0){
			return BankbookConstants.ERROR_CODE101;
		}
		
		PayBankbookJournal tempPayBankbookJournal = dao.findUniqueByProperty("unique_code", uniqueCode);
		if(tempPayBankbookJournal != null){
			return BankbookConstants.ERROR_CODE102;
		}
		
		//行锁查询
		PayBankbookBalance payBankbookBalance = payBankbookBalanceDao.getPayBankbookBalanceForUpdate(new PayBankbookBalance(accountId));
		
		if(payBankbookBalance == null){
			return BankbookConstants.ERROR_CODE103;
		}
		
		//计算 余额 = 当前余额  + 交易金额
		BigDecimal balance = payBankbookBalance.getBalance().add(money);
		
		//创建明细
		PayBankbookJournal payBankbookJournal = new PayBankbookJournal();
		payBankbookJournal.setId(IdUtils.getId());
		payBankbookJournal.setDealDate(new Date());
		payBankbookJournal.setDealType("A");
		payBankbookJournal.setMoney(money);
		payBankbookJournal.setMoneyType(moneyType);
		payBankbookJournal.setRemarks(notes);
		payBankbookJournal.setBalance(balance);
		payBankbookJournal.setUniqueCode(uniqueCode);
		payBankbookJournal.setCreateBy(createBy);
		payBankbookJournal.setCreateDate(new Date());
		payBankbookJournal.setAccountId(accountId);
		dao.insert(payBankbookJournal);
		
		//更新余额
		payBankbookBalance.setBalance(balance);
		payBankbookBalanceDao.update(payBankbookBalance);
		return BankbookConstants.SUCCESS_CODE0;
	}
	
	/**
	 * 支出
	 * @param money 交易金额
	 * @param moneyType 资金类别
	 * @param notes 摘要
	 * @param uniqueCode 交易唯一订单号
	 * @param createBy 操作人
	 * @param accountId 账号
	 * @return
	 */
	@Transactional(readOnly = false)
	public String PayBankbookWithdraw(BigDecimal money, String moneyType, String notes, String uniqueCode, User createBy, String accountId){
			
		if(money.compareTo(BigDecimal.ZERO) == -1 || money.compareTo(BigDecimal.ZERO) == 0){
			return BankbookConstants.ERROR_CODE101;
		}
		
		PayBankbookJournal tempPayBankbookJournal = dao.findUniqueByProperty("unique_code", uniqueCode);
		if(tempPayBankbookJournal != null){
			return BankbookConstants.ERROR_CODE102;
		}
		
		//行锁查询
		PayBankbookBalance payBankbookBalance = payBankbookBalanceDao.getPayBankbookBalanceForUpdate(new PayBankbookBalance(accountId));
		
		if(payBankbookBalance == null){
			return BankbookConstants.ERROR_CODE103;
		}
		
		//如果余额不足
		if(payBankbookBalance.getBalance().compareTo(money) == -1){
			return BankbookConstants.ERROR_CODE104;
		}
				
		//计算 余额 = 当前余额  - 交易金额
		BigDecimal balance = payBankbookBalance.getBalance().subtract(money);
		
		//创建明细
		PayBankbookJournal payBankbookJournal = new PayBankbookJournal();
		payBankbookJournal.setId(IdUtils.getId());
		payBankbookJournal.setDealDate(new Date());
		payBankbookJournal.setDealType("D");
		payBankbookJournal.setMoney(money);
		payBankbookJournal.setMoneyType(moneyType);
		payBankbookJournal.setRemarks(notes);
		payBankbookJournal.setBalance(balance);
		payBankbookJournal.setUniqueCode(uniqueCode);
		payBankbookJournal.setCreateBy(createBy);
		payBankbookJournal.setCreateDate(new Date());
		payBankbookJournal.setAccountId(accountId);
		dao.insert(payBankbookJournal);
		
		//更新余额
		payBankbookBalance.setBalance(balance);
		payBankbookBalanceDao.update(payBankbookBalance);
		
		return BankbookConstants.SUCCESS_CODE0;
	}
}