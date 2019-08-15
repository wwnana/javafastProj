package com.javafast.modules.qws.utils;

import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.message.api.WxMessageAPI;
import com.javafast.api.qywx.message.entity.MessageText;
import com.javafast.api.qywx.message.entity.MessageTextData;
import com.javafast.common.config.Global;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.entity.SysAccount;

/**
 * 企业微信消息工具
 * @author syh
 *
 */
public class WorkWechatMsgUtils {

	private static SysAccountDao sysAccountDao = SpringContextHolder.getBean(SysAccountDao.class);
	
	/**
	 * 发消息给单个成员
	 * @param userId
	 * @param content
	 * @param accountId
	 */
	public static void sendMsg(String userId, String content, String accountId){
		
		AccessToken accessToken = WorkWechatUtils.getAccessToken(accountId);
		if(accessToken != null && StringUtils.isNotBlank(userId)){
			
			SysAccount sysAccount = sysAccountDao.get(accountId);
			
			//通知审批人
			MessageText text = new MessageText();
			text.setTouser(userId);
			text.setMsgtype("text");
			text.setAgentid(sysAccount.getAgentid());
			MessageTextData textData = new MessageTextData();
			textData.setContent(content + "["+Global.getConfig("productName")+"]");
			text.setText(textData);
			
			WxMessageAPI.sendTextMessage(text, accessToken.getAccessToken());
			
			System.out.println("agentid："+sysAccount.getAgentid());
			System.out.println("接收人："+userId);
			System.out.println("内容："+content);
		}
	}
	
	/**
	 * 发送消息给所有成员
	 * @param content
	 * @param accountId
	 */
	public static void sendMsgToAll(String content, String accountId){
		
		AccessToken accessToken = WorkWechatUtils.getAccessToken(accountId);
		if(accessToken != null){
			
			SysAccount sysAccount = sysAccountDao.get(accountId);
			
			//通知审批人
			MessageText text = new MessageText();
			text.setTouser("@all");
			text.setMsgtype("text");
			text.setAgentid(sysAccount.getAgentid());
			MessageTextData textData = new MessageTextData();
			textData.setContent(content);
			text.setText(textData);
			
			WxMessageAPI.sendTextMessage(text, accessToken.getAccessToken());
		}
	}
}
