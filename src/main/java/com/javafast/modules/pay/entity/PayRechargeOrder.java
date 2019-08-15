package com.javafast.modules.pay.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 充值订单Entity
 * @author javafast
 * @version 2018-03-21
 */
public class PayRechargeOrder extends DataEntity<PayRechargeOrder> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 订单编号
	private BigDecimal amount;		// 订单金额
	private String status;		// 支付完成状态
	private String payType;		// 支付类型
	private String notes;   //商品描述
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public PayRechargeOrder() {
		super();
	}

	public PayRechargeOrder(String id){
		super(id);
	}

	@Length(min=0, max=50, message="订单编号长度必须介于 0 和 50 之间")
	@ExcelField(title="订单编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@ExcelField(title="订单金额", align=2, sort=2)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@Length(min=0, max=1, message="支付完成状态长度必须介于 0 和 1 之间")
	@ExcelField(title="支付完成状态", dictType="yes_no", align=2, sort=3)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@Length(min=0, max=1, message="支付类型长度必须介于 0 和 1 之间")
	@ExcelField(title="支付类型", dictType="pay_type", align=2, sort=4)
	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}
	
	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}
	
	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
		
}