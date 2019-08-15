/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.service.FiPaymentAbleService;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.entity.WmsInstockDetail;
import com.javafast.modules.wms.entity.WmsPurchase;
import com.javafast.modules.wms.dao.WmsInstockDao;
import com.javafast.modules.wms.dao.WmsInstockDetailDao;
import com.javafast.modules.wms.dao.WmsPurchaseDao;
import com.javafast.modules.wms.entity.WmsPurchaseDetail;
import com.javafast.modules.wms.dao.WmsPurchaseDetailDao;

/**
 * 采购单Service
 * @author javafast
 * @version 2017-07-07
 */
@Service
@Transactional(readOnly = true)
public class WmsPurchaseService extends CrudService<WmsPurchaseDao, WmsPurchase> {

	@Autowired
	private WmsPurchaseDetailDao wmsPurchaseDetailDao;
	
	@Autowired
	private WmsInstockDao wmsInstockDao;
	
	@Autowired
	private WmsInstockDetailDao wmsInstockDetailDao;
	
	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	public WmsPurchase get(String id) {
		WmsPurchase wmsPurchase = super.get(id);
		wmsPurchase.setWmsPurchaseDetailList(wmsPurchaseDetailDao.findList(new WmsPurchaseDetail(wmsPurchase)));
		return wmsPurchase;
	}
	
	public List<WmsPurchase> findList(WmsPurchase wmsPurchase) {
		dataScopeFilter(wmsPurchase);//加入权限过滤
		return super.findList(wmsPurchase);
	}
	
	public Page<WmsPurchase> findPage(Page<WmsPurchase> page, WmsPurchase wmsPurchase) {
		dataScopeFilter(wmsPurchase);//加入权限过滤
		return super.findPage(page, wmsPurchase);
	}
	
	@Transactional(readOnly = false)
	public void save(WmsPurchase wmsPurchase) {
		super.save(wmsPurchase);
		
		//删除明细
		wmsPurchaseDetailDao.delete(new WmsPurchaseDetail(wmsPurchase));
		
		//添加明细
		for (WmsPurchaseDetail wmsPurchaseDetail : wmsPurchase.getWmsPurchaseDetailList()){
			
			if(StringUtils.isNotBlank(wmsPurchaseDetail.getId()) && wmsPurchase.getDelSelectIds()!=null && wmsPurchase.getDelSelectIds().contains(","+wmsPurchaseDetail.getId()+",")){
				continue;			
			}
			
			wmsPurchaseDetail.setPurchase(wmsPurchase);
			wmsPurchaseDetail.preInsert();
			wmsPurchaseDetailDao.insert(wmsPurchaseDetail);
		}
		
//		for (WmsPurchaseDetail wmsPurchaseDetail : wmsPurchase.getWmsPurchaseDetailList()){
//			if (wmsPurchaseDetail.getId() == null){
//				continue;
//			}
//			if (WmsPurchaseDetail.DEL_FLAG_NORMAL.equals(wmsPurchaseDetail.getDelFlag())){
//				if (StringUtils.isBlank(wmsPurchaseDetail.getId())){
//					wmsPurchaseDetail.setPurchase(wmsPurchase);
//					wmsPurchaseDetail.preInsert();
//					wmsPurchaseDetailDao.insert(wmsPurchaseDetail);
//				}else{
//					wmsPurchaseDetail.preUpdate();
//					wmsPurchaseDetailDao.update(wmsPurchaseDetail);
//				}
//			}else{
//				wmsPurchaseDetailDao.delete(wmsPurchaseDetail);
//			}
//		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WmsPurchase wmsPurchase) {
		super.delete(wmsPurchase);
		wmsPurchaseDetailDao.delete(new WmsPurchaseDetail(wmsPurchase));
	}
	
	/**
	 * 审核采购单
	 * @param wmsPurchase
	 */
	@Transactional(readOnly = false)
	public void audit(WmsPurchase wmsPurchase) {
		
		if("0".equals(wmsPurchase.getStatus())){
			
			//创建入库单
			WmsInstock wmsInstock = new WmsInstock();
			wmsInstock.setInstockType("0");
			wmsInstock.setNo("RK"+IdUtils.getId());
			wmsInstock.setSupplier(wmsPurchase.getSupplier());
			wmsInstock.setNum(wmsPurchase.getNum());
			wmsInstock.setRealNum(0);
			wmsInstock.setContent(wmsPurchase.getContent());
			wmsInstock.setStatus("0");
			wmsInstock.setPurchase(wmsPurchase);
			wmsInstock.preInsert();
			wmsInstockDao.insert(wmsInstock);
			
			for (WmsPurchaseDetail wmsPurchaseDetail : wmsPurchase.getWmsPurchaseDetailList()){
				
				WmsInstockDetail wmsInstockDetail = new WmsInstockDetail();
				wmsInstockDetail.setProduct(wmsPurchaseDetail.getProduct());
				wmsInstockDetail.setNum(wmsPurchaseDetail.getNum());
				wmsInstockDetail.setInstockNum(0);
				wmsInstockDetail.setUnitType(wmsPurchaseDetail.getUnitType());
				wmsInstockDetail.setDiffNum(wmsPurchaseDetail.getNum());
				wmsInstockDetail.setSort(wmsPurchaseDetail.getSort());
				
				wmsInstockDetail.setInstock(wmsInstock);
				wmsInstockDetail.preInsert();
				wmsInstockDetailDao.insert(wmsInstockDetail);
			}
			
			//生成应付款
			FiPaymentAble fiPaymentAble = new FiPaymentAble();
			fiPaymentAble.setPurchase(wmsPurchase);
			fiPaymentAble.setSupplier(wmsPurchase.getSupplier());
			fiPaymentAble.setNo("YF"+IdUtils.getId());
			fiPaymentAble.setAmount(wmsPurchase.getAmount());
			fiPaymentAble.setRealAmt(BigDecimal.ZERO);
			fiPaymentAble.setOwnBy(UserUtils.getUser());
			fiPaymentAble.setStatus("0");
			
			fiPaymentAbleService.save(fiPaymentAble);
			
			//审核采购单状态
			wmsPurchase.setAuditBy(UserUtils.getUser());
			wmsPurchase.setAuditDate(new Date());
			wmsPurchase.setStatus("1");
			super.save(wmsPurchase);	
		}
	}
}