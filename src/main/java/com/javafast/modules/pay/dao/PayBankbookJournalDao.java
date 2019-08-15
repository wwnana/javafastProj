package com.javafast.modules.pay.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.pay.entity.PayBankbookJournal;

/**
 * 电子钱包交易明细DAO接口
 * @author javafast
 * @version 2018-05-15
 */
@MyBatisDao
public interface PayBankbookJournalDao extends CrudDao<PayBankbookJournal> {
	
}