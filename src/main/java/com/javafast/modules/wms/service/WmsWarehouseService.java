/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.wms.entity.WmsWarehouse;
import com.javafast.modules.wms.dao.WmsWarehouseDao;

/**
 * 仓库Service
 * @author javafast
 * @version 2017-07-04
 */
@Service
@Transactional(readOnly = true)
public class WmsWarehouseService extends CrudService<WmsWarehouseDao, WmsWarehouse> {

	public WmsWarehouse get(String id) {
		return super.get(id);
	}
	
	public List<WmsWarehouse> findList(WmsWarehouse wmsWarehouse) {
		dataScopeFilter(wmsWarehouse);//加入权限过滤
		return super.findList(wmsWarehouse);
	}
	
	public Page<WmsWarehouse> findPage(Page<WmsWarehouse> page, WmsWarehouse wmsWarehouse) {
		dataScopeFilter(wmsWarehouse);//加入权限过滤
		return super.findPage(page, wmsWarehouse);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsWarehouse wmsWarehouse) {
		super.save(wmsWarehouse);
		
		//修改默认数据
		if("1".equals(wmsWarehouse.getIsDefault())){
			dao.updateDefaultData(wmsWarehouse);
		}
	}
	
	@Transactional(readOnly = false)
	public void add(WmsWarehouse wmsWarehouse) {
		dao.insert(wmsWarehouse);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsWarehouse wmsWarehouse) {
		super.delete(wmsWarehouse);
	}
	
}