package com.javafast.modules.pay.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.pay.entity.PayAlipayLog;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.dao.PayAlipayLogDao;
import com.javafast.modules.pay.dao.PayRechargeOrderDao;

/**
 * 支付宝支付通知Service
 */
@Service
@Transactional(readOnly = true)
public class PayAlipayLogService extends CrudService<PayAlipayLogDao, PayAlipayLog> {

	@Autowired
	PayRechargeOrderDao payRechargeOrderDao;
	
	public PayAlipayLog get(String id) {
		return super.get(id);
	}
	
	public List<PayAlipayLog> findList(PayAlipayLog payAlipayLog) {
		return super.findList(payAlipayLog);
	}
	
	public Page<PayAlipayLog> findPage(Page<PayAlipayLog> page, PayAlipayLog payAlipayLog) {
		return super.findPage(page, payAlipayLog);
	}
	
	@Transactional(readOnly = false)
	public void save(PayAlipayLog payAlipayLog) {
		super.save(payAlipayLog);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayAlipayLog payAlipayLog) {
		super.delete(payAlipayLog);
	}
	
	/**
	 * 支付宝付款通知处理
	 * @param payAlipayLog
	 * @return 审单结果
	 */
	@Transactional(readOnly = false)
	public synchronized boolean addAlipayLog(PayAlipayLog payAlipayLog) {
		
		PayAlipayLog conPayAlipayLog = new PayAlipayLog();
		conPayAlipayLog.setTradeNo(conPayAlipayLog.getTradeNo());
		conPayAlipayLog.setStatus("1");
		List list = this.findList(conPayAlipayLog);
		if(list == null || list.size() == 0){
			
			//审核订单
			PayRechargeOrder order = payRechargeOrderDao.get(payAlipayLog.getOutTradeNo());
			if(order != null){
				
				order.setStatus("1");//已支付
				order.setPayType("1");
				payRechargeOrderDao.update(order);
				
				payAlipayLog.setStatus("1");//已入账
				dao.update(payAlipayLog);
				return true;
			}
		}else{
			
			//记录
			payAlipayLog.setStatus("3");//重发
			dao.update(payAlipayLog);
		}
		
		return false;
	}
}