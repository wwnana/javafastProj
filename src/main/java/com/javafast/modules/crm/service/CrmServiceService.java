package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.dao.CrmServiceDao;

/**
 * 服务工单Service
 * @author javafast
 * @version 2019-03-28
 */
@Service
@Transactional(readOnly = true)
public class CrmServiceService extends CrudService<CrmServiceDao, CrmService> {

	public CrmService get(String id) {
		return super.get(id);
	}
	
	public List<CrmService> findList(CrmService crmService) {
		dataScopeFilter(crmService);//加入权限过滤
		return super.findList(crmService);
	}
	
	public Page<CrmService> findPage(Page<CrmService> page, CrmService crmService) {
		dataScopeFilter(crmService);//加入权限过滤
		return super.findPage(page, crmService);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmService crmService) {
		super.save(crmService);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmService crmService) {
		super.delete(crmService);
	}
	
}