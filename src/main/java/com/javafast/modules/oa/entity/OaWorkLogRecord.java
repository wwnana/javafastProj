package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 工作报告Entity
 * @author javafast
 * @version 2018-05-03
 */
public class OaWorkLogRecord extends DataEntity<OaWorkLogRecord> {
	
	private static final long serialVersionUID = 1L;
	private OaWorkLog oaWorkLog;		// 工作报告ID 父类
	private User user;		// 查阅人
	private String readFlag;		// 阅读标记
	private Date readDate;		// 阅读时间
	private String auditNotes;		// 评论内容
	
	public OaWorkLogRecord() {
		super();
	}

	public OaWorkLogRecord(String id){
		super(id);
	}

	public OaWorkLogRecord(OaWorkLog oaWorkLog){
		this.oaWorkLog = oaWorkLog;
	}

	@Length(min=0, max=30, message="工作报告ID长度必须介于 0 和 30 之间")
	public OaWorkLog getOaWorkLog() {
		return oaWorkLog;
	}

	public void setOaWorkLog(OaWorkLog oaWorkLog) {
		this.oaWorkLog = oaWorkLog;
	}
	
	@ExcelField(title="查阅人", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=1, message="阅读标记长度必须介于 0 和 1 之间")
	@ExcelField(title="阅读标记", dictType="read_flag", align=2, sort=3)
	public String getReadFlag() {
		return readFlag;
	}

	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="阅读时间", align=2, sort=4)
	public Date getReadDate() {
		return readDate;
	}

	public void setReadDate(Date readDate) {
		this.readDate = readDate;
	}
	
	@Length(min=0, max=50, message="评论内容长度必须介于 0 和 50 之间")
	@ExcelField(title="评论内容", align=2, sort=5)
	public String getAuditNotes() {
		return auditNotes;
	}

	public void setAuditNotes(String auditNotes) {
		this.auditNotes = auditNotes;
	}
	
}