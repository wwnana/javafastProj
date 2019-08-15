/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.entity.FiPaymentBill;
import com.javafast.modules.fi.dao.FiPaymentBillDao;

/**
 * 付款单Service
 * @author javafast
 * @version 2017-07-17
 */
@Service
@Transactional(readOnly = true)
public class FiPaymentBillService extends CrudService<FiPaymentBillDao, FiPaymentBill> {

	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	@Autowired
	FiFinanceJournalService fiFinanceJournalService;
	
	public FiPaymentBill get(String id) {
		return super.get(id);
	}
	
	public List<FiPaymentBill> findList(FiPaymentBill fiPaymentBill) {
		dataScopeFilter(fiPaymentBill);//加入数据权限过滤
		return super.findList(fiPaymentBill);
	}
	
	public Page<FiPaymentBill> findPage(Page<FiPaymentBill> page, FiPaymentBill fiPaymentBill) {
		dataScopeFilter(fiPaymentBill);//加入数据权限过滤
		return super.findPage(page, fiPaymentBill);
	}
	
	@Transactional(readOnly = false)
	public void save(FiPaymentBill fiPaymentBill) {
		
		super.save(fiPaymentBill);
	}
	
	@Transactional(readOnly = false)
	public void delete(FiPaymentBill fiPaymentBill) {
		super.delete(fiPaymentBill);
	}
	
	/**
	 * 审核付款单
	 * @param fiPaymentBill
	 * @throws Exception 
	 */
	@Transactional(readOnly = false)
	public void audit(FiPaymentBill fiPaymentBill) throws Exception {
		
		if("0".equals(fiPaymentBill.getStatus())){
			
			//1.从账户取出资金
			fiFinanceJournalService.saveDeposit(fiPaymentBill.getFiAccount().getId(), "40", fiPaymentBill.getAmount(), "付款单", fiPaymentBill.getId(), UserUtils.getUser());
			
			//2.修改付款单状态
			fiPaymentBill.setAuditDate(new Date());
			fiPaymentBill.setStatus("1");
			super.save(fiPaymentBill);
			
			//3.更新应付款
			FiPaymentAble fiPaymentAble = fiPaymentAbleService.get(fiPaymentBill.getFiPaymentAble().getId());
			
			BigDecimal realAmt = fiPaymentAble.getRealAmt().add(fiPaymentBill.getAmount());
			fiPaymentAble.setRealAmt(realAmt);
			fiPaymentAble.setStatus("1");
			
			//实际已收款 >= 收款总额
			if(realAmt.compareTo(fiPaymentAble.getAmount()) == 0 || realAmt.compareTo(fiPaymentAble.getAmount()) == 1){
				fiPaymentAble.setStatus("2");
			}
			
			fiPaymentAbleService.save(fiPaymentAble);
		}
	}
}