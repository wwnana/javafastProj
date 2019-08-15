package com.javafast.modules.pay.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 微信支付通知Entity
 */
public class PayWxpayLog extends DataEntity<PayWxpayLog> {
	
	private static final long serialVersionUID = 1L;
	private String appid;		// 公众账号
	private String mchId;		// 商户号
	private String sign;		// 签名
	private String signType;		// 签名类型
	private String resultCode;		// 业务结果
	private String errCode;		// 错误代码
	private String tradeType;		// 交易类型
	private String bankType;		// 付款银行
	private String openid;		// 用户标识
	private BigDecimal totalFee;		// 订单金额
	private BigDecimal cashFee;		// 现金支付金额
	private String transactionId;		// 微信支付订单号
	private String outTradeNo;		// 商户订单号
	private String timeEnd;		// 支付完成时间
	private String status;		// 付款通知处理状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public PayWxpayLog() {
		super();
	}

	public PayWxpayLog(String id){
		super(id);
	}

	@Length(min=0, max=50, message="公众账号长度必须介于 0 和 50 之间")
	@ExcelField(title="公众账号", align=2, sort=1)
	public String getAppid() {
		return appid;
	}

	public void setAppid(String appid) {
		this.appid = appid;
	}
	
	@Length(min=0, max=50, message="商户号长度必须介于 0 和 50 之间")
	@ExcelField(title="商户号", align=2, sort=2)
	public String getMchId() {
		return mchId;
	}

	public void setMchId(String mchId) {
		this.mchId = mchId;
	}
	
	@Length(min=0, max=50, message="签名长度必须介于 0 和 50 之间")
	@ExcelField(title="签名", align=2, sort=3)
	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}
	
	@Length(min=0, max=50, message="签名类型长度必须介于 0 和 50 之间")
	@ExcelField(title="签名类型", align=2, sort=4)
	public String getSignType() {
		return signType;
	}

	public void setSignType(String signType) {
		this.signType = signType;
	}
	
	@Length(min=0, max=50, message="业务结果长度必须介于 0 和 50 之间")
	@ExcelField(title="业务结果", align=2, sort=5)
	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	
	@Length(min=0, max=50, message="错误代码长度必须介于 0 和 50 之间")
	@ExcelField(title="错误代码", align=2, sort=6)
	public String getErrCode() {
		return errCode;
	}

	public void setErrCode(String errCode) {
		this.errCode = errCode;
	}
	
	@Length(min=0, max=30, message="交易类型长度必须介于 0 和 30 之间")
	@ExcelField(title="交易类型", align=2, sort=7)
	public String getTradeType() {
		return tradeType;
	}

	public void setTradeType(String tradeType) {
		this.tradeType = tradeType;
	}
	
	@Length(min=0, max=50, message="付款银行长度必须介于 0 和 50 之间")
	@ExcelField(title="付款银行", align=2, sort=8)
	public String getBankType() {
		return bankType;
	}

	public void setBankType(String bankType) {
		this.bankType = bankType;
	}
	
	@Length(min=0, max=50, message="用户标识长度必须介于 0 和 50 之间")
	@ExcelField(title="用户标识", align=2, sort=9)
	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}
	
	@ExcelField(title="订单金额", align=2, sort=10)
	public BigDecimal getTotalFee() {
		return totalFee;
	}

	public void setTotalFee(BigDecimal totalFee) {
		this.totalFee = totalFee;
	}
	
	@ExcelField(title="现金支付金额", align=2, sort=11)
	public BigDecimal getCashFee() {
		return cashFee;
	}

	public void setCashFee(BigDecimal cashFee) {
		this.cashFee = cashFee;
	}
	
	@Length(min=0, max=50, message="微信支付订单号长度必须介于 0 和 50 之间")
	@ExcelField(title="微信支付订单号", align=2, sort=12)
	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
	
	@Length(min=0, max=50, message="商户订单号长度必须介于 0 和 50 之间")
	@ExcelField(title="商户订单号", align=2, sort=13)
	public String getOutTradeNo() {
		return outTradeNo;
	}

	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}
	
	@Length(min=0, max=50, message="支付完成时间长度必须介于 0 和 50 之间")
	@ExcelField(title="支付完成时间", align=2, sort=14)
	public String getTimeEnd() {
		return timeEnd;
	}

	public void setTimeEnd(String timeEnd) {
		this.timeEnd = timeEnd;
	}
	
	@Length(min=0, max=1, message="付款通知处理状态长度必须介于 0 和 1 之间")
	@ExcelField(title="付款通知处理状态", dictType="paylog_status", align=2, sort=15)
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