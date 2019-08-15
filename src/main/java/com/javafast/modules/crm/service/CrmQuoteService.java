package com.javafast.modules.crm.service;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.dao.CrmChanceDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;
import com.javafast.modules.crm.dao.CrmQuoteDao;
import com.javafast.modules.crm.entity.CrmQuoteDetail;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsPurchaseDetail;
import com.javafast.modules.crm.dao.CrmQuoteDetailDao;

/**
 * 报价单Service
 */
@Service
@Transactional(readOnly = true)
public class CrmQuoteService extends CrudService<CrmQuoteDao, CrmQuote> {

	@Autowired
	CrmCustomerDao crmCustomerDao;
	
	@Autowired
	CrmChanceDao crmChanceDao;
	
	@Autowired
	private CrmQuoteDetailDao crmQuoteDetailDao;
	
	public CrmQuote get(String id) {
		CrmQuote crmQuote = super.get(id);
		crmQuote.setCrmQuoteDetailList(crmQuoteDetailDao.findList(new CrmQuoteDetail(crmQuote)));
		return crmQuote;
	}
	
	public List<CrmQuote> findList(CrmQuote crmQuote) {
		dataScopeFilterOwnBy(crmQuote);//加入权限过滤
		return super.findList(crmQuote);
	}
	
	public Page<CrmQuote> findPage(Page<CrmQuote> page, CrmQuote crmQuote) {
		dataScopeFilterOwnBy(crmQuote);//加入权限过滤
		return super.findPage(page, crmQuote);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmQuote crmQuote) {
		
		//文本域转码
		if (crmQuote.getNotes()!=null){
			crmQuote.setNotes(StringEscapeUtils.unescapeHtml4(crmQuote.getNotes()));
		}
				
		super.save(crmQuote);
		
		//删除明细
		crmQuoteDetailDao.delete(new CrmQuoteDetail(crmQuote));
		
		//添加明细
		for (CrmQuoteDetail crmQuoteDetail : crmQuote.getCrmQuoteDetailList()){
			
			if(StringUtils.isNotBlank(crmQuoteDetail.getId()) && crmQuote.getDelSelectIds()!=null && crmQuote.getDelSelectIds().contains(","+crmQuoteDetail.getId()+",")){
				continue;			
			}
			
			crmQuoteDetail.setQuote(crmQuote);
			crmQuoteDetail.preInsert();
			crmQuoteDetailDao.insert(crmQuoteDetail);
		}
				
//		for (CrmQuoteDetail crmQuoteDetail : crmQuote.getCrmQuoteDetailList()){
//			if (crmQuoteDetail.getId() == null){
//				continue;
//			}
//			if (CrmQuoteDetail.DEL_FLAG_NORMAL.equals(crmQuoteDetail.getDelFlag())){
//				if (StringUtils.isBlank(crmQuoteDetail.getId())){
//					crmQuoteDetail.setQuote(crmQuote);
//					crmQuoteDetail.preInsert();
//					crmQuoteDetailDao.insert(crmQuoteDetail);
//				}else{
//					crmQuoteDetail.preUpdate();
//					crmQuoteDetailDao.update(crmQuoteDetail);
//				}
//			}else{
//				crmQuoteDetailDao.delete(crmQuoteDetail);
//			}
//		}
		
		//更新客户状态为开发中
		CrmCustomer crmCustomer = crmCustomerDao.get(crmQuote.getCustomer());
		//更新客户状态  
		if(!"2".equals(crmCustomer.getCustomerStatus())){// 客户状态 0潜在、1：开发中，2：成交、3：失效   
			crmCustomer.setCustomerStatus("1");
		}
		crmCustomer.preUpdate();
		crmCustomerDao.updateStatus(crmCustomer);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmQuote crmQuote) {
		super.delete(crmQuote);
		crmQuoteDetailDao.delete(new CrmQuoteDetail(crmQuote));
	}
	
	/*
	 * 审核报价单，更新销售阶段
	 */
	@Transactional(readOnly = false)
	public void audit(CrmQuote crmQuote) {
		
		if("0".equals(crmQuote.getStatus())){
			
			crmQuote.setStatus("1");
			
			//更新销售阶段为报价
			if(crmQuote.getChance() != null && StringUtils.isNotBlank(crmQuote.getChance().getId())){
				CrmChance chance = crmChanceDao.get(crmQuote.getChance().getId());
				if(chance != null){
					
					chance.setPeriodType(Contants.CRM_PERIOD_TYPE_QUOTE);
					chance.preUpdate();
					crmChanceDao.update(chance);
				}
			}
			
			super.save(crmQuote);
		}
	}
	
	/**
	 * 查询记录数
	 * @param crmQuote
	 * @return
	 */
	public Long findCount(CrmQuote crmQuote){
		return dao.findCount(crmQuote);
	}
	
	public List<CrmQuote> findListByCustomer(CrmQuote crmQuote) {
		//dataScopeFilter(crmQuote);//加入数据权限过滤
		return super.findList(crmQuote);
	}
}