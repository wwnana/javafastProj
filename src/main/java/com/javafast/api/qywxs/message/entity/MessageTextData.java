package com.javafast.api.qywxs.message.entity;

/**
 * 企业微信 - 文本消息内容
 * @author JavaFast
 */
public class MessageTextData {

	private String content;//消息内容，最长不超过2048个字节

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	
}
