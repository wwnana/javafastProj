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

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.om.entity.OmReturnorder;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.service.FiPaymentAbleService;
import com.javafast.modules.om.dao.OmReturnorderDao;
import com.javafast.modules.om.entity.OmReturnorderDetail;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.dao.WmsInstockDao;
import com.javafast.modules.wms.dao.WmsInstockDetailDao;
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.entity.WmsInstockDetail;
import com.javafast.modules.wms.entity.WmsPurchaseDetail;
import com.javafast.modules.om.dao.OmReturnorderDetailDao;

/**
 * 销售退单Service
 * @author javafast
 * @version 2017-07-08
 */
@Service
@Transactional(readOnly = true)
public class OmReturnorderService extends CrudService<OmReturnorderDao, OmReturnorder> {

	@Autowired
	private WmsInstockDao wmsInstockDao;
	
	@Autowired
	private WmsInstockDetailDao wmsInstockDetailDao;
	
	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	@Autowired
	private OmReturnorderDetailDao omReturnorderDetailDao;
	
	public OmReturnorder get(String id) {
		OmReturnorder omReturnorder = super.get(id);
		omReturnorder.setOmReturnorderDetailList(omReturnorderDetailDao.findList(new OmReturnorderDetail(omReturnorder)));
		return omReturnorder;
	}
	
	public List<OmReturnorder> findList(OmReturnorder omReturnorder) {
		dataScopeFilter(omReturnorder);//加入数据权限过滤
		return super.findList(omReturnorder);
	}
	
	public Page<OmReturnorder> findPage(Page<OmReturnorder> page, OmReturnorder omReturnorder) {
		dataScopeFilter(omReturnorder);//加入数据权限过滤
		return super.findPage(page, omReturnorder);
	}
	
	@Transactional(readOnly = false)
	public void save(OmReturnorder omReturnorder) {
		super.save(omReturnorder);
		for (OmReturnorderDetail omReturnorderDetail : omReturnorder.getOmReturnorderDetailList()){
			if (omReturnorderDetail.getId() == null){
				continue;
			}
			if (OmReturnorderDetail.DEL_FLAG_NORMAL.equals(omReturnorderDetail.getDelFlag())){
				if (StringUtils.isBlank(omReturnorderDetail.getId())){
					omReturnorderDetail.setReturnorder(omReturnorder);
					omReturnorderDetail.preInsert();
					omReturnorderDetailDao.insert(omReturnorderDetail);
				}else{
					omReturnorderDetail.preUpdate();
					omReturnorderDetailDao.update(omReturnorderDetail);
				}
			}else{
				omReturnorderDetailDao.delete(omReturnorderDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OmReturnorder omReturnorder) {
		super.delete(omReturnorder);
		omReturnorderDetailDao.delete(new OmReturnorderDetail(omReturnorder));
	}
	
	/**
	 * 审核
	 * @param omReturnorder
	 */
	@Transactional(readOnly = false)
	public void audit(OmReturnorder omReturnorder) {
		
		if("0".equals(omReturnorder.getStatus())){
			
			//创建入库单
			WmsInstock wmsInstock = new WmsInstock();
			wmsInstock.setInstockType("1");
			wmsInstock.setNo("RK"+IdUtils.getId());
			wmsInstock.setCustomer(omReturnorder.getCustomer());
			wmsInstock.setOrder(omReturnorder.getOrder());
			wmsInstock.setNum(omReturnorder.getNum());
			wmsInstock.setRealNum(0);
			wmsInstock.setContent(omReturnorder.getContent());
			wmsInstock.setStatus("0");
			wmsInstock.preInsert();
			wmsInstockDao.insert(wmsInstock);
			
			for (OmReturnorderDetail omReturnorderDetail : omReturnorder.getOmReturnorderDetailList()){
				
				WmsInstockDetail wmsInstockDetail = new WmsInstockDetail();
				wmsInstockDetail.setProduct(omReturnorderDetail.getProduct());
				wmsInstockDetail.setNum(omReturnorderDetail.getNum());
				wmsInstockDetail.setInstockNum(0);
				wmsInstockDetail.setUnitType(omReturnorderDetail.getUnitType());
				wmsInstockDetail.setDiffNum(omReturnorderDetail.getNum());
				wmsInstockDetail.setSort(omReturnorderDetail.getSort());
				
				wmsInstockDetail.setInstock(wmsInstock);
				wmsInstockDetail.preInsert();
				wmsInstockDetailDao.insert(wmsInstockDetail);
			}
			
			//生成应付款
			FiPaymentAble fiPaymentAble = new FiPaymentAble();
			fiPaymentAble.setReturnorder(omReturnorder);
			fiPaymentAble.setCustomer(omReturnorder.getCustomer());
			fiPaymentAble.setNo("YF"+IdUtils.getId());
			fiPaymentAble.setAmount(omReturnorder.getAmount());
			fiPaymentAble.setRealAmt(BigDecimal.ZERO);
			fiPaymentAble.setOwnBy(UserUtils.getUser());
			fiPaymentAble.setStatus("0");
			
			fiPaymentAbleService.save(fiPaymentAble);

			//审核退货单
			omReturnorder.setAuditBy(UserUtils.getUser());
			omReturnorder.setAuditDate(new Date());
			omReturnorder.setStatus("1");
			super.save(omReturnorder);
		}
	}
}