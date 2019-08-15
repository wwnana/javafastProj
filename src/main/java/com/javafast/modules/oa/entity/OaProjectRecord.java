package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 项目Entity
 * @author javafast
 * @version 2018-05-18
 */
public class OaProjectRecord extends DataEntity<OaProjectRecord> {
	
	private static final long serialVersionUID = 1L;
	private OaProject oaProject;		// 项目ID 父类
	private User user;		// 接受人
	private String readFlag;		// 阅读标记
	private Date readDate;		// 阅读时间
	
	public OaProjectRecord() {
		super();
	}

	public OaProjectRecord(String id){
		super(id);
	}

	public OaProjectRecord(OaProject oaProject){
		this.oaProject = oaProject;
	}

	@Length(min=0, max=64, message="项目ID长度必须介于 0 和 64 之间")
	public OaProject getOaProject() {
		return oaProject;
	}

	public void setOaProject(OaProject oaProject) {
		this.oaProject = oaProject;
	}
	
	@ExcelField(title="接受人", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=1, message="阅读标记长度必须介于 0 和 1 之间")
	@ExcelField(title="阅读标记", align=2, sort=3)
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