package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;

/**
 * 跟进记录Entity
 */
public class CrmContactRecord extends DataEntity<CrmContactRecord> {
	
	private static final long serialVersionUID = 1L;
	
	private String targetType;    //业务类型
	private String targetId;       //业务ID
	private String targetName;     //业务名称
	
	private String contactType;		// 沟通方式
	private Date contactDate;		// 沟通日期
	private String content;		// 沟通内容
	private User ownBy;
	private Date nextcontactDate;		// 下次联系时间
	private String nextcontactNote;		// 下次联系内容
	
	private Date beginContactDate;		// 开始 下次联系时间
	private Date endContactDate;		// 结束 下次联系时间
	
	public CrmContactRecord() {
		super();
	}

	public CrmContactRecord(String id){
		super(id);
	}
	
	@Length(min=0, max=2, message="业务类型长度必须介于 0 和 2 之间")
	@ExcelField(title="业务类型", dictType="object_type", align=2, sort=1)
	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	@Length(min=0, max=50, message="业务ID长度必须介于 0 和 50 之间")
	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	@Length(min=0, max=50, message="业务名称长度必须介于 0 和 50 之间")
	@ExcelField(title="业务名称", align=2, sort=2)
	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}

	@Length(min=0, max=2, message="沟通主题长度必须介于 0 和 2 之间")
	@ExcelField(title="沟通主题", dictType="contact_type", align=2, sort=2)
	public String getContactType() {
		return contactType;
	}

	public void setContactType(String contactType) {
		this.contactType = contactType;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title="沟通日期", align=2, sort=3)
	public Date getContactDate() {
		return contactDate;
	}

	public void setContactDate(Date contactDate) {
		this.contactDate = contactDate;
	}
	
	@Length(min=0, max=500, message="沟通内容长度必须介于 0 和 500 之间")
	@ExcelField(title="沟通内容", align=2, sort=4)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@JsonFormat(pattern = "yyyy-MM-dd")
	public Date getNextcontactDate() {
		return nextcontactDate;
	}

	public void setNextcontactDate(Date nextcontactDate) {
		this.nextcontactDate = nextcontactDate;
	}
	
	@Length(min=0, max=50, message="下次联系内容长度必须介于 0 和 50 之间")
	public String getNextcontactNote() {
		return nextcontactNote;
	}

	public void setNextcontactNote(String nextcontactNote) {
		this.nextcontactNote = nextcontactNote;
	}

	public Date getBeginContactDate() {
		return beginContactDate;
	}

	public void setBeginContactDate(Date beginContactDate) {
		this.beginContactDate = beginContactDate;
	}

	public Date getEndContactDate() {
		return endContactDate;
	}

	public void setEndContactDate(Date endContactDate) {
		this.endContactDate = endContactDate;
	}

	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
}