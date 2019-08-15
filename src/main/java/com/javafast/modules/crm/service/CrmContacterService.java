package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.crm.dao.CrmContacterDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;

/**
 * 联系人Service
 */
@Service
@Transactional(readOnly = true)
public class CrmContacterService extends CrudService<CrmContacterDao, CrmContacter> {

	@Autowired
	CrmCustomerDao crmCustomerDao;
	
	public CrmContacter get(String id) {
		return super.get(id);
	}
	
	public List<CrmContacter> findList(CrmContacter crmContacter) {
		dataScopeFilterOwnBy(crmContacter);//加入权限过滤
		return super.findList(crmContacter);
	}
	
	public Page<CrmContacter> findPage(Page<CrmContacter> page, CrmContacter crmContacter) {
		dataScopeFilterOwnBy(crmContacter);//加入权限过滤
		return super.findPage(page, crmContacter);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmContacter crmContacter) {
		super.save(crmContacter);
		
		//更新客户信息,联系人信息
		CrmCustomer crmCustomer = crmCustomerDao.get(crmContacter.getCustomer());
		
		//如果是首要联系人，则更新联系人到客户信息
		if("1".equals(crmContacter.getIsDefault())){
			crmCustomer.setContacterName(crmContacter.getName());
			crmCustomer.setMobile(crmContacter.getMobile());
		}		
		crmCustomer.preUpdate();
		crmCustomerDao.update(crmCustomer);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmContacter crmContacter) {
		super.delete(crmContacter);
	}
	
	/**
	 * 查询记录数
	 * @param crmContacter
	 * @return
	 */
	public Long findCount(CrmContacter crmContacter){
		return dao.findCount(crmContacter);
	}
	
	public List<CrmContacter> findListByCustomer(CrmContacter crmContacter) {
		return super.findList(crmContacter);
	}
	
	/**
	 * 设为首要联系人
	 * @param crmContacter
	 */
	@Transactional(readOnly = false)
	public void setDefault(CrmContacter crmContacter){
		
		//更新客户下面的联系人为非首要
		dao.updateNotDefault(crmContacter);
		
		//更新当前联系人信息，设为首要
		crmContacter.setIsDefault("1");
		crmContacter.preUpdate();
		dao.update(crmContacter);
		
		//更新客户信息,联系人信息
		CrmCustomer crmCustomer = crmCustomerDao.get(crmContacter.getCustomer().getId());
		crmCustomer.setContacterName(crmContacter.getName());
		crmCustomer.setMobile(crmContacter.getMobile());
		crmCustomerDao.update(crmCustomer);
	}
}