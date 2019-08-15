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
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.wms.entity.WmsAllot;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.dao.WmsAllotDao;
import com.javafast.modules.wms.entity.WmsAllotDetail;
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.entity.WmsInstockDetail;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.entity.WmsOutstockDetail;
import com.javafast.modules.wms.dao.WmsAllotDetailDao;
import com.javafast.modules.wms.dao.WmsInstockDao;
import com.javafast.modules.wms.dao.WmsInstockDetailDao;
import com.javafast.modules.wms.dao.WmsOutstockDao;
import com.javafast.modules.wms.dao.WmsOutstockDetailDao;

/**
 * 调拨单Service
 * @author javafast
 * @version 2018-01-11
 */
@Service
@Transactional(readOnly = true)
public class WmsAllotService extends CrudService<WmsAllotDao, WmsAllot> {

	@Autowired
	private WmsAllotDetailDao wmsAllotDetailDao;
	
	@Autowired
	private WmsInstockDao wmsInstockDao;
	
	@Autowired
	private WmsInstockDetailDao wmsInstockDetailDao;
	
	@Autowired
	private WmsOutstockDao wmsOutstockDao;
	
	@Autowired
	private WmsOutstockDetailDao wmsOutstockDetailDao;
	
	public WmsAllot get(String id) {
		WmsAllot wmsAllot = super.get(id);
		wmsAllot.setWmsAllotDetailList(wmsAllotDetailDao.findList(new WmsAllotDetail(wmsAllot)));
		return wmsAllot;
	}
	
	public List<WmsAllot> findList(WmsAllot wmsAllot) {
		dataScopeFilter(wmsAllot);//加入权限过滤
		return super.findList(wmsAllot);
	}
	
	public Page<WmsAllot> findPage(Page<WmsAllot> page, WmsAllot wmsAllot) {
		dataScopeFilter(wmsAllot);//加入权限过滤
		return super.findPage(page, wmsAllot);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsAllot wmsAllot) {
		super.save(wmsAllot);
		for (WmsAllotDetail wmsAllotDetail : wmsAllot.getWmsAllotDetailList()){
			if (wmsAllotDetail.getId() == null){
				continue;
			}
			if (WmsAllotDetail.DEL_FLAG_NORMAL.equals(wmsAllotDetail.getDelFlag())){
				if (StringUtils.isBlank(wmsAllotDetail.getId())){
					wmsAllotDetail.setWmsAllot(wmsAllot);
					wmsAllotDetail.preInsert();
					wmsAllotDetailDao.insert(wmsAllotDetail);
				}else{
					wmsAllotDetail.preUpdate();
					wmsAllotDetailDao.update(wmsAllotDetail);
				}
			}else{
				wmsAllotDetailDao.delete(wmsAllotDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsAllot wmsAllot) {
		super.delete(wmsAllot);
		wmsAllotDetailDao.delete(new WmsAllotDetail(wmsAllot));
	}
	
	/**
	 * 审核调拨单
	 * @param wmsAllot
	 */
	@Transactional(readOnly = false)
	public void audit(WmsAllot wmsAllot){
		
		if("0".equals(wmsAllot.getStatus())){
		
			//创建出库单
			WmsOutstock wmsOutstock = new WmsOutstock();
			wmsOutstock.setOutstockType("2");
			wmsOutstock.setNo("RK"+IdUtils.getId());
			wmsOutstock.setNum(wmsAllot.getNum());
			wmsOutstock.setRealNum(0);
			wmsOutstock.setWarehouse(wmsAllot.getOutWarehouse());
			wmsOutstock.setStatus("0");
			wmsOutstock.preInsert();
			wmsOutstockDao.insert(wmsOutstock);
			
			//出库单明细
			for (WmsAllotDetail wmsAllotDetail : wmsAllot.getWmsAllotDetailList()){
				WmsOutstockDetail wmsOutstockDetail = new WmsOutstockDetail();
				wmsOutstockDetail.setProduct(wmsAllotDetail.getProduct());
				wmsOutstockDetail.setNum(wmsAllotDetail.getNum());
				wmsOutstockDetail.setOutstockNum(0);
				wmsOutstockDetail.setDiffNum(wmsAllotDetail.getNum());
				wmsOutstockDetail.setSort(wmsAllotDetail.getSort());
				
				wmsOutstockDetail.setInstock(wmsOutstock);
				wmsOutstockDetail.preInsert();
				wmsOutstockDetailDao.insert(wmsOutstockDetail);
			}
			
			//创建入库单
			WmsInstock wmsInstock = new WmsInstock();
			wmsInstock.setInstockType("2");
			wmsInstock.setNo("RK"+IdUtils.getId());
			wmsInstock.setNum(wmsAllot.getNum());
			wmsInstock.setRealNum(0);
			wmsInstock.setWarehouse(wmsAllot.getInWarehouse());
			wmsInstock.setStatus("0");
			wmsInstock.preInsert();
			wmsInstockDao.insert(wmsInstock);
			
			//入库单明细
			for (WmsAllotDetail wmsAllotDetail : wmsAllot.getWmsAllotDetailList()){
				
				WmsInstockDetail wmsInstockDetail = new WmsInstockDetail();
				wmsInstockDetail.setProduct(wmsAllotDetail.getProduct());
				wmsInstockDetail.setNum(wmsAllotDetail.getNum());
				wmsInstockDetail.setInstockNum(0);
				wmsInstockDetail.setDiffNum(wmsAllotDetail.getNum());
				wmsInstockDetail.setSort(wmsAllotDetail.getSort());
				
				wmsInstockDetail.setInstock(wmsInstock);
				wmsInstockDetail.preInsert();
				wmsInstockDetailDao.insert(wmsInstockDetail);
			}
			
			//审核调拨单状态
			wmsAllot.setAuditBy(UserUtils.getUser());
			wmsAllot.setAuditDate(new Date());
			wmsAllot.setStatus("1");
			super.save(wmsAllot);	
		}
	}
}