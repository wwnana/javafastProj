package com.javafast.modules.pay.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 支付宝支付通知Entity
 */
public class PayAlipayLog extends DataEntity<PayAlipayLog> {
	
	private static final long serialVersionUID = 1L;
	private String appid;		// 开发者应用ID
	private String sellerId;		// 卖家支付宝用户号
	private String tradeNo;		// 支付宝交易号
	private String outTradeNo;		// 商户订单号
	private String tradeStatus;		// 交易状态
	private String sign;		// 签名
	private String signType;		// 签名类型
	private String tradeType;		// 交易类型
	private String bankType;		// 付款银行
	private BigDecimal totalAmount;		// 订单金额
	private BigDecimal buyerPayAmount;		// 付款金额
	private BigDecimal receiptAmount;		// 实收金额
	private String gmtPayment;		// 交易付款时间
	private String buyerId;		// 支付宝支付账号
	private String outBizNo;		// 商户业务号
	private BigDecimal refundFee;		// 退款金额
	private String gmtRefund;		// 交易退款时间
	private String status;		// 状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public PayAlipayLog() {
		super();
	}

	public PayAlipayLog(String id){
		super(id);
	}

	@Length(min=0, max=50, message="开发者应用ID长度必须介于 0 和 50 之间")
	@ExcelField(title="开发者应用ID", align=2, sort=1)
	public String getAppid() {
		return appid;
	}

	public void setAppid(String appid) {
		this.appid = appid;
	}
	
	@Length(min=0, max=50, message="卖家支付宝用户号长度必须介于 0 和 50 之间")
	@ExcelField(title="卖家支付宝用户号", align=2, sort=2)
	public String getSellerId() {
		return sellerId;
	}

	public void setSellerId(String sellerId) {
		this.sellerId = sellerId;
	}
	
	@Length(min=0, max=50, message="支付宝交易号长度必须介于 0 和 50 之间")
	@ExcelField(title="支付宝交易号", align=2, sort=3)
	public String getTradeNo() {
		return tradeNo;
	}

	public void setTradeNo(String tradeNo) {
		this.tradeNo = tradeNo;
	}
	
	@Length(min=0, max=50, message="商户订单号长度必须介于 0 和 50 之间")
	@ExcelField(title="商户订单号", align=2, sort=4)
	public String getOutTradeNo() {
		return outTradeNo;
	}

	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}
	
	@Length(min=0, max=50, message="交易状态长度必须介于 0 和 50 之间")
	@ExcelField(title="交易状态", align=2, sort=5)
	public String getTradeStatus() {
		return tradeStatus;
	}

	public void setTradeStatus(String tradeStatus) {
		this.tradeStatus = tradeStatus;
	}
	
	@Length(min=0, max=50, message="签名长度必须介于 0 和 50 之间")
	@ExcelField(title="签名", align=2, sort=6)
	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}
	
	@Length(min=0, max=50, message="签名类型长度必须介于 0 和 50 之间")
	@ExcelField(title="签名类型", align=2, sort=7)
	public String getSignType() {
		return signType;
	}

	public void setSignType(String signType) {
		this.signType = signType;
	}
	
	@Length(min=0, max=30, message="交易类型长度必须介于 0 和 30 之间")
	@ExcelField(title="交易类型", align=2, sort=8)
	public String getTradeType() {
		return tradeType;
	}

	public void setTradeType(String tradeType) {
		this.tradeType = tradeType;
	}
	
	@Length(min=0, max=50, message="付款银行长度必须介于 0 和 50 之间")
	@ExcelField(title="付款银行", align=2, sort=9)
	public String getBankType() {
		return bankType;
	}

	public void setBankType(String bankType) {
		this.bankType = bankType;
	}
	
	@ExcelField(title="订单金额", align=2, sort=10)
	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}
	
	@ExcelField(title="付款金额", align=2, sort=11)
	public BigDecimal getBuyerPayAmount() {
		return buyerPayAmount;
	}

	public void setBuyerPayAmount(BigDecimal buyerPayAmount) {
		this.buyerPayAmount = buyerPayAmount;
	}
	
	@ExcelField(title="实收金额", align=2, sort=12)
	public BigDecimal getReceiptAmount() {
		return receiptAmount;
	}

	public void setReceiptAmount(BigDecimal receiptAmount) {
		this.receiptAmount = receiptAmount;
	}
	
	@Length(min=0, max=50, message="交易付款时间长度必须介于 0 和 50 之间")
	@ExcelField(title="交易付款时间", align=2, sort=13)
	public String getGmtPayment() {
		return gmtPayment;
	}

	public void setGmtPayment(String gmtPayment) {
		this.gmtPayment = gmtPayment;
	}
	
	@Length(min=0, max=50, message="支付宝支付账号长度必须介于 0 和 50 之间")
	@ExcelField(title="支付宝支付账号", align=2, sort=14)
	public String getBuyerId() {
		return buyerId;
	}

	public void setBuyerId(String buyerId) {
		this.buyerId = buyerId;
	}
	
	@Length(min=0, max=50, message="商户业务号长度必须介于 0 和 50 之间")
	@ExcelField(title="商户业务号", align=2, sort=15)
	public String getOutBizNo() {
		return outBizNo;
	}

	public void setOutBizNo(String outBizNo) {
		this.outBizNo = outBizNo;
	}
	
	@ExcelField(title="退款金额", align=2, sort=16)
	public BigDecimal getRefundFee() {
		return refundFee;
	}

	public void setRefundFee(BigDecimal refundFee) {
		this.refundFee = refundFee;
	}
	
	@Length(min=0, max=50, message="交易退款时间长度必须介于 0 和 50 之间")
	@ExcelField(title="交易退款时间", align=2, sort=17)
	public String getGmtRefund() {
		return gmtRefund;
	}

	public void setGmtRefund(String gmtRefund) {
		this.gmtRefund = gmtRefund;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="paylog_status", align=2, sort=18)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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
		
}