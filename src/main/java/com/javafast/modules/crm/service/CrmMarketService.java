package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.Office;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.entity.CrmMarketData;
import com.javafast.modules.crm.dao.CrmMarketDao;
import com.javafast.modules.crm.dao.CrmMarketDataDao;

/**
 * 市场活动Service
 * @author javafast
 * @version 2019-03-26
 */
@Service
@Transactional(readOnly = true)
public class CrmMarketService extends CrudService<CrmMarketDao, CrmMarket> {

	@Autowired
	CrmMarketDataDao crmMarketDataDao;
	
	public CrmMarket get(String id) {
		CrmMarket crmMarket = super.get(id);
		crmMarket.setCrmMarketData(crmMarketDataDao.get(id));//加载详情
		return crmMarket;
	}
	
	public List<CrmMarket> findList(CrmMarket crmMarket) {
		dataScopeFilterOwnBy(crmMarket);//加入权限过滤
		return super.findList(crmMarket);
	}
	
	public Page<CrmMarket> findPage(Page<CrmMarket> page, CrmMarket crmMarket) {
		dataScopeFilterOwnBy(crmMarket);//加入权限过滤
		return super.findPage(page, crmMarket);
	}
	
	public Page<CrmMarket> findAllPage(Page<CrmMarket> page, CrmMarket crmMarket) {
		return super.findPage(page, crmMarket);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmMarket crmMarket) {
		boolean isNew = crmMarket.getIsNewRecord();
		super.save(crmMarket);
		
		//保存详情
		CrmMarketData crmMarketData = new CrmMarketData();
		if(isNew) {
			crmMarketData.setId(crmMarket.getId());
			crmMarketData.setTitle(crmMarket.getName());
			crmMarketDataDao.insert(crmMarketData);
		}
//		else {
//			crmMarketDataDao.update(crmMarketData);
//		}
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmMarket crmMarket) {
		super.delete(crmMarket);
	}
	
}