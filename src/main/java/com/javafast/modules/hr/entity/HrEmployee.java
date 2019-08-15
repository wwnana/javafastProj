package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

/**
 * 员工信息Entity
 * @author javafast
 * @version 2018-07-03
 */
public class HrEmployee extends DataEntity<HrEmployee> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 姓名
	private String sex;		// 性别
	private Date birthDate;		// 出生日期
	private String idCard;		// 身份证号
	private String idCardImg;		// 身份证照
	private String nativePlace;		// 籍贯
	private String nation;		// 民族
	private String enName;		// 英文名
	private String maritalStatus;		// 婚姻状况
	private String birthday;		// 生日
	private String registration;		// 户籍所在地
	private String political;		// 政治面貌
	private String children;		// 子女状态
	private String mobile;		// 联系手机
	private String email;		// 个人邮箱
	private String qq;		// QQ
	private String wx;		// 微信
	private String city;		// 居住城市
	private String address;		// 通讯地址
	private String contactPeople;		// 紧急联系人
	private String contactPhone;		// 紧急联系电话
	private String socialSecurityNo;		// 社保电脑号
	private String accumulationNo;		// 公积金账号
	private String bankCardNo;		// 银行卡号
	private String bankCardName;		// 开户行
	private String educationType;		// 最高学历
	private String graduateSchool;		// 毕业学校
	private String schoolStart;		// 入学时间
	private String schoolEnd;		// 毕业时间
	private String specialty;		// 专业
	private String certificateImg;		// 毕业证书
	private String lastCompany;		// 上家公司
	private String lastPosition;		// 上家公司职位
	private String leavingCertify;		// 前公司离职证明
	private Date entryDate;		// 入职日期
	private Date regularDate;		// 转正日期
	private String regularStatus;		// 转正状态 0未转正，1已转正
	private String regularEvaluation;    //转正评价
	private Integer probationPeriod;		// 试用期
	private String employType;		// 聘用形式
	private String position;		// 职位
	private String positionLevel;		// 职级
	private Date firstWorkDate;		// 首次参加工作时间
	private String workAddress;		// 工作地点
	private Date contractStartDate;		// 现合同开始时间
	private Date contractEndDate;		// 现合同结束时间
	private String contractFile;		// 合同文件
	private String recruitSource;		// 招聘渠道
	private String recommend;		// 推荐企业/人
	private BigDecimal formalSalaryBase;		// 转正工资基数(元)
	private BigDecimal probationSalaryBase;		// 试用期工资基数(元)
	private String salaryRemarks;		// 薪酬备注
//	private String quitType;         //离职类型
//	private Date quitDate;         //离职时间
//	private String quitCause;         //离职原因
	private String status;		// 员工状态 0在职，1离职
	
	private String isEdit;     //编辑权限，0：否，1是(允许员工自己编辑信息)
	private User user;		// 基础用户表	
	private HrResume hrResume;   //对应简历
	private Office office;	// 归属部门
	
	//查询条件
	private Date beginEntryDate;		// 开始 入职日期
	private Date endEntryDate;		// 结束 入职日期
	private Date beginContractEndDate;		// 开始 合同到期时间
	private Date endContractEndDate;		// 结束 合同到期时间
	
	private Date beginRegularDate;		// 开始 转正时间
	private Date endRegularDate;		// 结束 转正时间
	private Date beginQuitDate;		// 开始离职时间
	private Date endQuitDate;		// 结束 离职时间
	
	public HrEmployee() {
		super();
	}

	public HrEmployee(String id){
		super(id);
	}

	@Length(min=0, max=50, message="姓名长度必须介于 0 和 50 之间")
	@ExcelField(title="姓名", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=1, message="性别长度必须介于 0 和 1 之间")
	@ExcelField(title="性别", dictType="sex", align=2, sort=2)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="出生日期", align=2, sort=3)
	public Date getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}
	
	@Length(min=0, max=20, message="身份证号长度必须介于 0 和 20 之间")
	@ExcelField(title="身份证号", align=2, sort=4)
	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}
	
	@Length(min=0, max=255, message="身份证照长度必须介于 0 和 255 之间")
	public String getIdCardImg() {
		return idCardImg;
	}

	public void setIdCardImg(String idCardImg) {
		this.idCardImg = idCardImg;
	}
	
	@Length(min=0, max=30, message="籍贯长度必须介于 0 和 30 之间")
	@ExcelField(title="籍贯", align=2, sort=6)
	public String getNativePlace() {
		return nativePlace;
	}

	public void setNativePlace(String nativePlace) {
		this.nativePlace = nativePlace;
	}
	
	@Length(min=0, max=30, message="民族长度必须介于 0 和 30 之间")
	@ExcelField(title="民族", align=2, sort=7)
	public String getNation() {
		return nation;
	}

	public void setNation(String nation) {
		this.nation = nation;
	}
	
	@Length(min=0, max=50, message="英文名长度必须介于 0 和 50 之间")
	@ExcelField(title="英文名", align=2, sort=8)
	public String getEnName() {
		return enName;
	}

	public void setEnName(String enName) {
		this.enName = enName;
	}
	
	@Length(min=0, max=1, message="婚姻状况长度必须介于 0 和 1 之间")
	@ExcelField(title="婚姻状况", dictType="marital_status", align=2, sort=9)
	public String getMaritalStatus() {
		return maritalStatus;
	}

	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}
	
	@Length(min=0, max=10, message="生日长度必须介于 0 和 10 之间")
	@ExcelField(title="生日", align=2, sort=10)
	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	
	@Length(min=0, max=50, message="户籍所在地长度必须介于 0 和 50 之间")
	@ExcelField(title="户籍所在地", align=2, sort=11)
	public String getRegistration() {
		return registration;
	}

	public void setRegistration(String registration) {
		this.registration = registration;
	}
	
	@Length(min=0, max=20, message="政治面貌长度必须介于 0 和 20 之间")
	@ExcelField(title="政治面貌", align=2, sort=12)
	public String getPolitical() {
		return political;
	}

	public void setPolitical(String political) {
		this.political = political;
	}
	
	@Length(min=0, max=50, message="子女状态长度必须介于 0 和 50 之间")
	@ExcelField(title="子女状态", align=2, sort=13)
	public String getChildren() {
		return children;
	}

	public void setChildren(String children) {
		this.children = children;
	}
	
	@Length(min=0, max=20, message="联系手机长度必须介于 0 和 20 之间")
	@ExcelField(title="联系手机", align=2, sort=14)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=0, max=50, message="个人邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="个人邮箱", align=2, sort=15)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=50, message="QQ长度必须介于 0 和 50 之间")
	@ExcelField(title="QQ", align=2, sort=16)
	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}
	
	@Length(min=0, max=50, message="微信长度必须介于 0 和 50 之间")
	@ExcelField(title="微信", align=2, sort=17)
	public String getWx() {
		return wx;
	}

	public void setWx(String wx) {
		this.wx = wx;
	}
	
	@Length(min=0, max=50, message="居住城市长度必须介于 0 和 50 之间")
	@ExcelField(title="居住城市", align=2, sort=18)
	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}
	
	@Length(min=0, max=50, message="通讯地址长度必须介于 0 和 50 之间")
	@ExcelField(title="通讯地址", align=2, sort=19)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=50, message="紧急联系人长度必须介于 0 和 50 之间")
	@ExcelField(title="紧急联系人", align=2, sort=20)
	public String getContactPeople() {
		return contactPeople;
	}

	public void setContactPeople(String contactPeople) {
		this.contactPeople = contactPeople;
	}
	
	@Length(min=0, max=20, message="紧急联系电话长度必须介于 0 和 20 之间")
	@ExcelField(title="紧急联系电话", align=2, sort=21)
	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	
	@Length(min=0, max=50, message="社保电脑号长度必须介于 0 和 50 之间")
	@ExcelField(title="社保电脑号", align=2, sort=22)
	public String getSocialSecurityNo() {
		return socialSecurityNo;
	}

	public void setSocialSecurityNo(String socialSecurityNo) {
		this.socialSecurityNo = socialSecurityNo;
	}
	
	@Length(min=0, max=50, message="公积金账号长度必须介于 0 和 50 之间")
	@ExcelField(title="公积金账号", align=2, sort=23)
	public String getAccumulationNo() {
		return accumulationNo;
	}

	public void setAccumulationNo(String accumulationNo) {
		this.accumulationNo = accumulationNo;
	}
	
	@Length(min=0, max=30, message="银行卡号长度必须介于 0 和 30 之间")
	@ExcelField(title="银行卡号", align=2, sort=24)
	public String getBankCardNo() {
		return bankCardNo;
	}

	public void setBankCardNo(String bankCardNo) {
		this.bankCardNo = bankCardNo;
	}
	
	@Length(min=0, max=50, message="开户行长度必须介于 0 和 50 之间")
	@ExcelField(title="开户行", align=2, sort=25)
	public String getBankCardName() {
		return bankCardName;
	}

	public void setBankCardName(String bankCardName) {
		this.bankCardName = bankCardName;
	}
	
	@Length(min=0, max=1, message="最高学历长度必须介于 0 和 1 之间")
	@ExcelField(title="最高学历", dictType="education_type", align=2, sort=26)
	public String getEducationType() {
		return educationType;
	}

	public void setEducationType(String educationType) {
		this.educationType = educationType;
	}
	
	@Length(min=0, max=50, message="毕业学校长度必须介于 0 和 50 之间")
	@ExcelField(title="毕业学校", align=2, sort=27)
	public String getGraduateSchool() {
		return graduateSchool;
	}

	public void setGraduateSchool(String graduateSchool) {
		this.graduateSchool = graduateSchool;
	}
	
	@Length(min=0, max=20, message="入学时间长度必须介于 0 和 20 之间")
	@ExcelField(title="入学时间", align=2, sort=28)
	public String getSchoolStart() {
		return schoolStart;
	}

	public void setSchoolStart(String schoolStart) {
		this.schoolStart = schoolStart;
	}
	
	@Length(min=0, max=20, message="毕业时间长度必须介于 0 和 20 之间")
	@ExcelField(title="毕业时间", align=2, sort=29)
	public String getSchoolEnd() {
		return schoolEnd;
	}

	public void setSchoolEnd(String schoolEnd) {
		this.schoolEnd = schoolEnd;
	}
	
	@Length(min=0, max=50, message="专业长度必须介于 0 和 50 之间")
	@ExcelField(title="专业", align=2, sort=30)
	public String getSpecialty() {
		return specialty;
	}

	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}
	
	@Length(min=0, max=255, message="毕业证书长度必须介于 0 和 255 之间")
	public String getCertificateImg() {
		return certificateImg;
	}

	public void setCertificateImg(String certificateImg) {
		this.certificateImg = certificateImg;
	}
	
	@Length(min=0, max=50, message="上家公司长度必须介于 0 和 50 之间")
	@ExcelField(title="上家公司", align=2, sort=32)
	public String getLastCompany() {
		return lastCompany;
	}

	public void setLastCompany(String lastCompany) {
		this.lastCompany = lastCompany;
	}
	
	@Length(min=0, max=50, message="上家公司职位长度必须介于 0 和 50 之间")
	@ExcelField(title="上家公司职位", align=2, sort=33)
	public String getLastPosition() {
		return lastPosition;
	}

	public void setLastPosition(String lastPosition) {
		this.lastPosition = lastPosition;
	}
	
	@Length(min=0, max=255, message="前公司离职证明长度必须介于 0 和 255 之间")
	public String getLeavingCertify() {
		return leavingCertify;
	}

	public void setLeavingCertify(String leavingCertify) {
		this.leavingCertify = leavingCertify;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="入职日期", align=2, sort=35)
	public Date getEntryDate() {
		return entryDate;
	}

	public void setEntryDate(Date entryDate) {
		this.entryDate = entryDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="转正日期", align=2, sort=36)
	public Date getRegularDate() {
		return regularDate;
	}

	public void setRegularDate(Date regularDate) {
		this.regularDate = regularDate;
	}
	
	@Length(min=0, max=1, message="转正状态长度必须介于 0 和 1 之间")
	@ExcelField(title="转正状态", dictType="regular_status", align=2, sort=37)
	public String getRegularStatus() {
		return regularStatus;
	}

	public void setRegularStatus(String regularStatus) {
		this.regularStatus = regularStatus;
	}
	
	@Length(min=0, max=1, message="聘用形式长度必须介于 0 和 1 之间")
	@ExcelField(title="聘用形式", dictType="employ_type", align=2, sort=38)
	public String getEmployType() {
		return employType;
	}

	public void setEmployType(String employType) {
		this.employType = employType;
	}
	
	@Length(min=0, max=50, message="职位长度必须介于 0 和 50 之间")
	@ExcelField(title="职位", align=2, sort=39)
	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="首次参加工作时间", align=2, sort=40)
	public Date getFirstWorkDate() {
		return firstWorkDate;
	}

	public void setFirstWorkDate(Date firstWorkDate) {
		this.firstWorkDate = firstWorkDate;
	}
	
	@Length(min=0, max=50, message="工作地点长度必须介于 0 和 50 之间")
	@ExcelField(title="工作地点", align=2, sort=41)
	public String getWorkAddress() {
		return workAddress;
	}

	public void setWorkAddress(String workAddress) {
		this.workAddress = workAddress;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="现合同开始时间", align=2, sort=42)
	public Date getContractStartDate() {
		return contractStartDate;
	}

	public void setContractStartDate(Date contractStartDate) {
		this.contractStartDate = contractStartDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="现合同结束时间", align=2, sort=43)
	public Date getContractEndDate() {
		return contractEndDate;
	}

	public void setContractEndDate(Date contractEndDate) {
		this.contractEndDate = contractEndDate;
	}
	
	@Length(min=0, max=255, message="合同文件长度必须介于 0 和 255 之间")
	public String getContractFile() {
		return contractFile;
	}

	public void setContractFile(String contractFile) {
		this.contractFile = contractFile;
	}
	
	@Length(min=0, max=1, message="招聘渠道长度必须介于 0 和 1 之间")
	@ExcelField(title="招聘渠道", dictType="recruit_source", align=2, sort=45)
	public String getRecruitSource() {
		return recruitSource;
	}

	public void setRecruitSource(String recruitSource) {
		this.recruitSource = recruitSource;
	}
	
	@Length(min=0, max=50, message="推荐企业/人长度必须介于 0 和 50 之间")
	@ExcelField(title="推荐企业/人", align=2, sort=46)
	public String getRecommend() {
		return recommend;
	}

	public void setRecommend(String recommend) {
		this.recommend = recommend;
	}
	
	@Length(min=0, max=1, message="员工状态长度必须介于 0 和 1 之间")
	@ExcelField(title="员工状态", dictType="employ_status", align=2, sort=47)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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
	
	public Date getBeginEntryDate() {
		return beginEntryDate;
	}

	public void setBeginEntryDate(Date beginEntryDate) {
		this.beginEntryDate = beginEntryDate;
	}
	
	public Date getEndEntryDate() {
		return endEntryDate;
	}

	public void setEndEntryDate(Date endEntryDate) {
		this.endEntryDate = endEntryDate;
	}

	public Date getBeginContractEndDate() {
		return beginContractEndDate;
	}

	public void setBeginContractEndDate(Date beginContractEndDate) {
		this.beginContractEndDate = beginContractEndDate;
	}

	public Date getEndContractEndDate() {
		return endContractEndDate;
	}

	public void setEndContractEndDate(Date endContractEndDate) {
		this.endContractEndDate = endContractEndDate;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public HrResume getHrResume() {
		return hrResume;
	}

	public void setHrResume(HrResume hrResume) {
		this.hrResume = hrResume;
	}

	public Integer getProbationPeriod() {
		return probationPeriod;
	}

	public void setProbationPeriod(Integer probationPeriod) {
		this.probationPeriod = probationPeriod;
	}

	public String getRegularEvaluation() {
		return regularEvaluation;
	}

	public void setRegularEvaluation(String regularEvaluation) {
		this.regularEvaluation = regularEvaluation;
	}

	public String getIsEdit() {
		return isEdit;
	}

	public void setIsEdit(String isEdit) {
		this.isEdit = isEdit;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	public Date getBeginRegularDate() {
		return beginRegularDate;
	}

	public void setBeginRegularDate(Date beginRegularDate) {
		this.beginRegularDate = beginRegularDate;
	}

	public Date getEndRegularDate() {
		return endRegularDate;
	}

	public void setEndRegularDate(Date endRegularDate) {
		this.endRegularDate = endRegularDate;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getPositionLevel() {
		return positionLevel;
	}

	public void setPositionLevel(String positionLevel) {
		this.positionLevel = positionLevel;
	}

}