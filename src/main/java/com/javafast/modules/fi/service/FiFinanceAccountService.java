/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.dao.FiFinanceAccountDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 结算账户Service
 * @author javafast
 * @version 2017-07-07
 */
@Service
@Transactional(readOnly = true)
public class FiFinanceAccountService extends CrudService<FiFinanceAccountDao, FiFinanceAccount> {

	public FiFinanceAccount get(String id) {
		return super.get(id);
	}
	
	public List<FiFinanceAccount> findList(FiFinanceAccount fiFinanceAccount) {
		dataScopeFilter(fiFinanceAccount);//加入数据权限过滤
		return super.findList(fiFinanceAccount);
	}
	
	public Page<FiFinanceAccount> findPage(Page<FiFinanceAccount> page, FiFinanceAccount fiFinanceAccount) {
		dataScopeFilter(fiFinanceAccount);//加入数据权限过滤
		return super.findPage(page, fiFinanceAccount);
	}
	
	@Transactional(readOnly = false)
	public void save(FiFinanceAccount fiFinanceAccount) {
		super.save(fiFinanceAccount);
		
		//更新默认数据
		if("1".equals(fiFinanceAccount.getIsDefault())){
			dao.updateDefaultData(fiFinanceAccount);
		}
	}
	
	@Transactional(readOnly = false)
	public void add(FiFinanceAccount fiFinanceAccount) {
		dao.insert(fiFinanceAccount);
	}
	
	@Transactional(readOnly = false)
	public void delete(FiFinanceAccount fiFinanceAccount) {
		super.delete(fiFinanceAccount);
	}
	
}