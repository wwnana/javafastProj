package com.javafast.modules.hr.entity;

import com.javafast.modules.hr.entity.HrRecruit;
import com.javafast.modules.sys.entity.User;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 简历Entity
 * @author javafast
 * @version 2018-06-29
 */
public class HrResume extends DataEntity<HrResume> {
	
	private static final long serialVersionUID = 1L;
	private HrRecruit hrRecruit;		// 招聘任务
	private String resumeSource;		// 简历来源 1:智联，2:51job, 3:拉钩，10：其他
	private String position;		// 应聘岗位
	private String resumeFile;		// 简历文件
	private String name;		// 姓名
	private String sex;		// 性别
	private Integer age;		// 年龄
	private String mobile;		// 手机号
	private String mail;		// 邮箱
	private Integer experience;		// 工作经验
	private String education;		// 学历
	private String lastCompany;		// 上家公司
	private String lastJob;		// 上家职位
	private String university;		// 毕业院校
	private String specialty;		// 专业
	private String currentNode;		// 当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
	private String resumeStatus;		// 简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过
	private String interviewStatus;		// 面试状态：已邀约0，1已签到, 2已面试 3: 已取消
	private String employStatus;		// 录用状态：0待确认,1已接受, 2已入职,3已拒绝
	private String reserveStatus;		// 人才库状态：0已淘汰，1人才储备，2未入职
	private String reserveCause;        //放弃原因
	private Integer interviewNum;		// 面试次数
	private String hrEmployeeId;		// 基础用户表
	
	private User ownBy;    //推荐共享给
	
	public HrResume() {
		super();
	}

	public HrResume(String id){
		super(id);
	}

	@ExcelField(title="招聘任务", align=2, sort=1)
	public HrRecruit getHrRecruit() {
		return hrRecruit;
	}

	public void setHrRecruit(HrRecruit hrRecruit) {
		this.hrRecruit = hrRecruit;
	}
	
	@Length(min=1, max=2, message="简历来源 1:智联，2:51job, 3:拉钩，10：其他长度必须介于 1 和 2 之间")
	@ExcelField(title="简历来源 1:智联，2:51job, 3:拉钩，10：其他", dictType="resume_source", align=2, sort=2)
	public String getResumeSource() {
		return resumeSource;
	}

	public void setResumeSource(String resumeSource) {
		this.resumeSource = resumeSource;
	}
	
	@Length(min=1, max=50, message="应聘岗位长度必须介于 1 和 50 之间")
	@ExcelField(title="应聘岗位", align=2, sort=3)
	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	@Length(min=0, max=255, message="简历文件长度必须介于 0 和 255 之间")
	@ExcelField(title="简历文件", align=2, sort=4)
	public String getResumeFile() {
		return resumeFile;
	}

	public void setResumeFile(String resumeFile) {
		this.resumeFile = resumeFile;
	}
	
	@Length(min=1, max=20, message="姓名长度必须介于 1 和 20 之间")
	@ExcelField(title="姓名", align=2, sort=5)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=2, message="性别长度必须介于 0 和 2 之间")
	@ExcelField(title="性别", align=2, sort=6)
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@ExcelField(title="年龄", align=2, sort=7)
	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}
	
	@Length(min=1, max=11, message="手机号长度必须介于 1 和 11 之间")
	@ExcelField(title="手机号", align=2, sort=8)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=1, max=50, message="邮箱长度必须介于 1 和 50 之间")
	@ExcelField(title="邮箱", align=2, sort=9)
	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}
	
	@ExcelField(title="工作经验", dictType="experience_type", align=2, sort=10)
	public Integer getExperience() {
		return experience;
	}

	public void setExperience(Integer experience) {
		this.experience = experience;
	}
	
	@Length(min=0, max=20, message="学历长度必须介于 0 和 20 之间")
	@ExcelField(title="学历", dictType="education_type", align=2, sort=11)
	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
	}
	
	@Length(min=0, max=50, message="上家公司长度必须介于 0 和 50 之间")
	@ExcelField(title="上家公司", align=2, sort=12)
	public String getLastCompany() {
		return lastCompany;
	}

	public void setLastCompany(String lastCompany) {
		this.lastCompany = lastCompany;
	}
	
	@Length(min=0, max=50, message="上家职位长度必须介于 0 和 50 之间")
	@ExcelField(title="上家职位", align=2, sort=13)
	public String getLastJob() {
		return lastJob;
	}

	public void setLastJob(String lastJob) {
		this.lastJob = lastJob;
	}
	
	@Length(min=0, max=50, message="毕业院校长度必须介于 0 和 50 之间")
	@ExcelField(title="毕业院校", align=2, sort=14)
	public String getUniversity() {
		return university;
	}

	public void setUniversity(String university) {
		this.university = university;
	}
	
	@Length(min=0, max=50, message="专业长度必须介于 0 和 50 之间")
	@ExcelField(title="专业", align=2, sort=15)
	public String getSpecialty() {
		return specialty;
	}

	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}
	
	@Length(min=0, max=1, message="当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库长度必须介于 0 和 1 之间")
	@ExcelField(title="当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库", dictType="", align=2, sort=16)
	public String getCurrentNode() {
		return currentNode;
	}

	public void setCurrentNode(String currentNode) {
		this.currentNode = currentNode;
	}
	
	@Length(min=0, max=1, message="简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过长度必须介于 0 和 1 之间")
	@ExcelField(title="简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过", dictType="resume_status", align=2, sort=17)
	public String getResumeStatus() {
		return resumeStatus;
	}

	public void setResumeStatus(String resumeStatus) {
		this.resumeStatus = resumeStatus;
	}
	
	@Length(min=0, max=1, message="面试状态：已邀约0，1已签到, 2已面试 3: 已取消长度必须介于 0 和 1 之间")
	@ExcelField(title="面试状态：已邀约0，1已签到, 2已面试 3: 已取消", dictType="interview_status", align=2, sort=18)
	public String getInterviewStatus() {
		return interviewStatus;
	}

	public void setInterviewStatus(String interviewStatus) {
		this.interviewStatus = interviewStatus;
	}
	
	@Length(min=0, max=1, message="录用状态：0待确认,1已接受, 2已入职,3已拒绝长度必须介于 0 和 1 之间")
	@ExcelField(title="录用状态：0待确认,1已接受, 2已入职,3已拒绝", dictType="employ_status", align=2, sort=19)
	public String getEmployStatus() {
		return employStatus;
	}

	public void setEmployStatus(String employStatus) {
		this.employStatus = employStatus;
	}
	
	@ExcelField(title="面试次数", align=2, sort=20)
	public Integer getInterviewNum() {
		return interviewNum;
	}

	public void setInterviewNum(Integer interviewNum) {
		this.interviewNum = interviewNum;
	}
	
	@Length(min=1, max=30, message="基础用户表长度必须介于 1 和 30 之间")
	@ExcelField(title="基础用户表", align=2, sort=27)
	public String getHrEmployeeId() {
		return hrEmployeeId;
	}

	public void setHrEmployeeId(String hrEmployeeId) {
		this.hrEmployeeId = hrEmployeeId;
	}

	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}

	public String getReserveStatus() {
		return reserveStatus;
	}

	public void setReserveStatus(String reserveStatus) {
		this.reserveStatus = reserveStatus;
	}

	public String getReserveCause() {
		return reserveCause;
	}

	public void setReserveCause(String reserveCause) {
		this.reserveCause = reserveCause;
	}
}