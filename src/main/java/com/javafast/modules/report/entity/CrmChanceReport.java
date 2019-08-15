package com.javafast.modules.report.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

/**
 * 销售阶段分析类
 * @author
 *
 */
public class CrmChanceReport extends DataEntity<CrmReport> {
	
	private Long totalChanceNum;   //总商机数
	private Long purposeCustomerNum;  //初步恰接  客户数
	private Long demandCustomerNum;  //需求确定  客户数
	private Long quoteCustomerNum;  //方案报价  客户数
	private Long dealOrderNum;  //签订合同，成交待收  合同数
	private Long completeOrderNum;  //销售回款完成  合同数
	
	private BigDecimal totalChanceAmt;   //商机总额
	private BigDecimal purposeCustomerAmt;  //初步恰接  总额
	private BigDecimal demandCustomerAmt;  //需求确定  总额
	private BigDecimal quoteCustomerAmt;  //方案报价  总额
	private BigDecimal dealOrderAmt;  //签订合同，成交待收  总额
	private BigDecimal completeOrderAmt;  //销售回款完成  总额
	
	//查询条件
	private User user;
	private Office office;
	private Date startDate;	//开始时间	
	private Date endDate;  //结束时间
	
	
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
	public Long getPurposeCustomerNum() {
		return purposeCustomerNum;
	}
	public void setPurposeCustomerNum(Long purposeCustomerNum) {
		this.purposeCustomerNum = purposeCustomerNum;
	}
	public Long getDemandCustomerNum() {
		return demandCustomerNum;
	}
	public void setDemandCustomerNum(Long demandCustomerNum) {
		this.demandCustomerNum = demandCustomerNum;
	}
	public Long getQuoteCustomerNum() {
		return quoteCustomerNum;
	}
	public void setQuoteCustomerNum(Long quoteCustomerNum) {
		this.quoteCustomerNum = quoteCustomerNum;
	}
	public Long getDealOrderNum() {
		return dealOrderNum;
	}
	public void setDealOrderNum(Long dealOrderNum) {
		this.dealOrderNum = dealOrderNum;
	}
	public Long getCompleteOrderNum() {
		return completeOrderNum;
	}
	public void setCompleteOrderNum(Long completeOrderNum) {
		this.completeOrderNum = completeOrderNum;
	}
	public Long getTotalChanceNum() {
		return totalChanceNum;
	}
	public void setTotalChanceNum(Long totalChanceNum) {
		this.totalChanceNum = totalChanceNum;
	}
	public BigDecimal getTotalChanceAmt() {
		return totalChanceAmt;
	}
	public void setTotalChanceAmt(BigDecimal totalChanceAmt) {
		this.totalChanceAmt = totalChanceAmt;
	}
	public BigDecimal getPurposeCustomerAmt() {
		return purposeCustomerAmt;
	}
	public void setPurposeCustomerAmt(BigDecimal purposeCustomerAmt) {
		this.purposeCustomerAmt = purposeCustomerAmt;
	}
	public BigDecimal getDemandCustomerAmt() {
		return demandCustomerAmt;
	}
	public void setDemandCustomerAmt(BigDecimal demandCustomerAmt) {
		this.demandCustomerAmt = demandCustomerAmt;
	}
	public BigDecimal getQuoteCustomerAmt() {
		return quoteCustomerAmt;
	}
	public void setQuoteCustomerAmt(BigDecimal quoteCustomerAmt) {
		this.quoteCustomerAmt = quoteCustomerAmt;
	}
	public BigDecimal getDealOrderAmt() {
		return dealOrderAmt;
	}
	public void setDealOrderAmt(BigDecimal dealOrderAmt) {
		this.dealOrderAmt = dealOrderAmt;
	}
	public BigDecimal getCompleteOrderAmt() {
		return completeOrderAmt;
	}
	public void setCompleteOrderAmt(BigDecimal completeOrderAmt) {
		this.completeOrderAmt = completeOrderAmt;
	}
	
	
	
}
