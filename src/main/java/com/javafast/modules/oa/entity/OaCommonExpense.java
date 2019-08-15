package com.javafast.modules.oa.entity;

import java.math.BigDecimal;
import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 报销单Entity
 * @author javafast
 * @version 2017-08-25
 */
public class OaCommonExpense extends DataEntity<OaCommonExpense> {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal amount;		// 报销总额
	private List<OaCommonExpenseDetail> oaCommonExpenseDetailList = Lists.newArrayList();		// 子表列表
	
	private OaCommonAudit oaCommonAudit;//审批主表
	
	public OaCommonExpense() {
		super();
	}

	public OaCommonExpense(String id){
		super(id);
	}

	@ExcelField(title="报销总额", align=2, sort=1)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	public List<OaCommonExpenseDetail> getOaCommonExpenseDetailList() {
		return oaCommonExpenseDetailList;
	}

	public void setOaCommonExpenseDetailList(List<OaCommonExpenseDetail> oaCommonExpenseDetailList) {
		this.oaCommonExpenseDetailList = oaCommonExpenseDetailList;
	}

	public OaCommonAudit getOaCommonAudit() {
		return oaCommonAudit;
	}

	public void setOaCommonAudit(OaCommonAudit oaCommonAudit) {
		this.oaCommonAudit = oaCommonAudit;
	}
}