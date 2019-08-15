package com.javafast.modules.crm.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmCustomerType;
import com.javafast.modules.crm.dao.CrmCustomerTypeDao;

/**
 * 客户分类Service
 */
@Service
@Transactional(readOnly = true)
public class CrmCustomerTypeService extends TreeService<CrmCustomerTypeDao, CrmCustomerType> {

	public CrmCustomerType get(String id) {
		return super.get(id);
	}
	
	public List<CrmCustomerType> findList(CrmCustomerType crmCustomerType) {
		
		dataScopeFilter(crmCustomerType);//加入权限过滤
		if (StringUtils.isNotBlank(crmCustomerType.getParentIds())){
			crmCustomerType.setParentIds(","+crmCustomerType.getParentIds()+",");
		}
		return super.findList(crmCustomerType);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmCustomerType crmCustomerType) {
		super.save(crmCustomerType);
	}
	
	@Transactional(readOnly = false)
	public void add(CrmCustomerType crmCustomerType) {
		dao.insert(crmCustomerType);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmCustomerType crmCustomerType) {
		super.delete(crmCustomerType);
	}
	
	/**
	 * 查询默认分类
	 * @param crmCustomerType
	 * @return
	 */
	public CrmCustomerType getDefaultCrmCustomerType(CrmCustomerType crmCustomerType){
		dataScopeFilter(crmCustomerType);//加入权限过滤
		List<CrmCustomerType> list = dao.findOneList(crmCustomerType);
		if(list != null && list.size() == 1){
			return list.get(0);
		}
		
		return null;
	}
}