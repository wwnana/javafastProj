package com.javafast.modules.hr.entity;

import com.javafast.modules.hr.entity.HrResume;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * OFFEREntity
 * @author javafast
 * @version 2018-06-30
 */
public class HrOffer extends DataEntity<HrOffer> {
	
	private static final long serialVersionUID = 1L;
	private HrResume hrResume;		// 简历
	private String readEmail;		// 抄送邮箱
	private Integer validityPeriod;		// 有效期
	private Date reportDate;		// 报到时间
	private Integer probationPeriod;		// 试用期
	private String position;		// 入职岗位
	private String department;		// 入职部门
	private String address;		// 公司地址
	private String company;		// 公司名称
	private String linkMan;		// 入职联系人
	private String linkPhone;		// 联系人电话
	private BigDecimal formalSalaryBase;		// 转正工资(元)
	private BigDecimal probationSalaryBase;		// 试用期工资(元)
	private String salaryRemarks;		// 薪酬备注
	private String offerFile;		// 附件
	private String status;		// 状态(0：未发送， 1：已发送，2：已接受, 3：已拒绝)
	private String reportStatus; //报到状态 0未报到，1：已报到
	
	//查询条件
	private Date beginReportDate;		// 开始 报到时间
	private Date endReportDate;		// 结束 报到时间
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private boolean isUnComplete;    //待办的
	
	private String content;    //邮件内容
	private String isSmsMsg;   //发送短信消息
	private String isEmailMsg;  //发送邮件消息
	
	public HrOffer() {
		super();
	}

	public HrOffer(String id){
		super(id);
	}
	
	public HrOffer(String id, HrResume hrResume){
		super(id);
		this.hrResume = hrResume;
	}

	@ExcelField(title="姓名", fieldType=HrResume.class, value="hrResume.name", align=2, sort=0)
	public HrResume getHrResume() {
		return hrResume;
	}

	public void setHrResume(HrResume hrResume) {
		this.hrResume = hrResume;
	}
	
	@Length(min=0, max=50, message="抄送邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="抄送邮箱", align=2, sort=2)
	public String getReadEmail() {
		return readEmail;
	}

	public void setReadEmail(String readEmail) {
		this.readEmail = readEmail;
	}
	
	@ExcelField(title="有效期", align=2, sort=3)
	public Integer getValidityPeriod() {
		return validityPeriod;
	}

	public void setValidityPeriod(Integer validityPeriod) {
		this.validityPeriod = validityPeriod;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="报到时间", align=2, sort=4)
	public Date getReportDate() {
		return reportDate;
	}

	public void setReportDate(Date reportDate) {
		this.reportDate = reportDate;
	}
	
	@ExcelField(title="试用期", align=2, sort=5)
	public Integer getProbationPeriod() {
		return probationPeriod;
	}

	public void setProbationPeriod(Integer probationPeriod) {
		this.probationPeriod = probationPeriod;
	}
	
	@Length(min=0, max=50, message="入职岗位长度必须介于 0 和 50 之间")
	@ExcelField(title="入职岗位", align=2, sort=6)
	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	@Length(min=0, max=50, message="入职部门长度必须介于 0 和 50 之间")
	@ExcelField(title="入职部门", align=2, sort=7)
	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}
	
	@Length(min=0, max=50, message="公司地址长度必须介于 0 和 50 之间")
	@ExcelField(title="公司地址", align=2, sort=8)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=50, message="入职联系人长度必须介于 0 和 50 之间")
	@ExcelField(title="入职联系人", align=2, sort=9)
	public String getLinkMan() {
		return linkMan;
	}

	public void setLinkMan(String linkMan) {
		this.linkMan = linkMan;
	}
	
	@Length(min=0, max=50, message="联系人电话长度必须介于 0 和 50 之间")
	@ExcelField(title="联系人电话", align=2, sort=10)
	public String getLinkPhone() {
		return linkPhone;
	}

	public void setLinkPhone(String linkPhone) {
		this.linkPhone = linkPhone;
	}
	
	@ExcelField(title="转正工资(元)", align=2, sort=11)
	public BigDecimal getFormalSalaryBase() {
		return formalSalaryBase;
	}

	public void setFormalSalaryBase(BigDecimal formalSalaryBase) {
		this.formalSalaryBase = formalSalaryBase;
	}
	
	@ExcelField(title="试用期工资(元)", align=2, sort=12)
	public BigDecimal getProbationSalaryBase() {
		return probationSalaryBase;
	}

	public void setProbationSalaryBase(BigDecimal probationSalaryBase) {
		this.probationSalaryBase = probationSalaryBase;
	}
	
	@Length(min=0, max=200, message="薪酬备注长度必须介于 0 和 200 之间")
	@ExcelField(title="薪酬备注", align=2, sort=13)
	public String getSalaryRemarks() {
		return salaryRemarks;
	}

	public void setSalaryRemarks(String salaryRemarks) {
		this.salaryRemarks = salaryRemarks;
	}
	
	@Length(min=0, max=255, message="附件长度必须介于 0 和 255 之间")
	@ExcelField(title="附件", align=2, sort=14)
	public String getOfferFile() {
		return offerFile;
	}

	public void setOfferFile(String offerFile) {
		this.offerFile = offerFile;
	}
	
	@Length(min=0, max=1, message="状态( 1：已发送，2：已确认)长度必须介于 0 和 1 之间")
	@ExcelField(title="状态( 1：已发送，2：已确认)", dictType="offer_status", align=2, sort=15)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getBeginReportDate() {
		return beginReportDate;
	}

	public void setBeginReportDate(Date beginReportDate) {
		this.beginReportDate = beginReportDate;
	}
	
	public Date getEndReportDate() {
		return endReportDate;
	}

	public void setEndReportDate(Date endReportDate) {
		this.endReportDate = endReportDate;
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

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getIsSmsMsg() {
		return isSmsMsg;
	}

	public void setIsSmsMsg(String isSmsMsg) {
		this.isSmsMsg = isSmsMsg;
	}

	public String getIsEmailMsg() {
		return isEmailMsg;
	}

	public void setIsEmailMsg(String isEmailMsg) {
		this.isEmailMsg = isEmailMsg;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public boolean isUnComplete() {
		return isUnComplete;
	}

	public void setUnComplete(boolean isUnComplete) {
		this.isUnComplete = isUnComplete;
	}

	public String getReportStatus() {
		return reportStatus;
	}

	public void setReportStatus(String reportStatus) {
		this.reportStatus = reportStatus;
	}

	
		
}