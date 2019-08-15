/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.modules.wms.dao.WmsSupplierDao;

/**
 * 供应商Service
 * @author javafast
 * @version 2017-07-04
 */
@Service
@Transactional(readOnly = true)
public class WmsSupplierService extends CrudService<WmsSupplierDao, WmsSupplier> {

	public WmsSupplier get(String id) {
		return super.get(id);
	}
	
	public List<WmsSupplier> findList(WmsSupplier wmsSupplier) {
		dataScopeFilter(wmsSupplier);//加入权限过滤
		return super.findList(wmsSupplier);
	}
	
	public Page<WmsSupplier> findPage(Page<WmsSupplier> page, WmsSupplier wmsSupplier) {
		dataScopeFilter(wmsSupplier);//加入权限过滤
		return super.findPage(page, wmsSupplier);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsSupplier wmsSupplier) {
		super.save(wmsSupplier);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsSupplier wmsSupplier) {
		super.delete(wmsSupplier);
	}
	
}