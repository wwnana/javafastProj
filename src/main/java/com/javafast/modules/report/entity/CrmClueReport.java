package com.javafast.modules.report.entity;

import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

public class CrmClueReport extends DataEntity<CrmReport> {
	
	private static final long serialVersionUID = 1L;
	
	//查询条件
	private User user;
	private Office office;	
	private Date startDate;	//开始时间	
	private Date endDate;  //结束时间
	
	//返回字段
	private String userId;
	private String userName;
	private Long totalClueNum;  //线索总数
	private Long toCustomerNum;  //转化为客户的线索数
	private Long toChanceNum;  //转化为商机的线索数
	private Long toOrderNum;  //转化为订单的线索数
	
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Office getOffice() {
		return office;
	}
	public void setOffice(Office office) {
		this.office = office;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public Long getToCustomerNum() {
		return toCustomerNum;
	}
	public void setToCustomerNum(Long toCustomerNum) {
		this.toCustomerNum = toCustomerNum;
	}
	public Long getToChanceNum() {
		return toChanceNum;
	}
	public void setToChanceNum(Long toChanceNum) {
		this.toChanceNum = toChanceNum;
	}
	public Long getToOrderNum() {
		return toOrderNum;
	}
	public void setToOrderNum(Long toOrderNum) {
		this.toOrderNum = toOrderNum;
	}
	public Long getTotalClueNum() {
		return totalClueNum;
	}
	public void setTotalClueNum(Long totalClueNum) {
		this.totalClueNum = totalClueNum;
	}
	
	
}
