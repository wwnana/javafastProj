package com.javafast.modules.sys.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.dao.SysDynamicDao;

/**
 * 动态Service
 */
@Service
@Transactional(readOnly = true)
public class SysDynamicService extends CrudService<SysDynamicDao, SysDynamic> {

	public SysDynamic get(String id) {
		return super.get(id);
	}
	
	public List<SysDynamic> findList(SysDynamic sysDynamic) {
		//dataScopeFilterByRole(sysDynamic);//加入权限过滤
		return super.findList(sysDynamic);
	}
	
	public Page<SysDynamic> findPage(Page<SysDynamic> page, SysDynamic sysDynamic) {
		dataScopeFilterByRole(sysDynamic);//加入权限过滤
		return super.findPage(page, sysDynamic);
	}
	
	@Transactional(readOnly = false)
	public void save(SysDynamic sysDynamic) {
		super.save(sysDynamic);
	}
	
	@Transactional(readOnly = false)
	public void delete(SysDynamic sysDynamic) {
		super.delete(sysDynamic);
	}
	
}