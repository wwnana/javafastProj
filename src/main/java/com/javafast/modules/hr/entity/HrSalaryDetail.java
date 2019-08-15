package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 工资表Entity
 * @author javafast
 * @version 2018-07-05
 */
public class HrSalaryDetail extends DataEntity<HrSalaryDetail> {
	
	private static final long serialVersionUID = 1L;
	private HrSalary hrSalary;		// 归属工资表 父类
	private HrEmployee hrEmployee;		// 员工
	private String name;		// 姓名
	private Integer mustWorkDays;		// 应出勤天数
	private Integer realWorkDays;		// 实际出勤天数
	private Integer extraWorkDays;		// 加班天数
	private Integer leaveDays;		// 请假天数
	private Integer absentDays;		// 旷工天数
	private BigDecimal baseSalary;		// 基本工资
	private BigDecimal postSalary;		// 岗位工资
	private BigDecimal bonusSalary;		// 奖金
	private BigDecimal overtimeSalary;		// 加班费
	private BigDecimal shouldAmt;		// 应发合计
	private BigDecimal socialAmt;		// 社保
	private BigDecimal fundAmt;		// 公积金
	private BigDecimal taxAmt;		// 个税
	private BigDecimal seductSalary;		// 应扣工资
	private BigDecimal realAmt;		// 实发工资
	private String status;		// 状态
	
	public HrSalaryDetail() {
		super();
	}

	public HrSalaryDetail(String id){
		super(id);
	}

	public HrSalaryDetail(HrSalary hrSalaryId){
		this.hrSalary = hrSalary;
	}

	@Length(min=0, max=64, message="归属工资表长度必须介于 0 和 64 之间")
	public HrSalary getHrSalaryId() {
		return hrSalary;
	}

	public void setHrSalaryId(HrSalary hrSalaryId) {
		this.hrSalary = hrSalary;
	}
	
	public HrEmployee getHrEmployee() {
		return hrEmployee;
	}

	public void setHrEmployee(HrEmployee hrEmployee) {
		this.hrEmployee = hrEmployee;
	}
	
	@Length(min=0, max=50, message="姓名长度必须介于 0 和 50 之间")
	@ExcelField(title="姓名", align=2, sort=4)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@ExcelField(title="应出勤天数", align=2, sort=5)
	public Integer getMustWorkDays() {
		return mustWorkDays;
	}

	public void setMustWorkDays(Integer mustWorkDays) {
		this.mustWorkDays = mustWorkDays;
	}
	
	@ExcelField(title="实际出勤天数", align=2, sort=6)
	public Integer getRealWorkDays() {
		return realWorkDays;
	}

	public void setRealWorkDays(Integer realWorkDays) {
		this.realWorkDays = realWorkDays;
	}
	
	@ExcelField(title="加班天数", align=2, sort=7)
	public Integer getExtraWorkDays() {
		return extraWorkDays;
	}

	public void setExtraWorkDays(Integer extraWorkDays) {
		this.extraWorkDays = extraWorkDays;
	}
	
	@ExcelField(title="请假天数", align=2, sort=8)
	public Integer getLeaveDays() {
		return leaveDays;
	}

	public void setLeaveDays(Integer leaveDays) {
		this.leaveDays = leaveDays;
	}
	
	@ExcelField(title="旷工天数", align=2, sort=9)
	public Integer getAbsentDays() {
		return absentDays;
	}

	public void setAbsentDays(Integer absentDays) {
		this.absentDays = absentDays;
	}
	
	@ExcelField(title="基本工资", align=2, sort=10)
	public BigDecimal getBaseSalary() {
		return baseSalary;
	}

	public void setBaseSalary(BigDecimal baseSalary) {
		this.baseSalary = baseSalary;
	}
	
	@ExcelField(title="岗位工资", align=2, sort=11)
	public BigDecimal getPostSalary() {
		return postSalary;
	}

	public void setPostSalary(BigDecimal postSalary) {
		this.postSalary = postSalary;
	}
	
	@ExcelField(title="奖金", align=2, sort=12)
	public BigDecimal getBonusSalary() {
		return bonusSalary;
	}

	public void setBonusSalary(BigDecimal bonusSalary) {
		this.bonusSalary = bonusSalary;
	}
	
	@ExcelField(title="加班费", align=2, sort=13)
	public BigDecimal getOvertimeSalary() {
		return overtimeSalary;
	}

	public void setOvertimeSalary(BigDecimal overtimeSalary) {
		this.overtimeSalary = overtimeSalary;
	}
	
	@ExcelField(title="应发合计", align=2, sort=14)
	public BigDecimal getShouldAmt() {
		return shouldAmt;
	}

	public void setShouldAmt(BigDecimal shouldAmt) {
		this.shouldAmt = shouldAmt;
	}
	
	@ExcelField(title="社保", align=2, sort=15)
	public BigDecimal getSocialAmt() {
		return socialAmt;
	}

	public void setSocialAmt(BigDecimal socialAmt) {
		this.socialAmt = socialAmt;
	}
	
	@ExcelField(title="公积金", align=2, sort=16)
	public BigDecimal getFundAmt() {
		return fundAmt;
	}

	public void setFundAmt(BigDecimal fundAmt) {
		this.fundAmt = fundAmt;
	}
	
	@ExcelField(title="个税", align=2, sort=17)
	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}
	
	@ExcelField(title="应扣工资", align=2, sort=18)
	public BigDecimal getSeductSalary() {
		return seductSalary;
	}

	public void setSeductSalary(BigDecimal seductSalary) {
		this.seductSalary = seductSalary;
	}
	
	@ExcelField(title="实发工资", align=2, sort=19)
	public BigDecimal getRealAmt() {
		return realAmt;
	}

	public void setRealAmt(BigDecimal realAmt) {
		this.realAmt = realAmt;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", align=2, sort=20)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}