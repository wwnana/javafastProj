package com.javafast.modules.report.entity;

import java.io.Serializable;

public class CrmDataOwn implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String ownById;
	private String officeId;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getOwnById() {
		return ownById;
	}
	public void setOwnById(String ownById) {
		this.ownById = ownById;
	}
	public String getOfficeId() {
		return officeId;
	}
	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}
	
	
}
