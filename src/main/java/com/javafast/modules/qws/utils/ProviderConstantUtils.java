package com.javafast.modules.qws.utils;

import com.javafast.common.config.Global;

/**
 * 企业微信服务商 常量  （第三方）
 * 获取方法为：登录服务商管理后台->标准应用服务->通用开发参数，可以看到
 * @author JavaFast
 */
public class ProviderConstantUtils {

	//服务商的corpid (获取方法为：登录服务商管理后台->标准应用服务->通用开发参数，可以看到)
	public static final String corpId = Global.getConfig("qywx.service.corpid");
	
	//服务商的secret (获取方法为：登录服务商管理后台->标准应用服务->通用开发参数，可以看到)
	public static final String providerSecret = Global.getConfig("qywx.service.provider_secret");
	
	//第三方应用suite_id (获取方法为：登录服务商管理后台->标准应用服务->本地应用->基本信息，可以看到)
	public static final String suiteId = Global.getConfig("qywx.service.suite_id");
	
	//secret
	public static String secret = Global.getConfig("qywx.service.secret");
	
	//自定义参数 可填a-zA-Z0-9的参数值（不超过128个字节），用于第三方自行校验session，防止跨域攻击
	public static final String state = Global.getConfig("qywx.service.state");
	
	//回调配置Token
	public static String token = Global.getConfig("qywx.service.token");
	
	//回调配置EncodingAESKey
	public static String encodingAESKey = Global.getConfig("qywx.service.encodingAESKey");
	
	//网页扫码授权登录回调URL
	public static String qrcode_login_redirect_url = Global.getConfig("qywx.service.qrcode_login_redirect_url");
	
	//在企业微信应用内网页授权登录第三方回调URL
	public static String mobile_login_redirect_url = Global.getConfig("qywx.service.mobile_login_redirect_url");
}
