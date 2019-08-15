package com.javafast.modules.hr.entity;

import com.javafast.modules.hr.entity.HrEmployee;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 调薪Entity
 * @author javafast
 * @version 2018-07-05
 */
public class HrSalaryChange extends DataEntity<HrSalaryChange> {
	
	private static final long serialVersionUID = 1L;
	private HrEmployee hrEmployee;		// 员工
	private BigDecimal oldBaseSalary;		// 调薪前基本工资
	private BigDecimal baseSalary;		// 调薪后基本工资
	private BigDecimal changeRange;		// 调整幅度
	private Date effectDate;		// 调薪生效时间
	private String changeCause;		// 调薪原因
	private String status;		// 状态
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核日期
	private Date beginEffectDate;		// 开始 调薪生效时间
	private Date endEffectDate;		// 结束 调薪生效时间
	
	public HrSalaryChange() {
		super();
	}

	public HrSalaryChange(String id){
		super(id);
	}

	@ExcelField(title="员工姓名", fieldType=HrEmployee.class, value="hrEmployee.name", align=2, sort=0)
	public HrEmployee getHrEmployee() {
		return hrEmployee;
	}

	public void setHrEmployee(HrEmployee hrEmployee) {
		this.hrEmployee = hrEmployee;
	}
	
	@NotNull(message="调薪前基本工资不能为空")
	@ExcelField(title="调薪前基本工资", align=2, sort=2)
	public BigDecimal getOldBaseSalary() {
		return oldBaseSalary;
	}

	public void setOldBaseSalary(BigDecimal oldBaseSalary) {
		this.oldBaseSalary = oldBaseSalary;
	}
	
	@NotNull(message="调薪后基本工资不能为空")
	@ExcelField(title="调薪后基本工资", align=2, sort=3)
	public BigDecimal getBaseSalary() {
		return baseSalary;
	}

	public void setBaseSalary(BigDecimal baseSalary) {
		this.baseSalary = baseSalary;
	}
	
	@ExcelField(title="调整幅度", align=2, sort=4)
	public BigDecimal getChangeRange() {
		return changeRange;
	}

	public void setChangeRange(BigDecimal changeRange) {
		this.changeRange = changeRange;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="调薪生效时间不能为空")
	@ExcelField(title="调薪生效时间", align=2, sort=5)
	public Date getEffectDate() {
		return effectDate;
	}

	public void setEffectDate(Date effectDate) {
		this.effectDate = effectDate;
	}
	
	@Length(min=0, max=200, message="调薪原因长度必须介于 0 和 200 之间")
	@ExcelField(title="调薪原因", align=2, sort=6)
	public String getChangeCause() {
		return changeCause;
	}

	public void setChangeCause(String changeCause) {
		this.changeCause = changeCause;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=7)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="审核人", align=2, sort=8)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核日期", align=2, sort=9)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}
	
	public Date getBeginEffectDate() {
		return beginEffectDate;
	}

	public void setBeginEffectDate(Date beginEffectDate) {
		this.beginEffectDate = beginEffectDate;
	}
	
	public Date getEndEffectDate() {
		return endEffectDate;
	}

	public void setEndEffectDate(Date endEffectDate) {
		this.endEffectDate = endEffectDate;
	}
		
}