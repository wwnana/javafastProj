/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.wms.entity.WmsSupplierType;
import com.javafast.modules.wms.dao.WmsSupplierTypeDao;

/**
 * 供应商分类Service
 * @author javafast
 * @version 2017-07-04
 */
@Service
@Transactional(readOnly = true)
public class WmsSupplierTypeService extends TreeService<WmsSupplierTypeDao, WmsSupplierType> {

	public WmsSupplierType get(String id) {
		return super.get(id);
	}
	
	public List<WmsSupplierType> findList(WmsSupplierType wmsSupplierType) {
		
		dataScopeFilter(wmsSupplierType);//加入权限过滤
		if (StringUtils.isNotBlank(wmsSupplierType.getParentIds())){
			wmsSupplierType.setParentIds(","+wmsSupplierType.getParentIds()+",");
		}
		return super.findList(wmsSupplierType);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsSupplierType wmsSupplierType) {
		super.save(wmsSupplierType);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsSupplierType wmsSupplierType) {
		super.delete(wmsSupplierType);
	}
	
}