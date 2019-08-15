package com.javafast.modules.oa.entity;

import com.javafast.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 任务Entity
 */
public class OaTaskRecord extends DataEntity<OaTaskRecord> {
	
	private static final long serialVersionUID = 1L;
	private OaTask oaTask;		// 所属任务 父类
	private User user;		// 接受人
	private String readFlag;		// 阅读标记
	private Date readDate;		// 阅读时间
	
	public OaTaskRecord() {
		super();
	}

	public OaTaskRecord(String id){
		super(id);
	}

	public OaTaskRecord(OaTask oaTask){
		this.oaTask = oaTask;
	}

	public OaTask getOaTask() {
		return oaTask;
	}

	public void setOaTask(OaTask oaTask) {
		this.oaTask = oaTask;
	}
	
	@ExcelField(title="接受人", fieldType=User.class, value="user.name", align=2, sort=2)
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
	
}