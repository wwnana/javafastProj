package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmInvoice;
import com.javafast.modules.crm.dao.CrmInvoiceDao;

/**
 * 开票信息Service
 */
@Service
@Transactional(readOnly = true)
public class CrmInvoiceService extends CrudService<CrmInvoiceDao, CrmInvoice> {

	public CrmInvoice get(String id) {
		return super.get(id);
	}
	
	public List<CrmInvoice> findList(CrmInvoice crmInvoice) {
		dataScopeFilter(crmInvoice);//加入权限过滤
		return super.findList(crmInvoice);
	}
	
	public Page<CrmInvoice> findPage(Page<CrmInvoice> page, CrmInvoice crmInvoice) {
		dataScopeFilter(crmInvoice);//加入权限过滤
		return super.findPage(page, crmInvoice);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmInvoice crmInvoice) {
		super.save(crmInvoice);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmInvoice crmInvoice) {
		super.delete(crmInvoice);
	}
	
}