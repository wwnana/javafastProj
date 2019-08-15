/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.om.service;

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
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.crm.entity.CrmQuoteDetail;
import com.javafast.modules.fi.dao.FiReceiveAbleDao;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.om.dao.OmOrderDao;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.entity.WmsOutstockDetail;
import com.javafast.modules.wms.service.WmsOutstockService;
import com.javafast.modules.om.dao.OmOrderDetailDao;

/**
 * 销售订单Service
 * @author javafast
 * @version 2017-07-14
 */
@Service
@Transactional(readOnly = true)
public class OmOrderService extends CrudService<OmOrderDao, OmOrder> {

	@Autowired
	private OmOrderDetailDao omOrderDetailDao;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	public OmOrder get(String id) {
		OmOrder omOrder = super.get(id);
		omOrder.setOmOrderDetailList(omOrderDetailDao.findList(new OmOrderDetail(omOrder)));
		return omOrder;
	}
	
	public List<OmOrder> findList(OmOrder omOrder) {
		dataScopeFilter(omOrder);//加入数据权限过滤
		return super.findList(omOrder);
	}
	
	public Page<OmOrder> findPage(Page<OmOrder> page, OmOrder omOrder) {
		dataScopeFilter(omOrder);//加入数据权限过滤
		return super.findPage(page, omOrder);
	}
	
	@Transactional(readOnly = false)
	public void save(OmOrder omOrder) {
		super.save(omOrder);
		
		//删除明细
		omOrderDetailDao.delete(new OmOrderDetail(omOrder));
		
		//添加明细
		for (OmOrderDetail omOrderDetail : omOrder.getOmOrderDetailList()){
			
			if(StringUtils.isNotBlank(omOrderDetail.getId()) && omOrder.getDelSelectIds()!=null && omOrder.getDelSelectIds().contains(","+omOrderDetail.getId()+",")){
				continue;			
			}
			
			omOrderDetail.setOrder(omOrder);
			omOrderDetail.preInsert();
			omOrderDetailDao.insert(omOrderDetail);
		}
				
//		for (OmOrderDetail omOrderDetail : omOrder.getOmOrderDetailList()){
//			if (omOrderDetail.getId() == null){
//				continue;
//			}
//			if (OmOrderDetail.DEL_FLAG_NORMAL.equals(omOrderDetail.getDelFlag())){
//				if (StringUtils.isBlank(omOrderDetail.getId())){
//					omOrderDetail.setOrder(omOrder);
//					omOrderDetail.preInsert();
//					omOrderDetailDao.insert(omOrderDetail);
//				}else{
//					omOrderDetail.preUpdate();
//					omOrderDetailDao.update(omOrderDetail);
//				}
//			}else{
//				omOrderDetailDao.delete(omOrderDetail);
//			}
//		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OmOrder omOrder) {
		super.delete(omOrder);
		omOrderDetailDao.delete(new OmOrderDetail(omOrder));
	}
	
	/**
	 * 审核
	 * @param omOrder
	 */
	@Transactional(readOnly = false)
	public void audit(String id) {
		
		OmOrder omOrder = this.get(id);
		if("0".equals(omOrder.getStatus())){
			
			//创建出库单
			WmsOutstock wmsOutstock = new WmsOutstock();
			wmsOutstock.setNo("RK"+IdUtils.getId());
			wmsOutstock.setStatus("0");
			wmsOutstock.setDealDate(new Date());
			wmsOutstock.setOrder(omOrder);
			wmsOutstock.setOutstockType("0");
			wmsOutstock.setContent(omOrder.getContent());
			wmsOutstock.setNum(omOrder.getNum());
			wmsOutstock.setRealNum(0);
			
			List<WmsOutstockDetail> wmsOutstockDetailList = Lists.newArrayList();
			
			for(OmOrderDetail omOrderDetail : omOrder.getOmOrderDetailList()){
				
				WmsOutstockDetail wmsOutstockDetail = new WmsOutstockDetail();
				wmsOutstockDetail.setProduct(omOrderDetail.getProduct());
				wmsOutstockDetail.setNum(omOrderDetail.getNum());
				wmsOutstockDetail.setUnitType(omOrderDetail.getUnitType());
				wmsOutstockDetail.setOutstockNum(0);
				wmsOutstockDetail.setDiffNum(omOrderDetail.getNum());
				wmsOutstockDetail.setRemarks(omOrderDetail.getRemarks());
				wmsOutstockDetail.setSort(omOrderDetail.getSort());
				
				wmsOutstockDetailList.add(wmsOutstockDetail);
			}
			
			wmsOutstock.setWmsOutstockDetailList(wmsOutstockDetailList);
			wmsOutstockService.save(wmsOutstock);
			
			//生成应收款
			FiReceiveAble fiReceiveAble = new FiReceiveAble();
			fiReceiveAble.setOrder(omOrder);
			fiReceiveAble.setCustomer(omOrder.getCustomer());
			fiReceiveAble.setNo("YS"+IdUtils.getId());
			fiReceiveAble.setAmount(omOrder.getAmount());
			fiReceiveAble.setRealAmt(BigDecimal.ZERO);		
			fiReceiveAble.setOwnBy(omOrder.getDealBy());
			fiReceiveAble.setStatus("0");
			fiReceiveAbleService.save(fiReceiveAble);
			
			//审核订单状态
			omOrder.setStatus("1");
			omOrder.setAuditBy(UserUtils.getUser());
			omOrder.setAuditDate(new Date());
			super.save(omOrder);
		}
	}
	
	/**
	 * 撤销订单
	 * @param omOrder
	 */
	@Transactional(readOnly = false)
	public void revoke(OmOrder omOrder) {
		
		if("1".equals(omOrder.getStatus())){
			
			//删除出库单
			WmsOutstock conWmsOutstock = new WmsOutstock();
			conWmsOutstock.setOrder(omOrder);
			List<WmsOutstock> wmsOutstockList = wmsOutstockService.findList(conWmsOutstock);
			if(wmsOutstockList !=null && wmsOutstockList.size()>0){
				
				WmsOutstock wmsOutstock = wmsOutstockList.get(0);
				wmsOutstockService.delete(wmsOutstock);
			}
			
			//删除应收款(同时会删除收款单明细)
			FiReceiveAble conFiReceiveAble = new FiReceiveAble();
			conFiReceiveAble.setOrder(omOrder);
			List<FiReceiveAble> list = fiReceiveAbleService.findFiReceiveAbleList(conFiReceiveAble);
			if(list !=null && list.size()>0){
				
				FiReceiveAble fiReceiveAble = list.get(0);
				fiReceiveAbleService.delete(fiReceiveAble);
			}		
			
			//撤销订单
			omOrder.setStatus("0"); //修改为未审核
			omOrder.setAuditBy(UserUtils.getUser());
			omOrder.setAuditDate(new Date());
			super.save(omOrder);
		}
	}
}