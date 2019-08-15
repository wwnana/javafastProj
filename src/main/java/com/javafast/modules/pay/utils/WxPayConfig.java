package com.javafast.modules.pay.utils;

import com.javafast.common.config.Global;

/**
 * 微信支付基础配置类 
 * @author syh
 *
 */
public class WxPayConfig {

	//统一下单 请求地址
	public static final String UFDODER_URL = "https://api.mch.weixin.qq.com/pay/unifiedorder";
	
	//公众账号ID
	public static final String appid = Global.getConfig("wxpay.config.appid");
	
	//商户号
	public static final String mch_id = Global.getConfig("wxpay.config.mch_id");
	
	//api秘钥
	public static final String key = Global.getConfig("wxpay.config.key");
	
	//通知地址  异步接收微信支付结果通知的回调地址，通知url必须为外网可访问的url，不能携带参数。
	public static final String notify_url = Global.getConfig("wxpay.config.notify_url");
}
