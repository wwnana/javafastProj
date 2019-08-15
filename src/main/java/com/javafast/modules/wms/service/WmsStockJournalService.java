/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.entity.WmsStockJournal;
import com.javafast.modules.wms.entity.WmsWarehouse;
import com.javafast.modules.wms.dao.WmsStockDao;
import com.javafast.modules.wms.dao.WmsStockJournalDao;

/**
 * 库存流水Service
 * @author javafast
 * @version 2017-07-05
 */
@Service
@Transactional(readOnly = true)
public class WmsStockJournalService extends CrudService<WmsStockJournalDao, WmsStockJournal> {

	@Autowired
	private WmsStockDao wmsStockDao;
	
	public WmsStockJournal get(String id) {
		return super.get(id);
	}
	
	public List<WmsStockJournal> findList(WmsStockJournal wmsStockJournal) {
		dataScopeFilter(wmsStockJournal);//加入权限过滤
		return super.findList(wmsStockJournal);
	}
	
	public Page<WmsStockJournal> findPage(Page<WmsStockJournal> page, WmsStockJournal wmsStockJournal) {
		dataScopeFilter(wmsStockJournal);//加入权限过滤
		return super.findPage(page, wmsStockJournal);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsStockJournal wmsStockJournal) {
		super.save(wmsStockJournal);
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsStockJournal wmsStockJournal) {
		super.delete(wmsStockJournal);
	}
	
	/**
	 * 查询产品库存
	 * @param productId
	 * @param warehouseId
	 * @return
	 */
	public WmsStock getProductStock(String productId, String warehouseId){
		
		List<WmsStock> wmsStockList = wmsStockDao.getProductStock(new WmsStock(productId, warehouseId));
		if(wmsStockList != null && wmsStockList.size() == 1){
			return (WmsStock) wmsStockList.get(0);
		}
		return null;
	}
	
	/**
	 * 入库
	 * @param productId
	 * @param warehouseId
	 * @param num
	 * @param notes
	 * @param uniqueCode
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	public void inStock(String productId, String warehouseId, Integer num, String notes, String uniqueCode) throws Exception {
		
		//查询库存
		WmsStock wmsStock = getProductStock(productId, warehouseId);
		if(wmsStock != null){
			
			wmsStock.setStockNum(wmsStock.getStockNum() + num);
			
			wmsStockDao.update(wmsStock);
		}else{//没有库存记录
			
			//创建库存
			wmsStock = new WmsStock();
			wmsStock.setProduct(new WmsProduct(productId));
			wmsStock.setWarehouse(new WmsWarehouse(warehouseId));
			wmsStock.setStockNum(num);
			wmsStock.setWarnNum(0);
			wmsStock.preInsert();
			wmsStockDao.insert(wmsStock);
		}
		
		//记录明细
		WmsStockJournal wmsStockJournal = new WmsStockJournal();
		wmsStockJournal.setDealType("A");
		wmsStockJournal.setNum(num);
		wmsStockJournal.setProduct(new WmsProduct(productId));
		wmsStockJournal.setWarehouse(new WmsWarehouse(warehouseId));
		wmsStockJournal.setUniqueCode(uniqueCode);
		wmsStockJournal.setNotes(notes);
		
		super.save(wmsStockJournal);
	}
	
	/**
	 * 出库
	 * @param productId
	 * @param warehouseId
	 * @param num
	 * @param notes
	 * @param uniqueCode
	 * @throws Exception
	 */
	@Transactional(readOnly = false)
	public boolean outStock(String productId, String warehouseId, Integer num, String notes, String uniqueCode) throws Exception {
		
		//查询库存
		WmsStock wmsStock = getProductStock(productId, warehouseId);
		
		if(wmsStock != null){
			
			if((wmsStock.getStockNum() - num) >= 0){
				
				wmsStock.setStockNum(wmsStock.getStockNum() - num);
				wmsStockDao.update(wmsStock);
				
				//记录明细
				WmsStockJournal wmsStockJournal = new WmsStockJournal();
				wmsStockJournal.setDealType("D");
				wmsStockJournal.setNum(num);
				wmsStockJournal.setProduct(new WmsProduct(productId));
				wmsStockJournal.setWarehouse(new WmsWarehouse(warehouseId));
				wmsStockJournal.setUniqueCode(uniqueCode);
				wmsStockJournal.setNotes(notes);
				
				super.save(wmsStockJournal);
			}
		}
		
		return false;
	}
}