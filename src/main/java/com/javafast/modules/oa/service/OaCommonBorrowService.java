package com.javafast.modules.oa.service;

import java.util.List;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonBorrow;
import com.javafast.modules.oa.dao.OaCommonAuditDao;
import com.javafast.modules.oa.dao.OaCommonBorrowDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 借款单Service
 * @author javafast
 * @version 2017-08-25
 */
@Service
@Transactional(readOnly = true)
public class OaCommonBorrowService extends CrudService<OaCommonBorrowDao, OaCommonBorrow> {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	public OaCommonBorrow get(String id) {
		return super.get(id);
	}
	
	public List<OaCommonBorrow> findList(OaCommonBorrow oaCommonBorrow) {
		//加入权限过滤
		oaCommonBorrow.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findList(oaCommonBorrow);
	}
	
	public Page<OaCommonBorrow> findPage(Page<OaCommonBorrow> page, OaCommonBorrow oaCommonBorrow) {
		//加入权限过滤
		oaCommonBorrow.getSqlMap().put("dsf", " AND c.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return super.findPage(page, oaCommonBorrow);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommonBorrow oaCommonBorrow) {
		
		//创建审批
		OaCommonAudit oaCommonAudit = oaCommonBorrow.getOaCommonAudit();
		oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
		oaCommonAudit.setType("4");//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		String oaCommonAuditId = oaCommonAuditService.crateCommonAudit(oaCommonAudit);//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		
		oaCommonBorrow.setId(oaCommonAuditId);
		dao.insert(oaCommonBorrow);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonBorrow oaCommonBorrow) {
		super.delete(oaCommonBorrow);
	}
	
}