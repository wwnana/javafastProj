/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.wms.entity.WmsProductData;
import com.javafast.modules.wms.dao.WmsProductDataDao;

/**
 * 产品详情表Service
 * @author javafast
 * @version 2017-10-24
 */
@Service
@Transactional(readOnly = true)
public class WmsProductDataService extends CrudService<WmsProductDataDao, WmsProductData> {

	public WmsProductData get(String id) {
		return super.get(id);
	}
	
	public List<WmsProductData> findList(WmsProductData wmsProductData) {
		return super.findList(wmsProductData);
	}
	
	public Page<WmsProductData> findPage(Page<WmsProductData> page, WmsProductData wmsProductData) {
		return super.findPage(page, wmsProductData);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsProductData wmsProductData) {
		super.save(wmsProductData);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsProductData wmsProductData) {
		super.delete(wmsProductData);
	}
	
}