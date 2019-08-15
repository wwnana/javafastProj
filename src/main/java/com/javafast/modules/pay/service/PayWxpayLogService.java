package com.javafast.modules.pay.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.pay.util.BankbookConstants;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.entity.PayWxpayLog;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.pay.dao.PayRechargeOrderDao;
import com.javafast.modules.pay.dao.PayWxpayLogDao;

/**
 * 微信支付通知Service
 */
@Service
@Transactional(readOnly = true)
public class PayWxpayLogService extends CrudService<PayWxpayLogDao, PayWxpayLog> {

	@Autowired
	PayRechargeOrderDao payRechargeOrderDao;
	
	@Autowired
	PayBankbookJournalService payBankbookJournalService;
	
	public PayWxpayLog get(String id) {
		return super.get(id);
	}
	
	public List<PayWxpayLog> findList(PayWxpayLog payWxpayLog) {
		return super.findList(payWxpayLog);
	}
	
	public Page<PayWxpayLog> findPage(Page<PayWxpayLog> page, PayWxpayLog payWxpayLog) {
		return super.findPage(page, payWxpayLog);
	}
	
	@Transactional(readOnly = false)
	public void save(PayWxpayLog payWxpayLog) {
		super.save(payWxpayLog);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayWxpayLog payWxpayLog) {
		super.delete(payWxpayLog);
	}
	
	/**
	 * 微信支付通知处理
	 * @param payWxpayLog
	 * @return 审单结果
	 */
	@Transactional(readOnly = false)
	public synchronized boolean addWxpayLog(PayWxpayLog payWxpayLog) {
		
		PayWxpayLog conPayWxpayLog = new PayWxpayLog();
		conPayWxpayLog.setTransactionId(payWxpayLog.getTransactionId());//微信支付订单号
		conPayWxpayLog.setStatus("1");
		List list = this.findList(conPayWxpayLog);
		if(list == null || list.size() == 0){
			
			//审核订单
			PayRechargeOrder order = payRechargeOrderDao.get(payWxpayLog.getOutTradeNo());
			if(order != null){
				
				order.setStatus("1");//已支付
				order.setPayType("0");
				payRechargeOrderDao.update(order);
				
				payWxpayLog.setStatus("1");//已入账
				dao.update(payWxpayLog);
				
				//入账电子钱包
				BigDecimal money = payWxpayLog.getTotalFee();
				String moneyType = BankbookConstants.MONEY_TYPE10;//充值
				String notes = "在线充值";
				String uniqueCode = order.getId();
				User createBy = UserUtils.getUser();
				String accountId = order.getAccountId();
				String code = payBankbookJournalService.PayBankbookDeposit(money, moneyType, notes, uniqueCode, createBy, accountId);
				if(BankbookConstants.SUCCESS_CODE0.equals(code))
					return true;
			}
		}else{
			//记录
			payWxpayLog.setStatus("3");//重发
			dao.update(payWxpayLog);
		}
		
		return false;
	}
}