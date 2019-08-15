package com.javafast.modules.report.entity;

import org.hibernate.validator.constraints.Length;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户统计Entity
 * @author shi
 * @version 2016-06-28
 */
public class CrmReport extends DataEntity<CrmReport> {
	
	private static final long serialVersionUID = 1L;
	//查询条件
	private User user;
	private Office office;	
	private Date startDate;	//开始时间	
	private Date endDate;  //结束时间
	
	//返回字段
	private String userId;
	private String userName;
	private String userPhoto;
	private Long createNum;//创建客户数
	private Long ownNum;//负责客户数
	private Long createChangeNum;//创建商机数
	private Long ownChangeNum;//负责商机数
	private Long createOrderNum;//负责订单数
	
	//业绩相关
	private BigDecimal createOrderAmt;//签单总额
	private BigDecimal recOrderAmt;//回款总额
	
	//财务相关
	private BigDecimal receiveAmt;//应收总额
	private BigDecimal rePayAmt;//应付总额	
	private BigDecimal alReceiveAmt;//实收总额
	private BigDecimal alPayAmt;//实付总额
	
	//产品相关
	private String proName;//产品名
	private Long productSaleNum;//产品销售总数
	private BigDecimal productSaleAmt;//产品销售总额
	
	
	//提醒相关
	
	private Long purposeCustomerNum;  //初步恰接  客户数
	private Long demandCustomerNum;  //需求确定  客户数
	private Long quoteCustomerNum;  //方案报价  客户数
	private Long dealOrderNum;  //签订合同，成交待收  合同数
	private Long completeOrderNum;  //销售回款完成  合同数
	
	private Long dayContactCustomerNum;   //今日需联系客户数
	private Long dayCreateCustomerNum;   //今日创建客户数
	
	private Long unAuditNum;   //待我审批流程
	private Long myApplyAuditNum;   //我申请的流程
	
	private Long myTaskNum;    //我负责的任务
	private Long myTaskWeekExpireNum;    //本周到期的
	private Long myProjectNum;    //我负责的项目
	
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
	
	@ExcelField(title="员工", align=2, sort=1)
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	@ExcelField(title="创建客户数", align=2, sort=10)
	public Long getCreateNum() {
		return createNum;
	}
	public void setCreateNum(Long createNum) {
		this.createNum = createNum;
	}
	
	@ExcelField(title="负责客户数", align=2, sort=10)
	public Long getOwnNum() {
		return ownNum;
	}
	public void setOwnNum(Long ownNum) {
		this.ownNum = ownNum;
	}
	
	@ExcelField(title="创建商机数", align=2, sort=10)
	public Long getCreateChangeNum() {
		return createChangeNum;
	}
	public void setCreateChangeNum(Long createChangeNum) {
		this.createChangeNum = createChangeNum;
	}
	
	@ExcelField(title="负责商机数", align=2, sort=10)
	public Long getOwnChangeNum() {
		return ownChangeNum;
	}
	public void setOwnChangeNum(Long ownChangeNum) {
		this.ownChangeNum = ownChangeNum;
	}
	
	@ExcelField(title="签单数", align=2, sort=10)
	public Long getCreateOrderNum() {
		return createOrderNum;
	}
	public void setCreateOrderNum(Long createOrderNum) {
		this.createOrderNum = createOrderNum;
	}
	
	@ExcelField(title="签单总额", align=2, sort=10)
	public BigDecimal getCreateOrderAmt() {
		return createOrderAmt;
	}
	public void setCreateOrderAmt(BigDecimal createOrderAmt) {
		this.createOrderAmt = createOrderAmt;
	}
	
	@ExcelField(title="回款总额", align=2, sort=10)
	public BigDecimal getRecOrderAmt() {
		return recOrderAmt;
	}
	public void setRecOrderAmt(BigDecimal recOrderAmt) {
		this.recOrderAmt = recOrderAmt;
	}
	
	public BigDecimal getReceiveAmt() {
		return receiveAmt;
	}
	public void setReceiveAmt(BigDecimal receiveAmt) {
		this.receiveAmt = receiveAmt;
	}
	public BigDecimal getRePayAmt() {
		return rePayAmt;
	}
	public void setRePayAmt(BigDecimal rePayAmt) {
		this.rePayAmt = rePayAmt;
	}
	public BigDecimal getAlReceiveAmt() {
		return alReceiveAmt;
	}
	public void setAlReceiveAmt(BigDecimal alReceiveAmt) {
		this.alReceiveAmt = alReceiveAmt;
	}
	public BigDecimal getAlPayAmt() {
		return alPayAmt;
	}
	public void setAlPayAmt(BigDecimal alPayAmt) {
		this.alPayAmt = alPayAmt;
	}
	public Long getProductSaleNum() {
		return productSaleNum;
	}
	public void setProductSaleNum(Long productSaleNum) {
		this.productSaleNum = productSaleNum;
	}
	public BigDecimal getProductSaleAmt() {
		return productSaleAmt;
	}
	public void setProductSaleAmt(BigDecimal productSaleAmt) {
		this.productSaleAmt = productSaleAmt;
	}
	public String getProName() {
		return proName;
	}
	public void setProName(String proName) {
		this.proName = proName;
	}
	public Long getPurposeCustomerNum() {
		return purposeCustomerNum;
	}
	public void setPurposeCustomerNum(Long purposeCustomerNum) {
		this.purposeCustomerNum = purposeCustomerNum;
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
	
	public Long getDayContactCustomerNum() {
		return dayContactCustomerNum;
	}
	public void setDayContactCustomerNum(Long dayContactCustomerNum) {
		this.dayContactCustomerNum = dayContactCustomerNum;
	}
	public Long getDayCreateCustomerNum() {
		return dayCreateCustomerNum;
	}
	public void setDayCreateCustomerNum(Long dayCreateCustomerNum) {
		this.dayCreateCustomerNum = dayCreateCustomerNum;
	}
	public Long getUnAuditNum() {
		return unAuditNum;
	}
	public void setUnAuditNum(Long unAuditNum) {
		this.unAuditNum = unAuditNum;
	}
	public Long getMyApplyAuditNum() {
		return myApplyAuditNum;
	}
	public void setMyApplyAuditNum(Long myApplyAuditNum) {
		this.myApplyAuditNum = myApplyAuditNum;
	}
	public Long getMyTaskNum() {
		return myTaskNum;
	}
	public void setMyTaskNum(Long myTaskNum) {
		this.myTaskNum = myTaskNum;
	}
	public Long getMyProjectNum() {
		return myProjectNum;
	}
	public void setMyProjectNum(Long myProjectNum) {
		this.myProjectNum = myProjectNum;
	}
	public Long getMyTaskWeekExpireNum() {
		return myTaskWeekExpireNum;
	}
	public void setMyTaskWeekExpireNum(Long myTaskWeekExpireNum) {
		this.myTaskWeekExpireNum = myTaskWeekExpireNum;
	}
	public Long getQuoteCustomerNum() {
		return quoteCustomerNum;
	}
	public void setQuoteCustomerNum(Long quoteCustomerNum) {
		this.quoteCustomerNum = quoteCustomerNum;
	}
	public Long getDemandCustomerNum() {
		return demandCustomerNum;
	}
	public void setDemandCustomerNum(Long demandCustomerNum) {
		this.demandCustomerNum = demandCustomerNum;
	}
	public String getUserPhoto() {
		return userPhoto;
	}
	public void setUserPhoto(String userPhoto) {
		this.userPhoto = userPhoto;
	}
	
}