/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonExpense;
import com.javafast.modules.oa.dao.OaCommonAuditDao;
import com.javafast.modules.oa.dao.OaCommonExpenseDao;
import com.javafast.modules.oa.entity.OaCommonExpenseDetail;
import com.javafast.modules.oa.dao.OaCommonExpenseDetailDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 报销单Service
 * @author javafast
 * @version 2017-08-25
 */
@Service
@Transactional(readOnly = true)
public class OaCommonExpenseService extends CrudService<OaCommonExpenseDao, OaCommonExpense> {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@Autowired
	private OaCommonExpenseDetailDao oaCommonExpenseDetailDao;
	
	public OaCommonExpense get(String id) {
		OaCommonExpense oaCommonExpense = super.get(id);
		oaCommonExpense.setOaCommonExpenseDetailList(oaCommonExpenseDetailDao.findList(new OaCommonExpenseDetail(oaCommonExpense)));
		return oaCommonExpense;
	}
	
	public List<OaCommonExpense> findList(OaCommonExpense oaCommonExpense) {
		//加入权限过滤
		oaCommonExpense.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findList(oaCommonExpense);
	}
	
	public Page<OaCommonExpense> findPage(Page<OaCommonExpense> page, OaCommonExpense oaCommonExpense) {
		//加入权限过滤
		oaCommonExpense.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findPage(page, oaCommonExpense);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommonExpense oaCommonExpense) {
		//创建审批
		OaCommonAudit oaCommonAudit = oaCommonExpense.getOaCommonAudit();
		oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
		oaCommonAudit.setType("2");//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		String oaCommonAuditId = oaCommonAuditService.crateCommonAudit(oaCommonAudit);//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		
		oaCommonExpense.setId(oaCommonAuditId);
		dao.insert(oaCommonExpense);
				
		for (OaCommonExpenseDetail oaCommonExpenseDetail : oaCommonExpense.getOaCommonExpenseDetailList()){
			if (oaCommonExpenseDetail.getId() == null){
				continue;
			}
			if (OaCommonExpenseDetail.DEL_FLAG_NORMAL.equals(oaCommonExpenseDetail.getDelFlag())){
				if (StringUtils.isBlank(oaCommonExpenseDetail.getId())){
					oaCommonExpenseDetail.setExpense(oaCommonExpense);
					oaCommonExpenseDetail.preInsert();
					oaCommonExpenseDetailDao.insert(oaCommonExpenseDetail);
				}else{
					oaCommonExpenseDetail.preUpdate();
					oaCommonExpenseDetailDao.update(oaCommonExpenseDetail);
				}
			}else{
				oaCommonExpenseDetailDao.delete(oaCommonExpenseDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonExpense oaCommonExpense) {
		super.delete(oaCommonExpense);
		oaCommonExpenseDetailDao.delete(new OaCommonExpenseDetail(oaCommonExpense));
	}
	
}