package com.javafast.modules.hr.utils;

import com.javafast.common.config.Global;

/**
 * HR系统邮件配置
 * @author syh
 *
 */
public class HrMailConfig {

	//系统邮件发送账号
	public static final String FROM_EMAIL = Global.getConfig("email.fromEmail");
	
	//系统邮件发送账号
	public static final String EMAIL_NAME = Global.getConfig("email.emailName");
	
	//系统邮件发送账号密码
	public static final String EMAIL_PASSWORD = Global.getConfig("email.emailPassword");
	
	//SMTP
	public static final String SMTP = Global.getConfig("email.smtp");
	
	//端口
	public static final Integer PORT = Integer.parseInt(Global.getConfig("email.port"));
}
