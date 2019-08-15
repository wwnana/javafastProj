package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 市场活动Entity
 * @author javafast
 * @version 2019-03-26
 */
public class CrmMarket extends DataEntity<CrmMarket> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 活动名称
	private Date startDate;		// 开始日期
	private Date endDate;		// 截止日期
	private String marketType;		// 活动类型
	private String marketAddress;		// 活动地点
	private BigDecimal estimateCost;		// 预计成本
	private BigDecimal actualCost;		// 实际成本
	private BigDecimal estimateAmount;		// 预计收入
	private BigDecimal actualAmount;		// 实际收入
	private Integer inviteNum;		// 邀请人数
	private Integer actualNum;		// 实际人数
	private User ownBy;		// 所有者
	private String status;		// 活动状态
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	private CrmMarketData crmMarketData;//活动详情
	
	public CrmMarket() {
		super();
	}

	public CrmMarket(String id){
		super(id);
	}

	@Length(min=1, max=50, message="活动名称长度必须介于 1 和 50 之间")
	@ExcelField(title="活动名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@NotNull(message="开始日期不能为空")
	@ExcelField(title="开始日期", align=2, sort=2)
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@NotNull(message="截止日期不能为空")
	@ExcelField(title="截止日期", align=2, sort=3)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@Length(min=0, max=2, message="活动类型长度必须介于 0 和 2 之间")
	@ExcelField(title="活动类型", dictType="market_type", align=2, sort=4, type=1)
	public String getMarketType() {
		return marketType;
	}

	public void setMarketType(String marketType) {
		this.marketType = marketType;
	}
	
	@Length(min=0, max=50, message="活动地点长度必须介于 0 和 50 之间")
	@ExcelField(title="活动地点", align=2, sort=5)
	public String getMarketAddress() {
		return marketAddress;
	}

	public void setMarketAddress(String marketAddress) {
		this.marketAddress = marketAddress;
	}
	
	@ExcelField(title="预计成本", align=2, sort=6)
	public BigDecimal getEstimateCost() {
		return estimateCost;
	}

	public void setEstimateCost(BigDecimal estimateCost) {
		this.estimateCost = estimateCost;
	}
	
	@ExcelField(title="实际成本", align=2, sort=7)
	public BigDecimal getActualCost() {
		return actualCost;
	}

	public void setActualCost(BigDecimal actualCost) {
		this.actualCost = actualCost;
	}
	
	@ExcelField(title="预计收入", align=2, sort=8)
	public BigDecimal getEstimateAmount() {
		return estimateAmount;
	}

	public void setEstimateAmount(BigDecimal estimateAmount) {
		this.estimateAmount = estimateAmount;
	}
	
	@ExcelField(title="实际收入", align=2, sort=9)
	public BigDecimal getActualAmount() {
		return actualAmount;
	}

	public void setActualAmount(BigDecimal actualAmount) {
		this.actualAmount = actualAmount;
	}
	
	@ExcelField(title="邀请人数", align=2, sort=10)
	public Integer getInviteNum() {
		return inviteNum;
	}

	public void setInviteNum(Integer inviteNum) {
		this.inviteNum = inviteNum;
	}
	
	@ExcelField(title="实际人数", align=2, sort=11)
	public Integer getActualNum() {
		return actualNum;
	}

	public void setActualNum(Integer actualNum) {
		this.actualNum = actualNum;
	}
	
	@ExcelField(title="所有者", fieldType=User.class, value="ownBy.name", align=2, sort=12, type=1)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="活动状态长度必须介于 0 和 1 之间")
	@ExcelField(title="活动状态", dictType="market_status", align=2, sort=13, type=1)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public CrmMarketData getCrmMarketData() {
		return crmMarketData;
	}

	public void setCrmMarketData(CrmMarketData crmMarketData) {
		this.crmMarketData = crmMarketData;
	}
		
}