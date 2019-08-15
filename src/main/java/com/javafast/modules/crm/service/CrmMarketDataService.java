package com.javafast.modules.crm.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmMarketData;
import com.javafast.modules.crm.dao.CrmMarketDataDao;

/**
 * 活动详情Service
 * @author javafast
 * @version 2019-05-09
 */
@Service
@Transactional(readOnly = true)
public class CrmMarketDataService extends CrudService<CrmMarketDataDao, CrmMarketData> {

	public CrmMarketData get(String id) {
		return super.get(id);
	}
	
	public List<CrmMarketData> findList(CrmMarketData crmMarketData) {
		return super.findList(crmMarketData);
	}
	
	public Page<CrmMarketData> findPage(Page<CrmMarketData> page, CrmMarketData crmMarketData) {
		return super.findPage(page, crmMarketData);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmMarketData crmMarketData) {
		//文本域转码
		if (crmMarketData.getContent()!=null){
			crmMarketData.setContent(StringEscapeUtils.unescapeHtml4(crmMarketData.getContent()));
		}
		super.save(crmMarketData);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmMarketData crmMarketData) {
		super.delete(crmMarketData);
	}
	
	@Transactional(readOnly = false)
	public void add(CrmMarketData crmMarketData) {
		//文本域转码
		if (crmMarketData.getContent()!=null){
			crmMarketData.setContent(StringEscapeUtils.unescapeHtml4(crmMarketData.getContent()));
		}
		dao.insert(crmMarketData);
	}
}