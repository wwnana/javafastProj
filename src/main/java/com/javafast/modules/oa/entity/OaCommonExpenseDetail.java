package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 报销单Entity
 * @author javafast
 * @version 2017-08-25
 */
public class OaCommonExpenseDetail extends DataEntity<OaCommonExpenseDetail> {
	
	private static final long serialVersionUID = 1L;
	private OaCommonExpense expense;		// 报销单ID 父类
	private String itemName;		// 报销事项
	private Date date;		// 日期
	private BigDecimal amount;		// 报销金额（元）
	
	public OaCommonExpenseDetail() {
		super();
	}

	public OaCommonExpenseDetail(String id){
		super(id);
	}

	public OaCommonExpenseDetail(OaCommonExpense expense){
		this.expense = expense;
	}

	public OaCommonExpense getExpense() {
		return expense;
	}

	public void setExpense(OaCommonExpense expense) {
		this.expense = expense;
	}
	
	@Length(min=0, max=50, message="报销事项长度必须介于 0 和 50 之间")
	@ExcelField(title="报销事项", align=2, sort=2)
	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="日期", align=2, sort=3)
	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
	@ExcelField(title="报销金额（元）", align=2, sort=4)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
}