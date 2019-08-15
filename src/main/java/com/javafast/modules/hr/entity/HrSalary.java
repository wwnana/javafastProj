package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 工资表Entity
 * @author javafast
 * @version 2018-07-05
 */
public class HrSalary extends DataEntity<HrSalary> {
	
	private static final long serialVersionUID = 1L;
	private String year;		// 年份
	private String month;		// 月份
	private Integer workDays;		// 应出勤天数
	private String status;		// 状态
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核日期
	private List<HrSalaryDetail> hrSalaryDetailList = Lists.newArrayList();		// 子表列表
	
	public HrSalary() {
		super();
	}

	public HrSalary(String id){
		super(id);
	}

	@Length(min=0, max=4, message="年份长度必须介于 0 和 4 之间")
	@ExcelField(title="年份", align=2, sort=1)
	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}
	
	@Length(min=0, max=2, message="月份长度必须介于 0 和 2 之间")
	@ExcelField(title="月份", align=2, sort=2)
	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}
	
	@ExcelField(title="应出勤天数", align=2, sort=3)
	public Integer getWorkDays() {
		return workDays;
	}

	public void setWorkDays(Integer workDays) {
		this.workDays = workDays;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=4)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="审核人", align=2, sort=5)
	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审核日期", align=2, sort=6)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}
	
	
	public List<HrSalaryDetail> getHrSalaryDetailList() {
		return hrSalaryDetailList;
	}

	public void setHrSalaryDetailList(List<HrSalaryDetail> hrSalaryDetailList) {
		this.hrSalaryDetailList = hrSalaryDetailList;
	}
}