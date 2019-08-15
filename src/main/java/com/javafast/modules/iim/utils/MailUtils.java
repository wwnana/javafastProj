package com.javafast.modules.iim.utils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.java_websocket.WebSocket;

import com.javafast.common.json.AjaxJson;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.websocket.onchat.ChatServerPool;
import com.javafast.common.websocket.utils.Constant;
import com.javafast.modules.iim.entity.Mail;
import com.javafast.modules.iim.entity.MailBox;
import com.javafast.modules.iim.entity.MailCompose;
import com.javafast.modules.iim.service.MailBoxService;
import com.javafast.modules.iim.service.MailComposeService;
import com.javafast.modules.iim.service.MailService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.UserUtils;

public class MailUtils {

	private static MailService mailService = SpringContextHolder.getBean(MailService.class);
	
	private static MailComposeService mailComposeService = SpringContextHolder.getBean(MailComposeService.class);
	
	private static MailBoxService mailBoxService = SpringContextHolder.getBean(MailBoxService.class);
	
	public static void sendMail(String title, String content, String receiverId){
		
		//邮件内容
		Mail mail = new Mail();
		mail.setTitle(title);
		mail.setOverview(title);
		mail.setContent(content);
		
		//接受人
		List<User> receiverList = new ArrayList<User>();
		receiverList.add(new User(receiverId));
		
		//发件箱
		MailCompose mailCompose = new MailCompose();
		mailCompose.setMail(mail);
		mailCompose.setReceiverList(receiverList);
		mailCompose.setStatus("1");
		
		mailService.saveOnlyMain(mailCompose.getMail());
		Date date = new Date(System.currentTimeMillis());
		mailCompose.setSender(UserUtils.getUser());
		mailCompose.setSendtime(date);
		for(User receiver : mailCompose.getReceiverList()){
			mailCompose.setReceiver(receiver);
			mailCompose.setId(null);//标记为新纪录，每次往发件箱插入一条记录
			mailComposeService.save(mailCompose);//0 显示在草稿箱，1 显示在已发送需同时保存到收信人的收件箱。
		
			if(mailCompose.getStatus().equals("1"))//已发送，同时保存到收信人的收件箱
			{
				MailBox mailBox = new MailBox();
				mailBox.setReadstatus("0");
				mailBox.setReceiver(receiver);
				mailBox.setSender(UserUtils.getUser());
				mailBox.setMail(mailCompose.getMail());
				mailBox.setSendtime(date);
				mailBoxService.save(mailBox);
			}
		}
		
		//向所某用户发送消息
		for(User receiver : mailCompose.getReceiverList()){
			
			WebSocket toUserConn = ChatServerPool.getWebSocketByUser(UserUtils.get(receiver.getId()).getLoginName());
			AjaxJson oaJson = new AjaxJson();
			oaJson.put("subtype", Constant.OA_MAIL_MSG);
			ChatServerPool.sendMessageToUser(toUserConn,oaJson.getJsonStr());
		}
	}
}
