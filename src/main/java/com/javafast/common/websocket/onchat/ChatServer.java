package com.javafast.common.websocket.onchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.java_websocket.WebSocket;
import org.java_websocket.WebSocketImpl;
import org.java_websocket.framing.Framedata;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.json.AjaxJson;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.websocket.utils.Constant;
import com.javafast.modules.iim.entity.ChatHistory;
import com.javafast.modules.iim.entity.LayGroupUser;
import com.javafast.modules.iim.entity.MailBox;
import com.javafast.modules.iim.service.ChatHistoryService;
import com.javafast.modules.iim.service.LayGroupService;
import com.javafast.modules.iim.service.MailBoxService;
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.service.OaNotifyService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 聊天服务器
 * @author JavaFast
 */
public class ChatServer extends WebSocketServer {

	public ChatServer(int port) throws UnknownHostException {
		super(new InetSocketAddress(port));
	}

	public ChatServer(InetSocketAddress address) {
		super(address);
	}

	/**
	 * 触发连接事件
	 */
	@Override
	public void onOpen(WebSocket conn, ClientHandshake handshake) {
		// Collection<String> onlineUsers = ChatServerPool.getOnlineUser();
		// AjaxJson j = new AjaxJson();
		// j.put("data", onlineUsers);
		// ChatServerPool.sendMessageToUser(conn,
		// "_online_all_status_"+j.getJsonStr());//首次登陆系统时，获取用户的在线状态
		// System.out.println("有新连接加入！当前在线人数为"+j.toString());
	}

	/**
	 * 触发关闭事件
	 */
	@Override
	public void onClose(WebSocket conn, int code, String reason, boolean remote) {
		userLeave(conn);
		Collection<String> onlineUsers = ChatServerPool.getOnlineUser();
		AjaxJson j = new AjaxJson();
		j.put("data", onlineUsers);
		ChatServerPool.sendMessage("_online_all_status_" + j.getJsonStr());// 通知所有用户更新在线信息
	}

	/**
	 * 客户端发送消息到服务器时触发事件
	 */
	@Override
	public void onMessage(WebSocket conn, String message) {
		message = message.toString();

		ChatHistoryService chatHistoryService = SpringContextHolder.getBean("chatHistoryService");
		LayGroupService layGroupService = SpringContextHolder.getBean("layGroupService");
		JSONObject json = JSON.parseObject(message.toString());
		String subtype =  json.getString("subtype");
		if (StringUtils.equals(subtype, Constant._online_user_)) {
			//System.out.println("用户上线");
			String userId = json.getString("userId");
			this.userjoin(userId, conn);

			// 通知所有用户更新在线信息
			Collection<String> onlineUsers = ChatServerPool.getOnlineUser();
			AjaxJson j = new AjaxJson();
			j.put("users", onlineUsers);
			j.put("subtype", "_online_all_status_");
			ChatServerPool.sendMessage(j.getJsonStr());// 通知所有用户更新在线信息
			// 读取离线信息
			ChatHistory chat = new ChatHistory();
			chat.setUserid2(userId);
			chat.setStatus("0");
			List<ChatHistory> list = chatHistoryService.findList(chat);
			for (ChatHistory c : list) {
				String userid1 = c.getUserid1();
				String sender = c.getUserid1();
				if ("group".equals(c.getType())) {
					sender = c.getUserid1().split(Constant._msg_)[0];
					userid1 = c.getUserid1().split(Constant._msg_)[1];
				}
				AjaxJson msgJson = new AjaxJson();
				msgJson.put("subtype", Constant._msg_);
				msgJson.put("fromUser", sender);
				msgJson.put("toUser", c.getUserid2());
				msgJson.put("content", c.getMsg());
				msgJson.put("avatar", UserUtils.getByLoginName(userid1).getPhoto());
				msgJson.put("type", c.getType());
				msgJson.put("fromUserName", UserUtils.getByLoginName(userid1).getName());
				msgJson.put("datatime", c.getCreateDate().getTime());
				// sender+Constant._msg_+
				// c.getUserid2()+Constant._msg_
				ChatServerPool.sendMessageToUser(conn, msgJson.getJsonStr());// 向所某用户发送消息
				// ChatServerPool.sendMessageToUser(conn,
				// sender+Constant._msg_+c.getUserid2()+Constant._msg_+c.getMsg()+Constant._msg_+UserUtils.getByLoginName(userid1).getPhoto()+Constant._msg_+c.getType()+Constant._msg_+UserUtils.getByLoginName(userid1).getName()+Constant._msg_+c.getCreateDate().getTime());//向所某用户发送消息
				c.setStatus("1");// 标记为已读
				chatHistoryService.save(c);
			}
			
//			//未读公告通知的条数
//			OaNotifyService oaNotifyService = SpringContextHolder.getBean("oaNotifyService");
//			OaNotify oaNotify = new OaNotify();
//			oaNotify.setSelf(true);
//			oaNotify.setReadFlag("0");
//			oaNotify.setCurrentUser(UserUtils.getByLoginName(userId));
//			Long oaNotifyCount = oaNotifyService.findCount(oaNotify);
//			if(oaNotifyCount > 0){
//				AjaxJson oaJson = new AjaxJson();
//				oaJson.put("subtype",Constant.OA_NOTIFY_MSG);
//				ChatServerPool.sendMessageToUser(conn,oaJson.getJsonStr());// 
//			}
			
			//未读内部邮件消息的条数
			MailBoxService mailBoxService = SpringContextHolder.getBean("mailBoxService");
			MailBox serachBox = new MailBox();
			serachBox.setReadstatus("0");
			serachBox.setReceiver(UserUtils.getByLoginName(userId));
			int mailBoxCount = mailBoxService.getCount(serachBox);
			if(mailBoxCount > 0){
				
				AjaxJson mailBoxJson = new AjaxJson();
				mailBoxJson.put("subtype",Constant.OA_MAIL_MSG);
				ChatServerPool.sendMessageToUser(conn, mailBoxJson.getJsonStr());
			}
			
			
		} else if (StringUtils.equals(subtype, Constant._leave_user_)) {// 用户离线
			System.out.println("用户离线");
			this.userLeave(conn);
			Collection<String> onlineUsers = ChatServerPool.getOnlineUser();
			AjaxJson j = new AjaxJson();
			j.put("subtype", Constant._online_user_);
			j.put("users", onlineUsers);
			ChatServerPool.sendMessage( j.getJsonStr());// 通知所有用户更新在线信息
		} else if (StringUtils.equals(subtype, Constant._msg_)) {// 发送消息
			System.out.println("用户消息");
			String fromUser = json.getString("fromUser");
			String toUser = json.getString("toUser");// 如果是私聊就是用户id，如果是群聊就是群组id
			String content = json.getString("content");
			String avatar = json.getString("avatar") ;
			String type = json.getString("type");
			String fromUsername =json.getString("fromUsername");
			String datatime =json.getString("datatime");

			// 保存聊天记录
			ChatHistory chat = new ChatHistory();

			if ("group".equals(type)) {// 如果是群聊

				List<LayGroupUser> layGroupUserlist = new ArrayList();
				// 群主
				LayGroupUser owner = new LayGroupUser();
				owner.setUser(layGroupService.get(toUser).getCreateBy());
				layGroupUserlist.add(owner);
				// 群成员
				List<LayGroupUser> zlist = layGroupService.get(toUser).getLayGroupUserList();
				layGroupUserlist.addAll(zlist);

				for (LayGroupUser lgUser : layGroupUserlist) {
					if (fromUser.equals(lgUser.getUser().getLoginName())) {
						continue;// 群聊消息不发给自己。
					}
					WebSocket toUserConn = ChatServerPool.getWebSocketByUser(lgUser.getUser().getLoginName());
					// 群聊时信息先发送给群聊id（即toUser)，在后台转发给所有非发送者的人的话，toUser就变成发送者。
					String groupId = toUser;
					// 保存聊天记录
					chat.setUserid1(groupId + Constant._msg_ + fromUser);// 群聊时保存群聊id和发送者id
					chat.setUserid2(lgUser.getUser().getLoginName());// 群中所有信息获得者人员
					chat.setMsg(content);
					chat.setCreateDate(new Date());
					chat.setType("group");
					if (toUserConn != null) {
						AjaxJson msgJson = new AjaxJson();
						msgJson.put("subtype", Constant._msg_);
						msgJson.put("fromUser", groupId);
						msgJson.put("toUser",lgUser.getUser().getLoginName());
						msgJson.put("content", content);
						msgJson.put("avatar", avatar);
						msgJson.put("type", type);
						msgJson.put("fromUserName", fromUsername);
						msgJson.put("datatime", datatime);
						ChatServerPool.sendMessageToUser(toUserConn, msgJson.getJsonStr());// 向所某用户发送消息
						chat.setStatus("1");// 设置为已读
					} else {
						// ChatServerPool.sendMessageToUser(conn,
						// toUser+"_sys_对方现在离线，他将在上线后收到你的消息!");//同时向本人发送消息
						chat.setStatus("0");// 设置为未读
					}
				}
			} else {// 如果是私聊
				chat.setUserid1(fromUser);
				chat.setUserid2(toUser);
				chat.setMsg(content);
				chat.setType("friend");
				chat.setCreateDate(new Date());
				WebSocket toUserConn = ChatServerPool.getWebSocketByUser(toUser);
				if (toUserConn != null) {
					AjaxJson msgJson = new AjaxJson();
					msgJson.put("subtype", Constant._msg_);
					msgJson.put("fromUser", fromUser);
					msgJson.put("toUser",toUser);
					msgJson.put("content", content);
					msgJson.put("avatar", avatar);
					msgJson.put("type", type);
					msgJson.put("fromUserName", fromUsername);
					msgJson.put("datatime", datatime);
					ChatServerPool.sendMessageToUser(toUserConn, msgJson.getJsonStr());// 向所某用户发送消息
					chat.setStatus("1");// 设置为已读
				} else {
					AjaxJson sysJson = new AjaxJson();
					sysJson.put("subtype", "_sys_");
					sysJson.put("fromId", toUser);
					sysJson.put("contents", "对方现在离线，他将在上线后收到你的消息!");
					ChatServerPool.sendMessageToUser(conn, sysJson.getJsonStr());
					// ChatServerPool.sendMessageToUser(conn,
					// toUser+"_sys_对方现在离线，他将在上线后收到你的消息!");//同时向本人发送消息
					chat.setStatus("0");// 设置为未读
				}
			}

			chatHistoryService.save(chat);

		}
	}

	/*
	 * @Override public void onMessage(WebSocket conn, String message){ message
	 * = message.toString(); if(null != message &&
	 * message.startsWith(Constant._online_user_)){//用户上线
	 * System.out.println("用户上线"); String userId =
	 * message.replaceFirst(Constant._online_user_, "");
	 * this.userjoin(userId,conn);
	 * 
	 * //通知所有用户更新在线信息 Collection<String> onlineUsers =
	 * ChatServerPool.getOnlineUser(); AjaxJson j = new AjaxJson();
	 * j.put("data", onlineUsers); j.put("type", "_online_all_status_");
	 * ChatServerPool.sendMessage(j.getJsonStr());//通知所有用户更新在线信息 OaNotifyService
	 * oaNotifyService = SpringContextHolder.getBean("oaNotifyService");
	 * //读取未读通知 OaNotify oaNotify = new OaNotify(); oaNotify.setSelf(true);
	 * oaNotify.setReadFlag("0");
	 * oaNotify.setCurrentUser(UserUtils.getByLoginName(userId)); Long count=
	 * oaNotifyService.findCount(oaNotify); AjaxJson oaJson = new AjaxJson();
	 * oaJson.put("type", "oaNotify"); oaJson.put("count", count.intValue());
	 * ChatServerPool.sendMessage(oaJson.getJsonStr());//通知所有用户更新在线信息 }
	 * //**修改消息为已读 }
	 */

	@Override
	public void onMessage(WebSocket conn, ByteBuffer buffer) {
		System.out.println("执行了发送消息的动作2");
		Charset charset = null;
		CharsetDecoder decoder = null;
		CharBuffer charBuffer = null;
		try {
			charset = Charset.forName("UTF-8");
			decoder = charset.newDecoder();
			// charBuffer = decoder.decode(buffer);//用这个的话，只能输出来一次结果，第二次显示为空
			charBuffer = decoder.decode(buffer.asReadOnlyBuffer());
			// return charBuffer.toString();
			System.out.println(charBuffer.toString());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void onFragment(WebSocket conn, Framedata fragment) {
	}

	/**
	 * 触发异常事件
	 */
	@Override
	public void onError(WebSocket conn, Exception ex) {
		ex.printStackTrace();
		if (conn != null) {
			// some errors like port binding failed may not be assignable to a
			// specific websocket
		}
	}

	/**
	 * 用户加入处理
	 * 
	 * @param user
	 */
	public void userjoin(String user, WebSocket conn) {
		// AjaxJson j = new AjaxJson();
		// j.put("type", "user_join");
		// j.put("user", "<a onclick=\"toUserMsg('"+user+"');\">"+user+"</a>");
		// MsgServerPool.sendMessage(j.getJsonStr()); //把当前用户加入到所有在线用户列表中
		// String joinMsg =
		// "{\"from\":\"[系统]\",\"content\":\""+user+"上线了\",\"timestamp\":"+new
		// Date().getTime()+",\"type\":\"message\"}";
		// MsgServerPool.sendMessage(joinMsg); //向所有在线用户推送当前用户上线的消息
		// j = new AjaxJson();
		// j.put("type", "get_online_user");
		ChatServerPool.addUser(user, conn); // 向连接池添加当前的连接对象
		// j.put("list", MsgServerPool.getOnlineUser());
		// MsgServerPool.sendMessageToUser(conn, j.getJsonStr());
		// //向当前连接发送当前在线用户的列表
	}

	/**
	 * 用户下线处理
	 * 
	 * @param user
	 */
	public void userLeave(WebSocket conn) {
		String user = ChatServerPool.getUserByKey(conn);
		boolean b = ChatServerPool.removeUser(conn); // 在连接池中移除连接
		// if(b){
		// AjaxJson j = new AjaxJson();
		// j.put("type", "user_leave");
		// j.put("user", "<a onclick=\"toUserMsg('"+user+"');\">"+user+"</a>");
		// MsgServerPool.sendMessage(j.getJsonStr()); //把当前用户从所有在线用户列表中删除
		// String joinMsg =
		// "{\"from\":\"[系统]\",\"content\":\""+user+"下线了\",\"timestamp\":"+new
		// Date().getTime()+",\"type\":\"message\"}";
		// MsgServerPool.sendMessage(joinMsg); //向在线用户发送当前用户退出的消息
		// }
	}

	public static void main(String[] args) throws InterruptedException, IOException {
		WebSocketImpl.DEBUG = false;
		int port = 8667; // 端口
		ChatServer s = new ChatServer(port);
		s.start();
		// System.out.println( "服务器的端口" + s.getPort() );
	}

}
