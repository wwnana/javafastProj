package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.crm.entity.CrmTag;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.crm.dao.CrmTagDao;

/**
 * 客户标签Service
 */
@Service
@Transactional(readOnly = true)
public class CrmTagService extends CrudService<CrmTagDao, CrmTag> {

	public CrmTag get(String id) {
		return super.get(id);
	}
	
	public List<CrmTag> findList(CrmTag crmTag) {
		dataScopeFilter(crmTag);//加入数据权限过滤
		return super.findList(crmTag);
	}
	
	public Page<CrmTag> findPage(Page<CrmTag> page, CrmTag crmTag) {
		dataScopeFilter(crmTag);//加入数据权限过滤
		return super.findPage(page, crmTag);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmTag crmTag) {
		super.save(crmTag);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmTag crmTag) {
		super.delete(crmTag);
	}
	
}