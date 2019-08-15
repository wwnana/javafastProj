package com.javafast.modules.pay.service;

import java.util.List;

import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.pay.entity.PayBankbookBalance;
import com.javafast.modules.pay.dao.PayBankbookBalanceDao;

/**
 * 电子钱包余额Service
 * @author javafast
 * @version 2018-05-15
 */
@Service
@Transactional(readOnly = true)
public class PayBankbookBalanceService extends CrudService<PayBankbookBalanceDao, PayBankbookBalance> {

	public PayBankbookBalance get(String id) {
		return super.get(id);
	}
	
	public List<PayBankbookBalance> findList(PayBankbookBalance payBankbookBalance) {
		return super.findList(payBankbookBalance);
	}
	
	public Page<PayBankbookBalance> findPage(Page<PayBankbookBalance> page, PayBankbookBalance payBankbookBalance) {
		return super.findPage(page, payBankbookBalance);
	}
	
	@Transactional(readOnly = false)
	public void save(PayBankbookBalance payBankbookBalance) {
		super.save(payBankbookBalance);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayBankbookBalance payBankbookBalance) {
		super.delete(payBankbookBalance);
	}
	
	@Transactional(readOnly = false)
	public void createPayBankbook(PayBankbookBalance payBankbookBalance){
		
		dao.insert(payBankbookBalance);
	}
}