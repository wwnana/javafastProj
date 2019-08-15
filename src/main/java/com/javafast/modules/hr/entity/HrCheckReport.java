package com.javafast.modules.hr.entity;

import java.util.Date;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 月度打卡汇总Entity
 * @author javafast
 * @version 2018-07-09
 */
public class HrCheckReport extends DataEntity<HrCheckReport> {
	
	private static final long serialVersionUID = 1L;
	private String groupname;		// 规则名称
	private String userid;		// 微信用户id，放弃这个字段了
	private Integer attendanceDay;		// 应打卡天数
	private Integer normalDay;		// 正常天数
	private Integer abnormalDay;		// 异常天数
	private Integer attendanceCard;		// 补卡
	private Integer annualLeave;		// 年假
	private Integer unpaidLeave;		// 事假
	private Integer sickLeave;		// 病假
	private Integer overtimeLeave; //调休假
	private Integer maritalLeave;//婚嫁
	private Integer maternityLeave;//产假
	private Integer paternityLeave;//陪产假
	private Integer otherLeave;//其他假期

	private Date checkMonth;		// 统计月份
	
	//查询条件 ;
	private String checkinStatus;		// 状态 0正常，1异常 (整月有没有异常的状态)
	private Date beginCheckinDate;		// 开始 打卡日期 精确到月
	private Date endCheckinDate;		// 结束 打卡日期 精确到月
	private User user;                  //本地用户
	private Office office;		        //本地用户部门
	
	public HrCheckReport() {
		super();
	}

	public HrCheckReport(String id){
		super(id);
	}

	@Length(min=1, max=50, message="规则名称长度必须介于 1 和 50 之间")
	@ExcelField(title="规则名称", align=2, sort=1)
	public String getGroupname() {
		return groupname;
	}

	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}
	
	@Length(min=1, max=50, message="用户id长度必须介于 1 和 50 之间")
	@ExcelField(title="用户id", align=2, sort=2)
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	@ExcelField(title="部门id", fieldType=Office.class, value="office.name", align=2, sort=3)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@ExcelField(title="应打卡天数", align=2, sort=4)
	public Integer getAttendanceDay() {
		return attendanceDay;
	}

	public void setAttendanceDay(Integer attendanceDay) {
		this.attendanceDay = attendanceDay;
	}
	
	@ExcelField(title="正常天数", align=2, sort=5)
	public Integer getNormalDay() {
		return normalDay;
	}

	public void setNormalDay(Integer normalDay) {
		this.normalDay = normalDay;
	}
	
	@ExcelField(title="异常天数", align=2, sort=6)
	public Integer getAbnormalDay() {
		return abnormalDay;
	}

	public void setAbnormalDay(Integer abnormalDay) {
		this.abnormalDay = abnormalDay;
	}
	
	@ExcelField(title="补卡", align=2, sort=7)
	public Integer getAttendanceCard() {
		return attendanceCard;
	}

	public void setAttendanceCard(Integer attendanceCard) {
		this.attendanceCard = attendanceCard;
	}
	
	@ExcelField(title="年假", align=2, sort=8)
	public Integer getAnnualLeave() {
		return annualLeave;
	}

	public void setAnnualLeave(Integer annualLeave) {
		this.annualLeave = annualLeave;
	}
	
	@ExcelField(title="事假", align=2, sort=9)
	public Integer getUnpaidLeave() {
		return unpaidLeave;
	}

	public void setUnpaidLeave(Integer unpaidLeave) {
		this.unpaidLeave = unpaidLeave;
	}
	
	@ExcelField(title="病假", align=2, sort=10)
	public Integer getSickLeave() {
		return sickLeave;
	}

	public void setSickLeave(Integer sickLeave) {
		this.sickLeave = sickLeave;
	}
	
	@ExcelField(title="统计月份", align=2, sort=11)
	public Date getCheckMonth() {
		return checkMonth;
	}

	public void setCheckMonth(Date checkMonth) {
		this.checkMonth = checkMonth;
	}

	public String getCheckinStatus() {
		return checkinStatus;
	}

	public void setCheckinStatus(String checkinStatus) {
		this.checkinStatus = checkinStatus;
	}
	public Date getBeginCheckinDate() {
		return beginCheckinDate;
	}

	public void setBeginCheckinDate(Date beginCheckinDate) {
		this.beginCheckinDate = beginCheckinDate;
	}

	public Date getEndCheckinDate() {
		return endCheckinDate;
	}

	public void setEndCheckinDate(Date endCheckinDate) {
		this.endCheckinDate = endCheckinDate;
	}

	@ExcelField(title="姓名", fieldType=User.class, value="user.name", align=2, sort=0)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Integer getOvertimeLeave() {
		return overtimeLeave;
	}

	public void setOvertimeLeave(Integer overtimeLeave) {
		this.overtimeLeave = overtimeLeave;
	}

	public Integer getMaritalLeave() {
		return maritalLeave;
	}

	public void setMaritalLeave(Integer maritalLeave) {
		this.maritalLeave = maritalLeave;
	}

	public Integer getMaternityLeave() {
		return maternityLeave;
	}

	public void setMaternityLeave(Integer maternityLeave) {
		this.maternityLeave = maternityLeave;
	}

	public Integer getPaternityLeave() {
		return paternityLeave;
	}

	public void setPaternityLeave(Integer paternityLeave) {
		this.paternityLeave = paternityLeave;
	}

	public Integer getOtherLeave() {
		return otherLeave;
	}

	public void setOtherLeave(Integer otherLeave) {
		this.otherLeave = otherLeave;
	}
}