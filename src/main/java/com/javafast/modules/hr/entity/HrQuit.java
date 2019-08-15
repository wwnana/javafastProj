package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 离职Entity
 * @author javafast
 * @version 2018-07-06
 */
public class HrQuit extends DataEntity<HrQuit> {
	
	private static final long serialVersionUID = 1L;
	private String quitType;		// 离职类型
	private Date quitDate;		// 离职时间
	private String quitCause;		// 离职原因
	private String applyQuitCause;		// 申请离职原因
	private BigDecimal compensation;		// 补偿金
	private String socialOverMonth;		// 社保减员月
	private String fundOverMonth;		// 公积金减员月
	private Integer annualLeave;		// 剩余年假
	private Integer restLeave;		// 剩余调休
	private String workContent;		// 工作交接内容
	private User workBy;		// 工作交接给
	private String workStatus;		// 工作交接完成情况
	private String status;		// 状态
	private HrEmployee hrEmployee;		// 员工ID
	
	private Date beginQuitDate;		// 开始 离职时间
	private Date endQuitDate;		// 结束 离职时间
	
	public HrQuit() {
		super();
	}

	public HrQuit(String id){
		super(id);
	}

	@Length(min=0, max=1, message="离职类型长度必须介于 0 和 1 之间")
	@ExcelField(title="离职类型", dictType="quit_type", align=2, sort=1)
	public String getQuitType() {
		return quitType;
	}

	public void setQuitType(String quitType) {
		this.quitType = quitType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="离职时间", align=2, sort=2)
	public Date getQuitDate() {
		return quitDate;
	}

	public void setQuitDate(Date quitDate) {
		this.quitDate = quitDate;
	}
	
	@Length(min=0, max=200, message="离职原因长度必须介于 0 和 200 之间")
	@ExcelField(title="离职原因", align=2, sort=3)
	public String getQuitCause() {
		return quitCause;
	}

	public void setQuitCause(String quitCause) {
		this.quitCause = quitCause;
	}
	
	@Length(min=0, max=200, message="申请离职原因长度必须介于 0 和 200 之间")
	@ExcelField(title="申请离职原因", align=2, sort=4)
	public String getApplyQuitCause() {
		return applyQuitCause;
	}

	public void setApplyQuitCause(String applyQuitCause) {
		this.applyQuitCause = applyQuitCause;
	}
	
	@ExcelField(title="补偿金", align=2, sort=5)
	public BigDecimal getCompensation() {
		return compensation;
	}

	public void setCompensation(BigDecimal compensation) {
		this.compensation = compensation;
	}
	
	@Length(min=0, max=1, message="社保减员月长度必须介于 0 和 1 之间")
	@ExcelField(title="社保减员月", dictType="over_month_type", align=2, sort=6)
	public String getSocialOverMonth() {
		return socialOverMonth;
	}

	public void setSocialOverMonth(String socialOverMonth) {
		this.socialOverMonth = socialOverMonth;
	}
	
	@Length(min=0, max=1, message="公积金减员月长度必须介于 0 和 1 之间")
	@ExcelField(title="公积金减员月", dictType="over_month_type", align=2, sort=7)
	public String getFundOverMonth() {
		return fundOverMonth;
	}

	public void setFundOverMonth(String fundOverMonth) {
		this.fundOverMonth = fundOverMonth;
	}
	
	@ExcelField(title="剩余年假", align=2, sort=8)
	public Integer getAnnualLeave() {
		return annualLeave;
	}

	public void setAnnualLeave(Integer annualLeave) {
		this.annualLeave = annualLeave;
	}
	
	@ExcelField(title="剩余调休", align=2, sort=9)
	public Integer getRestLeave() {
		return restLeave;
	}

	public void setRestLeave(Integer restLeave) {
		this.restLeave = restLeave;
	}
	
	@Length(min=0, max=300, message="工作交接内容长度必须介于 0 和 300 之间")
	@ExcelField(title="工作交接内容", align=2, sort=10)
	public String getWorkContent() {
		return workContent;
	}

	public void setWorkContent(String workContent) {
		this.workContent = workContent;
	}
	
	@ExcelField(title="工作交接给", fieldType=User.class, value="workBy.name", align=2, sort=11)
	public User getWorkBy() {
		return workBy;
	}

	public void setWorkBy(User workBy) {
		this.workBy = workBy;
	}
	
	@Length(min=0, max=1, message="工作交接完成情况长度必须介于 0 和 1 之间")
	@ExcelField(title="工作交接完成情况", dictType="finish_status", align=2, sort=12)
	public String getWorkStatus() {
		return workStatus;
	}

	public void setWorkStatus(String workStatus) {
		this.workStatus = workStatus;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=13)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@NotNull(message="员工不能为空")
	@ExcelField(title="员工姓名", fieldType=HrEmployee.class, value="hrEmployee.name", align=2, sort=0)
	public HrEmployee getHrEmployee() {
		return hrEmployee;
	}

	public void setHrEmployee(HrEmployee hrEmployee) {
		this.hrEmployee = hrEmployee;
	}
	
	public Date getBeginQuitDate() {
		return beginQuitDate;
	}

	public void setBeginQuitDate(Date beginQuitDate) {
		this.beginQuitDate = beginQuitDate;
	}
	
	public Date getEndQuitDate() {
		return endQuitDate;
	}

	public void setEndQuitDate(Date endQuitDate) {
		this.endQuitDate = endQuitDate;
	}
		
}