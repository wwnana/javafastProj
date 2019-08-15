package com.javafast.modules.qws.service;

import com.javafast.common.utils.StringUtils;
import com.javafast.modules.qws.entity.QwsSuiteNotice;
import com.javafast.modules.qws.utils.ProviderConstantUtils;
import com.javafast.modules.qws.utils.ProviderUtils;
import com.javafast.modules.qws.utils.SuiteUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.api.qywxs.aes.AesException;
import com.javafast.api.qywxs.aes.WXBizMsgCrypt;
import com.javafast.api.qywxs.auth.entity.PermanentInfo;
import com.javafast.api.qywxs.message.req.TextMessage;
import com.javafast.api.qywxs.message.util.MessageUtil;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

/**
 * 企业微信消息处理服务
 * 
 * @author syh
 *
 */
@Component
public class MessageCompanyService {

	private String msg_signature; // 微信加密签名
	private String timestamp; // 时间戳
	private String nonce; // 随机数

	/**
	 * 指令回调消息处理
	 * 发生授权、通讯录变更、ticket变化等事件处理方法
	 * @param request
	 * @return
	 */
	public String getEncryptRespMessageCallBack(HttpServletRequest request) {

		//响应码，返回给微信
		String respMessage = "failure";
		
		
		try {

			// 1.解密微信发过来的消息，用企业微信服务商的东西来解密
			String xmlMsg = this.getDecryptMsgCallBack(request);

			// 2.解析微信发来的请求,解析xml字符串
			Map<String, String> requestMap = MessageUtil.parseXml(xmlMsg);

			// 消息类型
			String infoType = requestMap.get("InfoType");

			// 第三方应用的SuiteId
			String suiteId = requestMap.get("SuiteId");

			// 时间戳
			String timeStamp = requestMap.get("TimeStamp");
			
			System.out.println("InfoType：" + infoType);
			System.out.println("SuiteId：" + suiteId);
			System.out.println("TimeStamp：" + timeStamp);
			
			//记录回调消息
			QwsSuiteNotice qwsSuiteNotice =  new QwsSuiteNotice();
			qwsSuiteNotice.setRequestUrl(request.getRequestURL()+request.getQueryString());
			qwsSuiteNotice.setRequestBody(xmlMsg);
			qwsSuiteNotice.setInfoType(infoType);
			qwsSuiteNotice.setSuiteId(suiteId);
			qwsSuiteNotice.setTimestamp(timeStamp);
			

			// 推送suite_ticket 企业微信服务器会定时（每十分钟）推送ticket。ticket会实时变更，并用于后续接口的调用。
			if (StringUtils.equals(infoType, "suite_ticket")) {
				System.out.println("推送suite_ticke");
				respMessage = "success";

				// Ticket内容，最长为512字节
				String suiteTicket = requestMap.get("SuiteTicket");
				
				qwsSuiteNotice.setSuiteTicket(suiteTicket);
				
				//设置ticket到缓存
				SuiteUtils.setSuiteTicket(suiteTicket);
			}

			// 授权成功通知
			if (StringUtils.equals(infoType, "create_auth")) {
				System.out.println("授权成功通知create_auth");
				respMessage = "success";

				// 授权的auth_code,最长为512字节。用于获取企业的永久授权码
				String authCode = requestMap.get("AuthCode");

				qwsSuiteNotice.setAuthCode(authCode);
				System.out.println("临时授权码authCode：" + authCode);
				
				//授权企业，换取永久授权码 并创建企业账户
				PermanentInfo permanentInfo = SuiteUtils.createAuthCorp(authCode);
				if(permanentInfo != null){
					
					System.out.println("永久授权码permanentCode：" + permanentInfo.getPermanent_code());
					
					qwsSuiteNotice.setAuthCorpId(permanentInfo.getAuthCorpInfo().getCorpid());
					
					//获取企业通讯录
					SuiteUtils.loadWechatDepart(permanentInfo.getAuthCorpInfo().getCorpid());
				}
			}

			// 变更授权通知
			if (StringUtils.equals(infoType, "change_auth")) {
				System.out.println("变更授权通知change_auth");
				respMessage = "success";

				// 授权方的corpid
				String corpId = requestMap.get("AuthCorpId");
				qwsSuiteNotice.setAuthCorpId(corpId);
				
				//获取企业通讯录
				SuiteUtils.loadWechatDepart(corpId);
			}

			// 取消授权通知
			if (StringUtils.equals(infoType, "cancel_auth")) {
				System.out.println("取消授权通知cancel_auth");
				respMessage = "success";

				// 授权方的corpid
				String authCorpId = requestMap.get("AuthCorpId");
				qwsSuiteNotice.setAuthCorpId(authCorpId);
				
				//取消授权
				SuiteUtils.cancelAuthCorp(authCorpId);
			}

			// 通讯录变更事件通知
			if (StringUtils.equals(infoType, "change_contact")) {
				System.out.println("通讯录变更事件通知change_contact");
				respMessage = "success";

				// 授权方的corpid
				String corpId = requestMap.get("AuthCorpId");
				qwsSuiteNotice.setAuthCorpId(corpId);
				
				// 通讯录变更类型
				String changeType = requestMap.get("ChangeType");
				qwsSuiteNotice.setChangeType(changeType);
				
				// 新增成员事件通知
				if (StringUtils.equals(changeType, "create_user")) {

					System.out.println("更新成员事件通知create_user");

					String UserID = requestMap.get("UserID");
					String Name = requestMap.get("Name");
					String Department = requestMap.get("Department");
					String Mobile = requestMap.get("Mobile");
					String Position = requestMap.get("Position");
					String Gender = requestMap.get("Gender");
					String Email = requestMap.get("Email");
					String Avatar = requestMap.get("Avatar");
					String EnglishName = requestMap.get("EnglishName");
					String IsLeader = requestMap.get("IsLeader");
					String Telephone = requestMap.get("Telephone");
					
					//获取企业通讯录
					SuiteUtils.loadWechatDepart(corpId);
				}

				// 更新成员事件通知
				if (StringUtils.equals(changeType, "update_user")) {

					System.out.println("更新成员事件通知change_contact");

					String UserID = requestMap.get("UserID");
					String Name = requestMap.get("Name");
					String Department = requestMap.get("Department");
					String Mobile = requestMap.get("Mobile");
					String Position = requestMap.get("Position");
					String Gender = requestMap.get("Gender");
					String Email = requestMap.get("Email");
					String Avatar = requestMap.get("Avatar");
					String EnglishName = requestMap.get("EnglishName");
					String IsLeader = requestMap.get("IsLeader");
					String Telephone = requestMap.get("Telephone");
					
					//获取企业通讯录
					SuiteUtils.loadWechatDepart(corpId);
				}

				// 删除成员事件通知
				if (StringUtils.equals(changeType, "delete_user")) {

					System.out.println("删除成员事件通知delete_user");

					String userId = requestMap.get("UserID");
					
					//删除用户
					SuiteUtils.delUser(corpId, userId);
				}

				// 新增部门事件通知
				if (StringUtils.equals(changeType, "create_party")) {

					System.out.println("新增部门事件通知create_party");

					String Id = requestMap.get("Id");// 部门Id
					String Name = requestMap.get("Name");// 部门名称
					String ParentId = requestMap.get("ParentId");// 父部门id
					String Order = requestMap.get("Order");// 部门排序
					
					//获取企业通讯录
					SuiteUtils.loadWechatDepart(corpId);
				}

				// 更新部门事件通知
				if (StringUtils.equals(changeType, "update_party")) {

					System.out.println("更新部门事件通知update_party");

					String Id = requestMap.get("Id");// 部门Id
					String Name = requestMap.get("Name");// 部门名称
					String ParentId = requestMap.get("ParentId");// 父部门id
					
					//获取企业通讯录
					SuiteUtils.loadWechatDepart(corpId);
				}

				// 删除部门事件通知
				if (StringUtils.equals(changeType, "delete_party")) {

					System.out.println("删除部门事件通知delete_party");

					String departId = requestMap.get("Id");// 部门Id
					
					//删除部门
					SuiteUtils.delDepart(corpId, departId);
				}
			}
			
			qwsSuiteNotice.setStatus("1");
			ProviderUtils.saveQwsSuiteNotice(qwsSuiteNotice);
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("指令回调事件的响应码，返回给企业微信respMessage：" + respMessage);
		return respMessage;
	}

	/**
	 * 数据回调消息 处理
	 * @param request
	 * @return
	 */
	public String getEncryptRespMessageBySuite(HttpServletRequest request) {
		String respMessage = null;

		try {
			// 1.解密微信发过来的消息
			String xmlMsg = this.getDecryptMsgSuite(request);

			// 2.解析微信发来的请求,解析xml字符串
			Map<String, String> requestMap = MessageUtil.parseXml(xmlMsg);

			// 3.获取请求参数
			// 3.2 成员UserID
			String fromUserName = requestMap.get("FromUserName");
			// 3.1 企业微信CorpID
			String toUserName = requestMap.get("ToUserName");//企业微信CorpID
			String createTime = requestMap.get("CreateTime");
			// 3.3 消息类型与事件
			String msgType = requestMap.get("MsgType");
			String eventKey = requestMap.get("Event");
			String AgentId = requestMap.get("AgentId");
			
			
			//String corpid = requestMap.get("corpid");
			//System.out.println("URL支持使用$CORPID$模板参数表示corpid : "+corpid);
			
			
			for (Map.Entry<String, String> stringStringEntry : requestMap.entrySet()) {
				System.out.println(stringStringEntry.getKey() + ":" + stringStringEntry.getValue());
			}
			String respContent = "";
			if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
				// 那么这里可能是关注。关注事件。需要把用户保存到后台数据库，这样才能登录成功
				//TODO 手机登录保存
				respContent = this.processEevent(msgType, eventKey);
				//SuiteUtils.loadWechatDepart(toUserName);
			}

			// 4.组装 回复文本消息
			TextMessage textMessage = new TextMessage();
			textMessage.setToUserName(fromUserName);
			textMessage.setFromUserName(toUserName);
			textMessage.setCreateTime(System.currentTimeMillis());
			textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);
			textMessage.setContent(respContent);
			System.out.println("respContent：" + respContent);

			// 5.获取xml字符串： 将（被动回复消息型的）文本消息对象 转成 xml字符串
			respMessage = MessageUtil.textMessageToXml(textMessage);

			// 6.加密
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey,
					ProviderConstantUtils.corpId);
			respMessage = wxcpt.EncryptMsg(respMessage, timestamp, msgType);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return respMessage;
	}
	
	/**
	 * 解密微指令回调的消息 用企业微信服务商的suiteId来解密
	 * 指令回调
	 * @param request
	 * @return String 消息明文
	 */
	public String getDecryptMsgCallBack(HttpServletRequest request) {

		String postData = ""; // 密文，对应POST请求的数据
		String result = ""; // 明文，解密之后的结果

		this.msg_signature = request.getParameter("msg_signature"); // 微信加密签名
		this.timestamp = request.getParameter("timestamp"); // 时间戳
		this.nonce = request.getParameter("nonce"); // 随机数
		
		if (StringUtils.isNotBlank(request.getParameter("type"))) {
			//
			System.out.println("getDecryptMsgTicket指令回调URL");
		}
		// his.nonce = request.getParameter("nonce"); // 随机数

		try {
			// 1.获取加密的请求消息：使用输入流获得加密请求消息postData
			ServletInputStream in = request.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));

			String tempStr = ""; // 作为输出字符串的临时串，用于判断是否读取完毕
			while (null != (tempStr = reader.readLine())) {
				postData += tempStr;
			}

			// 2.获取消息明文：对加密的请求消息进行解密获得明文
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey, ProviderConstantUtils.suiteId);
			result = wxcpt.DecryptMsg(msg_signature, timestamp, nonce, postData);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (AesException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 解密数据回调消息
	 * 数据回调
	 * @param request
	 * @return String 消息明文
	 */
	public String getDecryptMsgSuite(HttpServletRequest request) {

		String postData = ""; // 密文，对应POST请求的数据
		String result = ""; // 明文，解密之后的结果

		this.msg_signature = request.getParameter("msg_signature"); // 微信加密签名
		this.timestamp = request.getParameter("timestamp"); // 时间戳
		this.nonce = request.getParameter("nonce"); // 随机数
		
		// his.nonce = request.getParameter("nonce"); // 随机数

		try {
			// 1.获取加密的请求消息：使用输入流获得加密请求消息postData
			ServletInputStream in = request.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));

			String tempStr = ""; // 作为输出字符串的临时串，用于判断是否读取完毕
			while (null != (tempStr = reader.readLine())) {
				postData += tempStr;
			}

			// 2.获取消息明文：对加密的请求消息进行解密获得明文
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey,
					ProviderConstantUtils.corpId);
			result = wxcpt.DecryptMsg(msg_signature, timestamp, nonce, postData);

		} catch (IOException e) {
			e.printStackTrace();
		} catch (AesException e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * @param request
	 * @return String 返回加密后的回复消息
	 * @desc ：获取加密后的回复消息
	 */
	public String getEncryptRespMessage(HttpServletRequest request) {
		String respMessage = null;

		try {
			// 1.解密微信发过来的消息，用企业微信服务商的东西来解密
			String xmlMsg = this.getDecryptMsg(request);

			// 2.解析微信发来的请求,解析xml字符串
			Map<String, String> requestMap = MessageUtil.parseXml(xmlMsg);

			String infoType = requestMap.get("InfoType");

			// 3.1 企业微信CorpID
			String suiteId = requestMap.get("SuiteId");
			// 3.2 成员UserID
			String timeStamp = requestMap.get("TimeStamp");
			// 3.3 消息类型与事件
			String msgType = requestMap.get("MsgType");

			System.out.println("InfoType：" + infoType);
			System.out.println("SuiteId：" + suiteId);
			System.out.println("TimeStamp：" + timeStamp);

			String respContent = this.getRespContentByMsgType(infoType, suiteId, timeStamp);

			System.out.println("respContent：" + respContent);

			return respContent;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return respMessage;
	}

	public String getRespContentByMsgType(String msgType, String eventType, String eventKey) {
		String respContent = "";
		// 1.文本消息
		if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_TEXT)) {
			respContent = "您发送的是文本消息！";

		}
		// 2.图片消息
		else if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_IMAGE)) {
			respContent = "您发送的是图片消息！";
		}
		// 3.地理位置消息
		else if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_LOCATION)) {
			System.out.println("消息类型：定位");
		}
		// 4.链接消息
		else if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_LINK)) {
			respContent = "您发送的是链接消息！";
		}
		// 5.音频消息
		else if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_VOICE)) {
			respContent = "您发送的是音频消息！";
		}
		// 6.事件推送
		else if (StringUtils.equals(msgType, MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
			respContent = this.processEevent(eventType, eventKey);
		}
		// 7.请求异常
		else {
			respContent = "请求处理异常，请稍候尝试！";
		}

		return respContent;
	}

	/***
	 * 默认消息走的
	 * 
	 * @param request
	 * @return
	 */
	public String getDecryptMsg(HttpServletRequest request) {

		String postData = ""; // 密文，对应POST请求的数据
		String result = ""; // 明文，解密之后的结果

		this.msg_signature = request.getParameter("msg_signature"); // 微信加密签名
		this.timestamp = request.getParameter("timestamp"); // 时间戳
		this.nonce = request.getParameter("nonce"); // 随机数
		if (StringUtils.isNotBlank(request.getParameter("type"))) {
			//
			System.out.println("指令回调URL");
		}
		// his.nonce = request.getParameter("nonce"); // 随机数

		try {
			// 1.获取加密的请求消息：使用输入流获得加密请求消息postData
			ServletInputStream in = request.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));

			String tempStr = ""; // 作为输出字符串的临时串，用于判断是否读取完毕
			while (null != (tempStr = reader.readLine())) {
				postData += tempStr;
			}

			// 2.获取消息明文：对加密的请求消息进行解密获得明文-这里要替换
			WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(ProviderConstantUtils.token, ProviderConstantUtils.encodingAESKey,
					ProviderConstantUtils.corpId);
			result = wxcpt.DecryptMsg(msg_signature, timestamp, nonce, postData);

		} catch (IOException e) {
			e.printStackTrace();
		} catch (AesException e) {
			e.printStackTrace();
		}

		return result;
	}

	

	public String processEevent(String eventType, String eventKey) {

		String respContent = "";
		// 订阅
		if (eventKey.equals(MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
			respContent = "欢迎关注！";
		}
		// 取消订阅
		else if (eventKey.equals(MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
			// TODO 取消订阅后用户再收不到公众号发送的消息，因此不需要回复消息
		}
		// 上报地理位置事件
		else if (eventKey.equals("LOCATION")) {

		}
		// 自定义菜单点击事件
		else if (eventType.equals(MessageUtil.EVENT_TYPE_CLICK)) {

		}
		return respContent;
	}

}