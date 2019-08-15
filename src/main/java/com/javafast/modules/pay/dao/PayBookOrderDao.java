package com.javafast.modules.pay.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.pay.entity.PayBookOrder;

/**
 * 预定订单DAO接口
 * @author javafast
 * @version 2018-08-03
 */
@MyBatisDao
public interface PayBookOrderDao extends CrudDao<PayBookOrder> {
	
}