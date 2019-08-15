/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsProductData;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.dao.WmsProductDao;
import com.javafast.modules.wms.dao.WmsProductDataDao;
import com.javafast.modules.wms.dao.WmsStockDao;

/**
 * 产品Service
 * @author javafast
 * @version 2017-07-04
 */
@Service
@Transactional(readOnly = true)
public class WmsProductService extends CrudService<WmsProductDao, WmsProduct> {

	@Autowired
	WmsProductDataDao wmsProductDataDao;
	
	@Autowired
	WmsStockDao wmsStockDao;
	
	public WmsProduct get(String id) {
		
		WmsProduct wmsProduct = super.get(id);
		wmsProduct.setWmsProductData(wmsProductDataDao.get(id));
		return wmsProduct;
	}
	
	public List<WmsProduct> findList(WmsProduct wmsProduct) {
		dataScopeFilter(wmsProduct);//加入权限过滤
		return super.findList(wmsProduct);
	}
	
	public Page<WmsProduct> findPage(Page<WmsProduct> page, WmsProduct wmsProduct) {
		dataScopeFilter(wmsProduct);//加入权限过滤
		return super.findPage(page, wmsProduct);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsProduct wmsProduct) {
		
		boolean isNew = wmsProduct.getIsNewRecord();

		super.save(wmsProduct);
		
		WmsProductData wmsProductData = wmsProduct.getWmsProductData();
		wmsProductData.setId(wmsProduct.getId());
		
		if(wmsProductData.getContent() != null){
			wmsProductData.setContent(StringEscapeUtils.unescapeHtml4(wmsProductData.getContent()));
		}
		
		if(isNew){
			
			wmsProductDataDao.insert(wmsProductData);
			
			if(wmsProduct.getInitStock() != null){
				
				//创建初期库存
				WmsStock wmsStock = new WmsStock();
				wmsStock.setProduct(wmsProduct);
				wmsStock.setWarehouse(wmsProduct.getInitWarehouse());
				wmsStock.setStockNum(wmsProduct.getInitStock());
				wmsStock.setWarnNum(wmsProduct.getMinStock());
				wmsStock.preInsert();
				wmsStockDao.insert(wmsStock);
			}			
		}else{
			
			wmsProductDataDao.update(wmsProductData);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsProduct wmsProduct) {
		super.delete(wmsProduct);
	}
	
}