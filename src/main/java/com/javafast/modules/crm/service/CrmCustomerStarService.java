package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.dao.CrmCustomerStarDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 客户关注Service
 */
@Service
@Transactional(readOnly = true)
public class CrmCustomerStarService extends CrudService<CrmCustomerStarDao, CrmCustomerStar> {

	public CrmCustomerStar get(String id) {
		return super.get(id);
	}
	
	public List<CrmCustomerStar> findList(CrmCustomerStar crmCustomerStar) {
		crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
		return super.findList(crmCustomerStar);
	}
	
	public Page<CrmCustomerStar> findPage(Page<CrmCustomerStar> page, CrmCustomerStar crmCustomerStar) {
		if(!crmCustomerStar.isApi()){
			crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
		}
		
		return super.findPage(page, crmCustomerStar);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmCustomerStar crmCustomerStar) {
		super.save(crmCustomerStar);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmCustomerStar crmCustomerStar) {
		super.delete(crmCustomerStar);
	}
	
}