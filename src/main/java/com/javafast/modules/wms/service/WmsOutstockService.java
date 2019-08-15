/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.dao.WmsOutstockDao;
import com.javafast.modules.wms.entity.WmsOutstockDetail;
import com.javafast.modules.wms.dao.WmsOutstockDetailDao;

/**
 * 出库单Service
 * @author javafast
 * @version 2017-07-07
 */
@Service
@Transactional(readOnly = true)
public class WmsOutstockService extends CrudService<WmsOutstockDao, WmsOutstock> {

	@Autowired
	private WmsOutstockDetailDao wmsOutstockDetailDao;
	
	@Autowired
	private WmsStockJournalService wmsStockJournalService;
	
	public WmsOutstock get(String id) {
		WmsOutstock wmsOutstock = super.get(id);
		wmsOutstock.setWmsOutstockDetailList(wmsOutstockDetailDao.findList(new WmsOutstockDetail(wmsOutstock)));
		return wmsOutstock;
	}
	
	public List<WmsOutstock> findList(WmsOutstock wmsOutstock) {
		dataScopeFilter(wmsOutstock);//加入权限过滤
		return super.findList(wmsOutstock);
	}
	
	public Page<WmsOutstock> findPage(Page<WmsOutstock> page, WmsOutstock wmsOutstock) {
		dataScopeFilter(wmsOutstock);//加入权限过滤
		return super.findPage(page, wmsOutstock);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsOutstock wmsOutstock) {
		super.save(wmsOutstock);
		for (WmsOutstockDetail wmsOutstockDetail : wmsOutstock.getWmsOutstockDetailList()){
//			if (wmsOutstockDetail.getId() == null){
//				continue;
//			}
			if (WmsOutstockDetail.DEL_FLAG_NORMAL.equals(wmsOutstockDetail.getDelFlag())){
				if (StringUtils.isBlank(wmsOutstockDetail.getId())){
					wmsOutstockDetail.setInstock(wmsOutstock);
					wmsOutstockDetail.preInsert();
					wmsOutstockDetailDao.insert(wmsOutstockDetail);
				}else{
					wmsOutstockDetail.preUpdate();
					wmsOutstockDetailDao.update(wmsOutstockDetail);
				}
			}else{
				wmsOutstockDetailDao.delete(wmsOutstockDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsOutstock wmsOutstock) {
		super.delete(wmsOutstock);
		wmsOutstockDetailDao.delete(new WmsOutstockDetail(wmsOutstock));
	}
	
	/**
	 * 审核出库单
	 * @param wmsOutstock
	 * @throws Exception 
	 */
	@Transactional(readOnly = false)
	public void audit(WmsOutstock wmsOutstock) throws Exception {
		
		if("0".equals(wmsOutstock.getStatus())){
		
			for(WmsOutstockDetail wmsOutstockDetail : wmsOutstock.getWmsOutstockDetailList()){
				
				//调用出库
				wmsStockJournalService.outStock(wmsOutstockDetail.getProduct().getId(), wmsOutstock.getWarehouse().getId(), wmsOutstockDetail.getOutstockNum(), "销售出库", wmsOutstockDetail.getId());
			}
			
			wmsOutstock.setAuditBy(UserUtils.getUser());
			wmsOutstock.setAuditDate(new Date());
			wmsOutstock.setStatus("1");
			super.save(wmsOutstock);
		}
	}
}