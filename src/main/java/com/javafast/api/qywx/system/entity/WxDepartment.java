package com.javafast.api.qywx.system.entity;

import java.io.Serializable;

/**
 * 企业微信 - 部门
 * @author JavaFast
 */
public class WxDepartment implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String id; //部门id
	private String name;//部门名称
	private String parentid;//父亲部门id。根部门为1
	private Integer order;//在父部门中的次序值。order值大的排序靠前。值范围是[0, 2^32)
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getParentid() {
		return parentid;
	}
	public void setParentid(String parentid) {
		this.parentid = parentid;
	}
	public Integer getOrder() {
		return order;
	}
	public void setOrder(Integer order) {
		this.order = order;
	}
}
