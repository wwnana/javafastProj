package com.javafast.modules.pay.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.pay.entity.PayBookOrder;
import com.javafast.modules.pay.dao.PayBookOrderDao;

/**
 * 预定订单Service
 * @author javafast
 * @version 2018-08-03
 */
@Service
@Transactional(readOnly = true)
public class PayBookOrderService extends CrudService<PayBookOrderDao, PayBookOrder> {

	public PayBookOrder get(String id) {
		return super.get(id);
	}
	
	public List<PayBookOrder> findList(PayBookOrder payBookOrder) {
		return super.findList(payBookOrder);
	}
	
	public Page<PayBookOrder> findPage(Page<PayBookOrder> page, PayBookOrder payBookOrder) {
		return super.findPage(page, payBookOrder);
	}
	
	@Transactional(readOnly = false)
	public void save(PayBookOrder payBookOrder) {
		super.save(payBookOrder);
	}
	
	@Transactional(readOnly = false)
	public void delete(PayBookOrder payBookOrder) {
		super.delete(payBookOrder);
	}
	
	@Transactional(readOnly = false)
	public void createOrder(PayBookOrder payBookOrder) {
		payBookOrder.preInsert();
		payBookOrder.setAccountId("0");
		dao.insert(payBookOrder);
	}
	
}