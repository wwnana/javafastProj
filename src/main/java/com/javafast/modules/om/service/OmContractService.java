package com.javafast.modules.om.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.entity.WmsOutstockDetail;
import com.javafast.modules.wms.service.WmsOutstockService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.crm.dao.CrmChanceDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.om.dao.OmContractDao;
import com.javafast.modules.om.dao.OmOrderDao;
import com.javafast.modules.om.dao.OmOrderDetailDao;

/**
 * 合同Service
 * @author javafast
 * @version 2017-07-13
 */
@Service
@Transactional(readOnly = true)
public class OmContractService extends CrudService<OmContractDao, OmContract> {
	
	@Autowired
	private OmOrderDetailDao omOrderDetailDao;
	
	@Autowired
	OmOrderDao omOrderDao;
	
	@Autowired
	CrmCustomerDao crmCustomerDao;
	
	@Autowired
    OmOrderService omOrderService;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	CrmChanceDao crmChanceDao;
	
	@Autowired
	UserDao userDao;
	
	public OmContract get(String id) {
		OmContract omContract = super.get(id);
		
		//查询关联的订单
		if(omContract.getOrder()!=null && StringUtils.isNotBlank(omContract.getOrder().getId())){
			
			OmOrder order = omOrderDao.get(omContract.getOrder().getId());
			if(order != null) {
				
				omContract.setOrder(order);
				
				order.setOmOrderDetailList(omOrderDetailDao.findList(new OmOrderDetail(order)));
				omContract.setOmOrderDetailList(order.getOmOrderDetailList());
			}
		}
		return omContract;
	}
	
	public List<OmContract> findList(OmContract omContract) {
		dataScopeFilterOwnBy(omContract);//加入权限过滤
		return super.findList(omContract);
	}
	
	public Page<OmContract> findPage(Page<OmContract> page, OmContract omContract) {
		dataScopeFilterOwnBy(omContract);//加入权限过滤
		return super.findPage(page, omContract);
	}
	
	@Transactional(readOnly = false)
	public void save(OmContract omContract) {
		
		//文本域转码
		if (omContract.getNotes()!=null){
			omContract.setNotes(StringEscapeUtils.unescapeHtml4(omContract.getNotes()));
		}
		
		//合同和订单保持一致的ID
		String id = IdUtils.getId();
		
		if(omContract.getIsNewRecord()){
			
			
			//保存订单
			OmOrder omOrder = omContract.getOrder();		
			if(omOrder != null) {
				omOrder.setOmOrderDetailList(omContract.getOmOrderDetailList());//订单明细
				omOrder.setDelSelectIds(omContract.getDelSelectIds());
				omOrder.preInsert();
				omOrder.setId(id);
				omOrderDao.insert(omOrder);
				
				//添加明细
				for (OmOrderDetail omOrderDetail : omOrder.getOmOrderDetailList()){
					
					if(StringUtils.isNotBlank(omOrderDetail.getId()) && omOrder.getDelSelectIds()!=null && omOrder.getDelSelectIds().contains(","+omOrderDetail.getId()+",")){
						continue;			
					}
					
					omOrderDetail.setOrder(omOrder);
					omOrderDetail.preInsert();
					omOrderDetailDao.insert(omOrderDetail);
				}
			}
			
			//保存合同
			omContract.setOrder(omOrder);
			omContract.preInsert();
			omContract.setId(id);
			dao.insert(omContract);
		}else{
			//更新
			omContract.preUpdate();
			dao.update(omContract);
			
			//保存订单
			OmOrder omOrder = omContract.getOrder();		
			if(omOrder != null) {
				
				omOrder.preUpdate();
				omOrderDao.update(omOrder);
				
				omOrder.setOmOrderDetailList(omContract.getOmOrderDetailList());//订单明细
				omOrder.setDelSelectIds(omContract.getDelSelectIds());
				
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
			}
		}
		
		//更新客户状态
		CrmCustomer crmCustomer = crmCustomerDao.get(omContract.getCustomer());
		//更新客户状态  
		if(!"2".equals(crmCustomer.getCustomerStatus())){// 客户状态 0潜在、1：开发中，2：成交、3：失效   
			crmCustomer.setCustomerStatus("1");
		}
		crmCustomer.preUpdate();
		crmCustomerDao.updateStatus(crmCustomer);
	}
	
	@Transactional(readOnly = false)
	public void delete(OmContract omContract) {
		super.delete(omContract);
		omOrderDao.delete(omContract.getOrder());
	}
	
	/**
	 * 审核合同订单
	 * @param omContract
	 */
	@Transactional(readOnly = false)
	public void audit(OmContract omContract) {

		if("0".equals(omContract.getStatus())){
			
			//审核订单
			omOrderService.audit(omContract.getOrder().getId());
			
			//更新订单合同
			omContract.setAuditDate(new Date());
			omContract.setStatus("1");	
			super.save(omContract);
			
			//更新客户状态为已成交
			CrmCustomer customer = crmCustomerDao.get(omContract.getCustomer());
			customer.setCustomerStatus("2");
			customer.preUpdate();
			crmCustomerDao.updateStatus(customer);
			
			//更新销售阶段为成交待收
			if(omContract.getChance() != null && StringUtils.isNotBlank(omContract.getChance().getId())){
				CrmChance chance = crmChanceDao.get(omContract.getChance().getId());
				if(chance != null){
					chance.setPeriodType(Contants.CRM_PERIOD_TYPE_ORDER);
					chance.preUpdate();
					crmChanceDao.update(chance);
				}			
			}
			
			//通知负责人跟进
			StringBuffer content = new StringBuffer("合同审核通知");
			content.append("\n合同编号：" + omContract.getNo());
			content.append("\n合同标题：" + omContract.getName());
			content.append("\n合同金额："+ omContract.getAmount());
			content.append("\n客户名称：" + omContract.getCustomer().getName());
			content.append("\n签约日期：" + DateUtils.formatDate(omContract.getDealDate(), "yyyy-MM-dd"));
			if(omContract.getDeliverDate() != null)
				content.append("\n交付日期：" + DateUtils.formatDate(omContract.getDeliverDate(), "yyyy-MM-dd"));
			content.append("\n负责人：" + omContract.getOwnBy().getName());
			content.append("\n审核人：" + omContract.getAuditBy().getName());
			content.append("\n\n<a href=\""+Global.getConfig("webSite")+Global.getConfig("adminPath") + "/om/omContract/index?id="+omContract.getId()+"\">点击查看详情</a>");
			User ownBy = userDao.get(omContract.getOwnBy());
			if(StringUtils.isNotBlank(ownBy.getUserId())) {
				WorkWechatMsgUtils.sendMsg(ownBy.getUserId(), content.toString(), ownBy.getAccountId());
			}
		}
	}
	
	/**
	 * 撤销合同订单
	 * @param omContract
	 */
	@Transactional(readOnly = false)
	public void revoke(OmContract omContract) {

		if("1".equals(omContract.getStatus())){
			
			//撤销订单(撤销应收款)
			omOrderService.revoke(omContract.getOrder());
			
			//更新订单合同
			omContract.setStatus("0");	//撤销 修改为未审核
			super.save(omContract);
		}		
	}
	
	/**
	 * 查询记录数
	 * @param omContract
	 * @return
	 */
	public Long findCount(OmContract omContract){
		return dao.findCount(omContract);
	}
	
	public List<OmContract> findListByCustomer(OmContract omContract) {
		//dataScopeFilter(omContract);//加入数据权限过滤
		return super.findList(omContract);
	}
}