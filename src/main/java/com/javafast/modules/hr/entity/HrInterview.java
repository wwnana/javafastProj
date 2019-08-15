package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;

/**
 * 面试Entity
 * @author javafast
 * @version 2018-06-29
 */
public class HrInterview extends DataEntity<HrInterview> {
	
	private static final long serialVersionUID = 1L;
	private HrResume hrResume;		// 简历ID
	private String position;		// 岗位
	private Date interviewDate;		// 面试日期
	private Date interviewTime;		// 面试时间1520
	private String interviewType;		// 面试类型 0：初试，1：复试
	private String inviteStatus;		// 邀约状态 1 已邀约, 2: 已接受, 3已拒绝
	private String linkMan;		// 联系人
	private String linkPhone;		// 联系电话
	private String address;		// 面试地点
	private String company;		// 公司名称
	private String signStatus;		// 签到状态 0： 未签到，1：已签到
	private Date signTime;		// 签到时间1520
	private User interviewBy;		// 面试官
	private String interviewNote;		// 面试反馈
	private String status;		// 反馈状态0 未反馈，1已反馈
	
	private String content;    //邮件内容
	private String isSmsMsg;   //发送短信消息
	private String isEmailMsg;  //发送邮件消息
	private boolean isUnComplete = false;    //待办的
	
	//查询条件
	private Date beginInterviewDate;		// 开始面试日期
	private Date endInterviewDate;		// 开始面试日期
	
	public HrInterview() {
		super();
	}

	public HrInterview(String id){
		super(id);
	}

	public HrInterview(String id, HrResume hrResume){
		super(id);
		this.hrResume = hrResume;
	}
	
	@Length(min=0, max=50, message="岗位长度必须介于 0 和 50 之间")
	@ExcelField(title="岗位", align=2, sort=1)
	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="面试日期", align=2, sort=2)
	public Date getInterviewDate() {
		return interviewDate;
	}

	public void setInterviewDate(Date interviewDate) {
		this.interviewDate = interviewDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="面试时间1520", align=2, sort=3)
	public Date getInterviewTime() {
		return interviewTime;
	}

	public void setInterviewTime(Date interviewTime) {
		this.interviewTime = interviewTime;
	}
	
	@Length(min=0, max=1, message="邀约状态 0 未邀约，1 已邀约长度必须介于 0 和 1 之间")
	@ExcelField(title="邀约状态 0 未邀约，1 已邀约", dictType="invite_status", align=2, sort=4)
	public String getInviteStatus() {
		return inviteStatus;
	}

	public void setInviteStatus(String inviteStatus) {
		this.inviteStatus = inviteStatus;
	}
	
	@Length(min=0, max=50, message="联系人长度必须介于 0 和 50 之间")
	@ExcelField(title="联系人", align=2, sort=5)
	public String getLinkMan() {
		return linkMan;
	}

	public void setLinkMan(String linkMan) {
		this.linkMan = linkMan;
	}
	
	@Length(min=0, max=20, message="联系电话长度必须介于 0 和 20 之间")
	@ExcelField(title="联系电话", align=2, sort=6)
	public String getLinkPhone() {
		return linkPhone;
	}

	public void setLinkPhone(String linkPhone) {
		this.linkPhone = linkPhone;
	}
	
	@Length(min=0, max=50, message="面试地点长度必须介于 0 和 50 之间")
	@ExcelField(title="面试地点", align=2, sort=7)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=1, message="签到状态 0： 未签到，1：已签到长度必须介于 0 和 1 之间")
	@ExcelField(title="签到状态 0： 未签到，1：已签到", dictType="sign_status", align=2, sort=8)
	public String getSignStatus() {
		return signStatus;
	}

	public void setSignStatus(String signStatus) {
		this.signStatus = signStatus;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="签到时间1520", align=2, sort=9)
	public Date getSignTime() {
		return signTime;
	}

	public void setSignTime(Date signTime) {
		this.signTime = signTime;
	}
	
	@ExcelField(title="面试官", fieldType=User.class, value="interviewBy.name", align=2, sort=10)
	public User getInterviewBy() {
		return interviewBy;
	}

	public void setInterviewBy(User interviewBy) {
		this.interviewBy = interviewBy;
	}
	
	@Length(min=0, max=200, message="面试反馈长度必须介于 0 和 200 之间")
	@ExcelField(title="面试反馈", align=2, sort=11)
	public String getInterviewNote() {
		return interviewNote;
	}

	public void setInterviewNote(String interviewNote) {
		this.interviewNote = interviewNote;
	}
	
	@Length(min=0, max=1, message="反馈状态长度必须介于 0 和 1 之间")
	@ExcelField(title="反馈状态", align=2, sort=12)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@ExcelField(title="姓名", fieldType=HrResume.class, value="hrResume.name", align=2, sort=0)
	public HrResume getHrResume() {
		return hrResume;
	}

	public void setHrResume(HrResume hrResume) {
		this.hrResume = hrResume;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
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

	public boolean isUnComplete() {
		return isUnComplete;
	}

	public void setUnComplete(boolean isUnComplete) {
		this.isUnComplete = isUnComplete;
	}

	public String getInterviewType() {
		return interviewType;
	}

	public void setInterviewType(String interviewType) {
		this.interviewType = interviewType;
	}

	public Date getBeginInterviewDate() {
		return beginInterviewDate;
	}

	public void setBeginInterviewDate(Date beginInterviewDate) {
		this.beginInterviewDate = beginInterviewDate;
	}

	public Date getEndInterviewDate() {
		return endInterviewDate;
	}

	public void setEndInterviewDate(Date endInterviewDate) {
		this.endInterviewDate = endInterviewDate;
	}
	
}