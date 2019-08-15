/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.dao.WmsProductTypeDao;

/**
 * 产品分类Service
 * @author javafast
 * @version 2017-07-04
 */
@Service
@Transactional(readOnly = true)
public class WmsProductTypeService extends TreeService<WmsProductTypeDao, WmsProductType> {

	public WmsProductType get(String id) {
		return super.get(id);
	}
	
	public List<WmsProductType> findList(WmsProductType wmsProductType) {
		
		dataScopeFilter(wmsProductType);//加入权限过滤
		if (StringUtils.isNotBlank(wmsProductType.getParentIds())){
			wmsProductType.setParentIds(","+wmsProductType.getParentIds()+",");
		}
		return super.findList(wmsProductType);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsProductType wmsProductType) {
		super.save(wmsProductType);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsProductType wmsProductType) {
		super.delete(wmsProductType);
	}
	
}