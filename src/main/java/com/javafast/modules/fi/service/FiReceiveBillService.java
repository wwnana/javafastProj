/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.fi.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.om.dao.OmContractDao;
import com.javafast.modules.om.dao.OmOrderDao;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.crm.dao.CrmChanceDao;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.fi.dao.FiReceiveAbleDao;
import com.javafast.modules.fi.dao.FiReceiveBillDao;

/**
 * 收款单Service
 * @author javafast
 * @version 2017-07-14
 */
@Service
@Transactional(readOnly = true)
public class FiReceiveBillService extends CrudService<FiReceiveBillDao, FiReceiveBill> {

	@Autowired
	FiReceiveAbleDao fiReceiveAbleDao;
	
	@Autowired
	OmOrderDao omOrderDao;
	
	@Autowired
	OmContractDao omContractDao;
	
	@Autowired
	CrmChanceDao crmChanceDao;
	
	@Autowired
	FiFinanceJournalService fiFinanceJournalService;
	
	@Autowired
	UserDao userDao;
	
	public FiReceiveBill get(String id) {
		return super.get(id);
	}
	
	public List<FiReceiveBill> findList(FiReceiveBill fiReceiveBill) {
		dataScopeFilter(fiReceiveBill);//加入数据权限过滤
		return super.findList(fiReceiveBill);
	}
	
	public Page<FiReceiveBill> findPage(Page<FiReceiveBill> page, FiReceiveBill fiReceiveBill) {
		dataScopeFilter(fiReceiveBill);//加入数据权限过滤
		return super.findPage(page, fiReceiveBill);
	}
	
	@Transactional(readOnly = false)
	public void save(FiReceiveBill fiReceiveBill) {
		
		if(fiReceiveBill.getFiReceiveAble() != null){
			FiReceiveAble fiReceiveAble = fiReceiveAbleDao.get(fiReceiveBill.getFiReceiveAble());
			fiReceiveBill.setOrder(fiReceiveAble.getOrder());
		}
		super.save(fiReceiveBill);
	}
	
	@Transactional(readOnly = false)
	public void delete(FiReceiveBill fiReceiveBill) {
		super.delete(fiReceiveBill);
	}
	
	/**
	 * 审核收款单
	 * @param fiReceiveBill
	 * @throws Exception 
	 */
	@Transactional(readOnly = false)
	public void audit(FiReceiveBill fiReceiveBill) throws Exception {
		
		if("0".equals(fiReceiveBill.getStatus())){
		
			//1.存入资金到账户
			fiFinanceJournalService.saveDeposit(fiReceiveBill.getFiAccount().getId(), "30", fiReceiveBill.getAmount(), "收款单", fiReceiveBill.getId(), UserUtils.getUser());
			
			//2.更新收款单审核状态
			fiReceiveBill.setAuditDate(new Date());
			fiReceiveBill.setStatus("1");
			super.save(fiReceiveBill);
			
			//3.更新应收款
			FiReceiveAble fiReceiveAble = fiReceiveAbleDao.get(fiReceiveBill.getFiReceiveAble());
			if(fiReceiveAble.getRealAmt() == null) {
				fiReceiveAble.setRealAmt(BigDecimal.ZERO);
			}
			BigDecimal realAmt = fiReceiveAble.getRealAmt().add(fiReceiveBill.getAmount());
			fiReceiveAble.setRealAmt(realAmt);
			fiReceiveAble.setStatus("1");
			
			//完成收款       实际已收款 >= 应收总额
			if(realAmt.compareTo(fiReceiveAble.getAmount()) == 0 || realAmt.compareTo(fiReceiveAble.getAmount()) == 1){
				
				fiReceiveAble.setStatus("2");//完成收款
				
				//更新订单回款金额
				if(fiReceiveAble.getOrder() != null && StringUtils.isNotBlank(fiReceiveAble.getOrder().getId())){
					
					OmOrder order = omOrderDao.get(fiReceiveAble.getOrder().getId());
					order.setReceiveAmt(fiReceiveAble.getRealAmt());
					order.setUpdateDate(new Date());
					omOrderDao.update(order);
					
					OmContract omContract = omContractDao.findUniqueByProperty("order_id", order.getId());
					if(omContract != null && omContract.getChance() != null && StringUtils.isNotBlank(omContract.getChance().getId())){
						
						//更新销售阶段为回款完成
						CrmChance chance = crmChanceDao.get(omContract.getChance().getId());
						if(chance != null){
							chance.setPeriodType(Contants.CRM_PERIOD_TYPE_COMPLETE);
							chance.setUpdateDate(new Date());
							crmChanceDao.update(chance);
						}
					}
				}
				
			}
			fiReceiveAbleDao.update(fiReceiveAble);
			
			//收款完成，通知负责人
			if("2".equals(fiReceiveAble.getStatus())) {
				
				//通知负责人跟进
				StringBuffer content = new StringBuffer("回款通知");
				content.append("\n应收编号：" + fiReceiveAble.getNo());
				content.append("\n应收金额："+ fiReceiveAble.getAmount());
				content.append("\n实收金额："+ fiReceiveAble.getRealAmt());
				if(fiReceiveAble.getOrder() != null)
					content.append("\n订单编号：" + fiReceiveAble.getOrder().getNo());
				if(fiReceiveAble.getCustomer() != null)
				content.append("\n客户名称：" + fiReceiveAble.getCustomer().getName());
				content.append("\n负责人：" + fiReceiveAble.getOwnBy().getName());
				content.append("\n\n");
				User ownBy = userDao.get(fiReceiveAble.getOwnBy());
				if(StringUtils.isNotBlank(ownBy.getUserId())) {
					WorkWechatMsgUtils.sendMsg(ownBy.getUserId(), content.toString(), ownBy.getAccountId());
				}
			}
		}
	}
	
	public List<FiReceiveBill> findFiReceiveBillList(FiReceiveBill fiReceiveBill) {
		return super.findList(fiReceiveBill);
	}
}