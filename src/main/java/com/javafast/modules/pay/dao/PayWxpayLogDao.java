package com.javafast.modules.pay.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.pay.entity.PayWxpayLog;

/**
 * 微信支付通知DAO接口
 */
@MyBatisDao
public interface PayWxpayLogDao extends CrudDao<PayWxpayLog> {
	
}