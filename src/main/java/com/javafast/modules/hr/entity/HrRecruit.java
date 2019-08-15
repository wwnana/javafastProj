package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 招聘任务Entity
 * @author javafast
 * @version 2018-06-29
 */
public class HrRecruit extends DataEntity<HrRecruit> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 岗位名称
	private String depart;		// 需求部门
	private Integer recruitNum;		// 招聘人数
	private String education;		// 学历要求
	private String experience;		// 工作经验
	private Integer schedule;		// 进度
	private String status;		// 状态：0进行中，1：已结束
	private Integer resumeNum;		// 接收简历数
	private Integer interviewNum;		// 面试人数
	private Integer offerNum;		// offer人数
	private Integer entryNum;		// 已入职
	
	public HrRecruit() {
		super();
	}

	public HrRecruit(String id){
		super(id);
	}

	@Length(min=1, max=64, message="岗位名称长度必须介于 1 和 64 之间")
	@ExcelField(title="岗位名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=50, message="需求部门长度必须介于 1 和 50 之间")
	@ExcelField(title="需求部门", align=2, sort=2)
	public String getDepart() {
		return depart;
	}

	public void setDepart(String depart) {
		this.depart = depart;
	}
	
	@NotNull(message="招聘人数不能为空")
	@ExcelField(title="招聘人数", align=2, sort=3)
	public Integer getRecruitNum() {
		return recruitNum;
	}

	public void setRecruitNum(Integer recruitNum) {
		this.recruitNum = recruitNum;
	}
	
	@Length(min=0, max=50, message="学历要求长度必须介于 0 和 50 之间")
	@ExcelField(title="学历要求", dictType="education_type", align=2, sort=4)
	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
	}
	
	@Length(min=0, max=50, message="工作经验长度必须介于 0 和 50 之间")
	@ExcelField(title="工作经验", dictType="experience_type", align=2, sort=5)
	public String getExperience() {
		return experience;
	}

	public void setExperience(String experience) {
		this.experience = experience;
	}
	
	@ExcelField(title="进度", align=2, sort=6)
	public Integer getSchedule() {
		return schedule;
	}

	public void setSchedule(Integer schedule) {
		this.schedule = schedule;
	}
	
	@Length(min=0, max=1, message="状态：0进行中，1：已结束长度必须介于 0 和 1 之间")
	@ExcelField(title="状态：0进行中，1：已结束", dictType="", align=2, sort=7)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="待面试", align=2, sort=8)
	public Integer getInterviewNum() {
		return interviewNum;
	}

	public void setInterviewNum(Integer interviewNum) {
		this.interviewNum = interviewNum;
	}
	
	@ExcelField(title="已入职", align=2, sort=9)
	public Integer getEntryNum() {
		return entryNum;
	}

	public void setEntryNum(Integer entryNum) {
		this.entryNum = entryNum;
	}

	public Integer getResumeNum() {
		return resumeNum;
	}

	public void setResumeNum(Integer resumeNum) {
		this.resumeNum = resumeNum;
	}

	public Integer getOfferNum() {
		return offerNum;
	}

	public void setOfferNum(Integer offerNum) {
		this.offerNum = offerNum;
	}
	
}