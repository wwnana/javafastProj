/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.om.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.javafast.common.service.CrudService;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.om.dao.OmOrderDao;
import com.javafast.modules.om.dao.OmOrderDetailDao;

/**
 * 销售订单明细Service
 * @author javafast
 * @version 2017-07-14
 */
@Service
@Transactional(readOnly = true)
public class OmOrderDetailService extends CrudService<OmOrderDetailDao, OmOrderDetail> {
	
	@Autowired
	private OmOrderDao omOrderDao;
	
	@Autowired
	private OmOrderDetailDao omOrderDetailDao;
	
	public OmOrderDetail get(String id) {
		return super.get(id);
	}
	
	@Transactional(readOnly = false)
	public void save(OmOrderDetail omOrderDetail) {
		super.save(omOrderDetail);
		
		//重新计算订单金额
		OmOrder omOrder = comOrder(omOrderDetail.getOrder().getId());
		omOrder.preUpdate();
		omOrderDao.update(omOrder);
	}
	
	@Transactional(readOnly = false)
	public void delete(OmOrderDetail omOrderDetail) {
		super.delete(omOrderDetail);
		
		//重新计算订单金额
		OmOrder omOrder = comOrder(omOrderDetail.getOrder().getId());
		omOrder.preUpdate();
		omOrderDao.update(omOrder);
	}
	
	/**
	 * 计算订单金额
	 * @param orderId
	 * @return
	 */
	public OmOrder comOrder(String orderId) {
		
		OmOrder omOrder = omOrderDao.get(orderId);
		List<OmOrderDetail> omOrderDetailList = omOrderDetailDao.findList(new OmOrderDetail(omOrder));
		
		//重新计算
		Integer num = 0;		// 总数量
		BigDecimal totalAmt = BigDecimal.ZERO;		// 合计
		//BigDecimal taxAmt = BigDecimal.ZERO;		// 税额
		
		BigDecimal otherAmt = omOrder.getOtherAmt();		// 其他费用
		if(otherAmt == null)
			otherAmt = BigDecimal.ZERO;
		
		for (OmOrderDetail orderDetail : omOrderDetailList){
			
			num += orderDetail.getNum();
			
			//小计金额 = 单价 * 数量
			BigDecimal amount = orderDetail.getPrice().multiply(new BigDecimal(orderDetail.getNum()));
			
			totalAmt = totalAmt.add(amount);
			
			//if(orderDetail.getTaxAmt() != null)
			//	taxAmt = taxAmt.add(orderDetail.getTaxAmt());
		}
		
		omOrder.setNum(num);
		omOrder.setTotalAmt(totalAmt);
		//omOrder.setTaxAmt(taxAmt);
		omOrder.setAmount(totalAmt.add(otherAmt));//总金额 = 合计 + 其他费用
		
		return omOrder;
	}
}