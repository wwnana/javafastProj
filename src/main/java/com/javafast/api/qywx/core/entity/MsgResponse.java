package com.javafast.api.qywx.core.entity;

import java.io.Serializable;

/**
 * 企业微信 - 返回信息
 * @author JavaFast
 */
public class MsgResponse implements Serializable {

	private static final long serialVersionUID = 7139499962555573590L;

	private Integer errcode;
	private String errmsg;
	
	public Integer getErrcode() {
		return errcode;
	}
	public void setErrcode(Integer errcode) {
		this.errcode = errcode;
	}
	public String getErrmsg() {
		return errmsg;
	}
	public void setErrmsg(String errmsg) {
		this.errmsg = errmsg;
	}
	
	@Override
	public String toString() {
		return "MsgResponse [errcode=" + errcode + ", errmsg=" + errmsg + "]";
	}
}
