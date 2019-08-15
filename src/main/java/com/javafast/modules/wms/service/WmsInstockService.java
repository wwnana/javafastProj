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
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.dao.WmsInstockDao;
import com.javafast.modules.wms.entity.WmsInstockDetail;
import com.javafast.modules.wms.dao.WmsInstockDetailDao;

/**
 * 入库单Service
 * @author javafast
 * @version 2017-07-07
 */
@Service
@Transactional(readOnly = true)
public class WmsInstockService extends CrudService<WmsInstockDao, WmsInstock> {

	@Autowired
	private WmsInstockDetailDao wmsInstockDetailDao;
	
	@Autowired
	private WmsStockJournalService wmsStockJournalService;
	
	public WmsInstock get(String id) {
		WmsInstock wmsInstock = super.get(id);
		wmsInstock.setWmsInstockDetailList(wmsInstockDetailDao.findList(new WmsInstockDetail(wmsInstock)));
		return wmsInstock;
	}
	
	public List<WmsInstock> findList(WmsInstock wmsInstock) {
		dataScopeFilter(wmsInstock);//加入权限过滤
		return super.findList(wmsInstock);
	}
	
	public Page<WmsInstock> findPage(Page<WmsInstock> page, WmsInstock wmsInstock) {
		dataScopeFilter(wmsInstock);//加入权限过滤
		return super.findPage(page, wmsInstock);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsInstock wmsInstock) {
		super.save(wmsInstock);
		for (WmsInstockDetail wmsInstockDetail : wmsInstock.getWmsInstockDetailList()){
			if (wmsInstockDetail.getId() == null){
				continue;
			}
			if (WmsInstockDetail.DEL_FLAG_NORMAL.equals(wmsInstockDetail.getDelFlag())){
				if (StringUtils.isBlank(wmsInstockDetail.getId())){
					wmsInstockDetail.setInstock(wmsInstock);
					wmsInstockDetail.preInsert();
					wmsInstockDetailDao.insert(wmsInstockDetail);
				}else{
					wmsInstockDetail.preUpdate();
					wmsInstockDetailDao.update(wmsInstockDetail);
				}
			}else{
				wmsInstockDetailDao.delete(wmsInstockDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsInstock wmsInstock) {
		super.delete(wmsInstock);
		wmsInstockDetailDao.delete(new WmsInstockDetail(wmsInstock));
	}
	
	/**
	 * 审核入库单
	 * @param wmsInstock
	 * @throws Exception 
	 */
	@Transactional(readOnly = false)
	public void audit(WmsInstock wmsInstock) throws Exception {
		
		if("0".equals(wmsInstock.getStatus())){
			
			for (WmsInstockDetail wmsInstockDetail : wmsInstock.getWmsInstockDetailList()){
				
				//调用入库
				wmsStockJournalService.inStock(wmsInstockDetail.getProduct().getId(), wmsInstock.getWarehouse().getId(), wmsInstockDetail.getInstockNum(), "采购入库", wmsInstock.getId());
			}	
			
			wmsInstock.setAuditBy(UserUtils.getUser());
			wmsInstock.setAuditDate(new Date());
			wmsInstock.setStatus("1");
			super.save(wmsInstock);
		}
	}
}