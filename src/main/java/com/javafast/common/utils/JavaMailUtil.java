package com.javafast.common.utils;

import org.springframework.core.io.Resource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

/**
 * Java Mail工具
 * @author syh
 *
 */
public class JavaMailUtil {
		
	/*
	 * 发件人的 邮箱 和 密码（替换为自己的邮箱和密码） PS: 某些邮箱服务器为了增加邮箱本身密码的安全性，给 SMTP
	 * 客户端设置了独立密码（有的邮箱称为“授权码”）, 对于开启了独立密码的邮箱, 这里的邮箱密码必需使用这个独立密码（授权码）。 发件人邮箱的
	 * SMTP 服务器地址, 必须准确, 不同邮件服务器地址不同, 一般(只是一般, 绝非绝对)格式为: smtp.xxx.com 网易163邮箱的
	 * SMTP 服务器地址为: smtp.163.com 收件人邮箱（替换为自己知道的有效邮箱）
	 */
	public static JavaMailSenderImpl getSimpleMailSend(String emailUserAccount, String emailPassword, String host, Integer port) {
		
		JavaMailSenderImpl senderImpl = new JavaMailSenderImpl();
		// 这是设置发送邮件的服务器，一旦指定，那么下面设置的发送者就必须是这种类型的邮箱，像这里是163邮箱服务器，那么下面的
		// 发送者就必须要是163邮箱
		senderImpl.setHost(host);
		if (port != null) {
			senderImpl.setPort(port);
		}
		// 这是设置邮箱的验证
		Properties properties = new Properties();
		properties.setProperty("mail.smtp.auth", "true");// 开启认证
		properties.setProperty("mail.debug", "true");// 启用调试
		properties.setProperty("mail.smtp.timeout", "2000");// 设置链接超时
		properties.setProperty("mail.smtp.port", Integer.toString(port));// 设置端口
		properties.setProperty("mail.smtp.socketFactory.port", Integer.toString(port));// 设置ssl端口
		properties.setProperty("mail.smtp.socketFactory.fallback", "false");
		properties.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		senderImpl.setJavaMailProperties(properties);
		// 这是邮箱的用户名
		senderImpl.setUsername(emailUserAccount);
		// 这是邮箱密码
		senderImpl.setPassword(emailPassword);
		return senderImpl;
	}

	/**
	 * 发送文本邮件
	 *
	 * @param mailSender
	 * @param mailFrom 发件人
	 * @param toMail 接收人
	 * @param subject 邮件标题
	 * @param text 文本内容
	 */
	public static void sendTextMail(JavaMailSenderImpl mailSender, String mailFrom, String toMail, String subject,
			String text) {
		SimpleMailMessage mail = new SimpleMailMessage();
		mail.setFrom(mailFrom);
		mail.setTo(toMail);
		mail.setSubject(subject);
		mail.setSentDate(new Date());// 邮件发送时间
		mail.setText(text);
		mailSender.send(mail);
	}

	/**
	 * 发送HTML邮件
	 * @param mailSender
	 * @param mailFrom 发件人
	 * @param toMail 接收人
	 * @param subject 邮件标题
	 * @param html HTML内容
	 * @throws MessagingException
	 */
	public static void sendHtmlMail(JavaMailSenderImpl mailSender, String mailFrom, String toMail, String subject,
			String html) throws MessagingException {
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		// 设置utf-8或GBK编码，否则邮件会有乱码
		MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
		messageHelper.setFrom(mailFrom);
		messageHelper.setTo(toMail);
		messageHelper.setSubject(subject);
		messageHelper.setText(html, true);
		mailSender.send(mimeMessage);
	}

	/**
	 * 发送含附件的HTML邮件
	 * @param mailSender
	 * @param mailFrom 发件人
	 * @param toMail 接收人
	 * @param subject 邮件标题
	 * @param html HTML内容
	 * @param contentId 附件ID
	 * @param resource 附件资源文件
	 * @throws MessagingException
	 */
	public static void sendFileMail(JavaMailSenderImpl mailSender, String mailFrom, String toMail, String subject,
			String html, String contentId, Resource resource) throws MessagingException {
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		// 设置utf-8或GBK编码，否则邮件会有乱码
		MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
		messageHelper.setFrom(mailFrom);
		messageHelper.setTo(toMail);
		messageHelper.setSubject(subject);
		messageHelper.setText(html, true);
		// FileSystemResource img = new FileSystemResource(new
		// File("c:/350.jpg"));
		messageHelper.addInline(contentId, resource);
		// 发送
		mailSender.send(mimeMessage);
	}
}
