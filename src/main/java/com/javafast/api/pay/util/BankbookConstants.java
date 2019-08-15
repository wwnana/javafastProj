package com.javafast.api.pay.util;

/**
 * 错误码静态参数配置
 * @author JavaFast
 */
public class BankbookConstants {

	public static final String SUCCESS_CODE0 = "0"; //没有错误
	
	public static final String ERROR_CODE101 = "101"; //交易金额小于或等于0
			
	public static final String ERROR_CODE102 = "102"; //同一个订单号重复交易
	
	public static final String ERROR_CODE103 = "103"; //账户不存在
	
	public static final String ERROR_CODE104 = "104"; //余额不足
	
	public static final String MONEY_TYPE10 = "10"; //充值
	public static final String MONEY_TYPE11 = "11"; //提现
	public static final String MONEY_TYPE12 = "12"; //订单支付
	public static final String MONEY_TYPE13 = "13"; //订单支付退款
}
