package com.javafast.modules.crm.service;

import java.util.List;

import com.javafast.modules.crm.entity.CrmCustomer;
import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.dao.CrmDocumentDao;

/**
 * 附件管理Service
 * @author javafast
 * @version 2018-04-27
 */
@Service
@Transactional(readOnly = true)
public class CrmDocumentService extends CrudService<CrmDocumentDao, CrmDocument> {

	public CrmDocument get(String id) {
		return super.get(id);
	}
	
	public List<CrmDocument> findList(CrmDocument crmDocument) {
		return super.findList(crmDocument);
	}
	
	public Page<CrmDocument> findPage(Page<CrmDocument> page, CrmDocument crmDocument) {
		return super.findPage(page, crmDocument);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmDocument crmDocument) {
		super.save(crmDocument);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmDocument crmDocument) {
		super.delete(crmDocument);
	}
	
	public Long findCount(CrmDocument crmDocument){
		return dao.findCount(crmDocument);
	}
	
	/**
	 * 查询客户附件
	 * @param crmDocument
	 * @return
	 */
	public List<CrmDocument> findListByCustomer(CrmDocument crmDocument) {
		return super.findList(crmDocument);
	}
}