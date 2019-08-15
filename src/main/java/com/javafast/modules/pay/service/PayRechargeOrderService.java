package com.javafast.modules.pay.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.dao.PayRechargeOrderDao;

/**
 * 充值订单Service
 */
@Service
@Transactional(readOnly = true)
public class PayRechargeOrderService extends CrudService<PayRechargeOrderDao, PayRechargeOrder> {

	public PayRechargeOrder get(String id) {
		return super.get(id);
	}
	
	public List<PayRechargeOrder> findList(PayRechargeOrder payRechargeOrder) {
		return super.findList(payRechargeOrder);
	}
	
	public Page<PayRechargeOrder> findPage(Page<PayRechargeOrder> page, PayRechargeOrder payRechargeOrder) {
		return super.findPage(page, payRechargeOrder);
	}
	
	@Transactional(readOnly = false)
	public void save(PayRechargeOrder payRechargeOrder) {
		super.save(payRechargeOrder);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayRechargeOrder payRechargeOrder) {
		super.delete(payRechargeOrder);
	}
	
}