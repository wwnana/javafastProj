/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.oa.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonTravel;
import com.javafast.modules.oa.dao.OaCommonAuditDao;
import com.javafast.modules.oa.dao.OaCommonTravelDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 差旅单Service
 * @author javafast
 * @version 2017-08-25
 */
@Service
@Transactional(readOnly = true)
public class OaCommonTravelService extends CrudService<OaCommonTravelDao, OaCommonTravel> {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	public OaCommonTravel get(String id) {
		return super.get(id);
	}
	
	public List<OaCommonTravel> findList(OaCommonTravel oaCommonTravel) {
		//加入权限过滤
		oaCommonTravel.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findList(oaCommonTravel);
	}
	
	public Page<OaCommonTravel> findPage(Page<OaCommonTravel> page, OaCommonTravel oaCommonTravel) {
		//加入权限过滤
		oaCommonTravel.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findPage(page, oaCommonTravel);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommonTravel oaCommonTravel) {
		
		//创建审批
		OaCommonAudit oaCommonAudit = oaCommonTravel.getOaCommonAudit();
		oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
		oaCommonAudit.setType("3");//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		String oaCommonAuditId = oaCommonAuditService.crateCommonAudit(oaCommonAudit);//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		
		oaCommonTravel.setId(oaCommonAuditId);
		dao.insert(oaCommonTravel);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonTravel oaCommonTravel) {
		super.delete(oaCommonTravel);
	}
	
}