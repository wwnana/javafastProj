/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.oa.service;

import java.util.List;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonExtra;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.oa.dao.OaCommonExtraDao;

/**
 * 加班单Service
 * @author javafast
 * @version 2017-08-26
 */
@Service
@Transactional(readOnly = true)
public class OaCommonExtraService extends CrudService<OaCommonExtraDao, OaCommonExtra> {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	public OaCommonExtra get(String id) {
		return super.get(id);
	}
	
	public List<OaCommonExtra> findList(OaCommonExtra oaCommonExtra) {
		//加入权限过滤
		oaCommonExtra.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findList(oaCommonExtra);
	}
	
	public Page<OaCommonExtra> findPage(Page<OaCommonExtra> page, OaCommonExtra oaCommonExtra) {
		//加入权限过滤
		oaCommonExtra.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findPage(page, oaCommonExtra);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommonExtra oaCommonExtra) {
		//创建审批
		OaCommonAudit oaCommonAudit = oaCommonExtra.getOaCommonAudit();
		oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
		oaCommonAudit.setType("5");//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单 ,5加班单
		String oaCommonAuditId = oaCommonAuditService.crateCommonAudit(oaCommonAudit);//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		
		oaCommonExtra.setId(oaCommonAuditId);
		dao.insert(oaCommonExtra);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonExtra oaCommonExtra) {
		super.delete(oaCommonExtra);
	}
	
}