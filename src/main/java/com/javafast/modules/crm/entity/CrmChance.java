package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 商机Entity
 */
public class CrmChance extends DataEntity<CrmChance> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 商机名称
	private CrmCustomer customer;		// 客户
	private String saleAmount;		// 销售金额
	private String periodType;		// 销售阶段 1初步恰接，2需求确定，3方案报价，4签订合同,5赢单,6输单
	private Integer probability;		// 赢单率
	private String changeType;		// 商机类型
	private String sourType;		// 商机来源
	private Date nextcontactDate;		// 下次联系时间
	private String nextcontactNote;		// 联系内容
	private User ownBy;		// 负责人
	private String loseReasons;         //输单原因

	private Date beginNextcontactDate;		// 开始 下次联系时间
	private Date endNextcontactDate;		// 结束 下次联系时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public CrmChance() {
		super();
	}

	public CrmChance(String id){
		super(id);
	}

	@Length(min=0, max=50, message="商机名称长度必须介于 0 和 50 之间")
	@ExcelField(title="商机名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=2, type=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=12, message="销售金额长度必须介于 0 和 12 之间")
	@ExcelField(title="销售金额", align=2, sort=3)
	public String getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(String saleAmount) {
		this.saleAmount = saleAmount;
	}
	
	@Length(min=0, max=2, message="销售阶段长度必须介于 0 和 2 之间")
	@ExcelField(title="销售阶段", dictType="period_type", align=2, sort=4, type=1)
	public String getPeriodType() {
		return periodType;
	}

	public void setPeriodType(String periodType) {
		this.periodType = periodType;
	}
	
	@ExcelField(title="赢单率", dictType="probability_type", align=2, sort=5, type=1)
	public Integer getProbability() {
		return probability;
	}

	public void setProbability(Integer probability) {
		this.probability = probability;
	}
	
	@Length(min=0, max=2, message="商机类型长度必须介于 0 和 2 之间")
	@ExcelField(title="商机类型", dictType="change_type", align=2, sort=6, type=1)
	public String getChangeType() {
		return changeType;
	}

	public void setChangeType(String changeType) {
		this.changeType = changeType;
	}
	
	@Length(min=0, max=2, message="商机来源长度必须介于 0 和 2 之间")
	@ExcelField(title="商机来源", dictType="sour_type", align=2, sort=7, type=1)
	public String getSourType() {
		return sourType;
	}

	public void setSourType(String sourType) {
		this.sourType = sourType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="下次联系时间", align=2, sort=8, type=1)
	public Date getNextcontactDate() {
		return nextcontactDate;
	}

	public void setNextcontactDate(Date nextcontactDate) {
		this.nextcontactDate = nextcontactDate;
	}
	
	@Length(min=0, max=50, message="联系内容长度必须介于 0 和 50 之间")
	@ExcelField(title="联系内容", align=2, sort=9, type=1)
	public String getNextcontactNote() {
		return nextcontactNote;
	}

	public void setNextcontactNote(String nextcontactNote) {
		this.nextcontactNote = nextcontactNote;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=10, type=1)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=50, message="输单原因长度必须介于 0 和 50 之间")
	@ExcelField(title="输单原因", align=2, sort=20, type=1)
	public String getLoseReasons() {
		return loseReasons;
	}

	public void setLoseReasons(String loseReasons) {
		this.loseReasons = loseReasons;
	}
	
	public Date getBeginNextcontactDate() {
		return beginNextcontactDate;
	}

	public void setBeginNextcontactDate(Date beginNextcontactDate) {
		this.beginNextcontactDate = beginNextcontactDate;
	}
	
	public Date getEndNextcontactDate() {
		return endNextcontactDate;
	}

	public void setEndNextcontactDate(Date endNextcontactDate) {
		this.endNextcontactDate = endNextcontactDate;
	}
		
	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}
	
	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}

	
		
}