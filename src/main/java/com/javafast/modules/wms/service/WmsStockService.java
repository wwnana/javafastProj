/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.dao.WmsStockDao;

/**
 * 产品库存Service
 * @author javafast
 * @version 2017-07-05
 */
@Service
@Transactional(readOnly = true)
public class WmsStockService extends CrudService<WmsStockDao, WmsStock> {

	public WmsStock get(String id) {
		return super.get(id);
	}
	
	public List<WmsStock> findList(WmsStock wmsStock) {
		dataScopeFilter(wmsStock);//加入数据权限过滤
		return super.findList(wmsStock);
	}
	
	public Page<WmsStock> findPage(Page<WmsStock> page, WmsStock wmsStock) {
		dataScopeFilter(wmsStock);//加入数据权限过滤
		return super.findPage(page, wmsStock);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsStock wmsStock) {
		super.save(wmsStock);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsStock wmsStock) {
		super.delete(wmsStock);
	}
	
	/**
	 * 查询预警库存
	 * @param page
	 * @param wmsStock
	 * @return
	 */
	public Page<WmsStock> findWarnPage(Page<WmsStock> page, WmsStock wmsStock) {
		//隔离企业账号数据，加入权限过滤
		wmsStock.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		wmsStock.setPage(page);
		page.setList(dao.findWarnList(wmsStock));
		return page;
	}
}