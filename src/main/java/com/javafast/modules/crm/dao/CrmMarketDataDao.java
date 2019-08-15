package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmMarketData;

/**
 * 活动详情DAO接口
 * @author javafast
 * @version 2019-05-09
 */
@MyBatisDao
public interface CrmMarketDataDao extends CrudDao<CrmMarketData> {
	
}