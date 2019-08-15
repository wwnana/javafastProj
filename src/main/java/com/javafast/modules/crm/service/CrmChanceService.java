package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.crm.dao.CrmChanceDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;

/**
 * 商机Service
 */
@Service
@Transactional(readOnly = true)
public class CrmChanceService extends CrudService<CrmChanceDao, CrmChance> {

	@Autowired
	CrmCustomerDao crmCustomerDao;
	
	public CrmChance get(String id) {
		return super.get(id);
	}
	
	public List<CrmChance> findList(CrmChance crmChance) {
		dataScopeFilterOwnBy(crmChance);//加入权限过滤
		return super.findList(crmChance);
	}
	
	public Page<CrmChance> findPage(Page<CrmChance> page, CrmChance crmChance) {
		dataScopeFilterOwnBy(crmChance);//加入权限过滤
		return super.findPage(page, crmChance);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmChance crmChance) {
		super.save(crmChance);
		
		//更新客户状态  
		CrmCustomer crmCustomer = crmCustomerDao.get(crmChance.getCustomer());
		if(!"2".equals(crmCustomer.getCustomerStatus())){// 客户状态 0潜在、1：开发中，2：成交、3：失效   
			crmCustomer.setCustomerStatus("1");
		}
		crmCustomer.preUpdate();
		crmCustomerDao.updateStatus(crmCustomer);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmChance crmChance) {
		super.delete(crmChance);		
	}
	
	/**
	 * 查询记录数
	 * @param crmChance
	 * @return
	 */
	public Long findCount(CrmChance crmChance){
		return dao.findCount(crmChance);
	}
	
	public List<CrmChance> findListByCustomer(CrmChance crmChance) {
		//dataScopeFilter(crmChance);//加入权限过滤
		return super.findList(crmChance);
	}
}