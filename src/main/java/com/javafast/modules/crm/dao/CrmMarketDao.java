package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.Office;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmMarket;

/**
 * 市场活动DAO接口
 * @author javafast
 * @version 2019-03-26
 */
@MyBatisDao
public interface CrmMarketDao extends CrudDao<CrmMarket> {
	
}