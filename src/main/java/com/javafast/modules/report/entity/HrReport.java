package com.javafast.modules.report.entity;

import java.util.Date;
import com.javafast.common.persistence.DataEntity;

public class HrReport extends DataEntity<HrReport> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5727153155365187258L;
	
	//查询条件
	private Date startDate;	//开始时间	
	private Date endDate;  //结束时间
		
	private Long jobNum;//在职数
	private Long quitNum;//离职数
	private Long entryNum;//入职数
	private Long regularNum;// 转正数
	private Long expireNum;//到期数
	private Long changeNum;//调岗数
	
	
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
	public Long getJobNum() {
		return jobNum;
	}
	public void setJobNum(Long jobNum) {
		this.jobNum = jobNum;
	}
	public Long getQuitNum() {
		return quitNum;
	}
	public void setQuitNum(Long quitNum) {
		this.quitNum = quitNum;
	}
	public Long getEntryNum() {
		return entryNum;
	}
	public void setEntryNum(Long entryNum) {
		this.entryNum = entryNum;
	}
	public Long getRegularNum() {
		return regularNum;
	}
	public void setRegularNum(Long regularNum) {
		this.regularNum = regularNum;
	}
	public Long getExpireNum() {
		return expireNum;
	}
	public void setExpireNum(Long expireNum) {
		this.expireNum = expireNum;
	}
	public Long getChangeNum() {
		return changeNum;
	}
	public void setChangeNum(Long changeNum) {
		this.changeNum = changeNum;
	}
	
	
}
