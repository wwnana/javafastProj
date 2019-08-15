package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 话题Entity
 * @author javafast
 * @version 2018-06-12
 */
public class OaTopicRecord extends DataEntity<OaTopicRecord> {
	
	private static final long serialVersionUID = 1L;
	private OaTopic oaTopic;		// 话题ID 父类
	private User user;		// 回复人
	private String notes;		// 回复内容
	private Integer thumbs;   //点赞数
	
	public OaTopicRecord() {
		super();
	}

	public OaTopicRecord(String id){
		super(id);
	}

	public OaTopicRecord(OaTopic oaTopic){
		this.oaTopic = oaTopic;
	}

	@Length(min=0, max=30, message="话题ID长度必须介于 0 和 30 之间")
	public OaTopic getOaTopic() {
		return oaTopic;
	}

	public void setOaTopic(OaTopic oaTopic) {
		this.oaTopic = oaTopic;
	}
	
	@ExcelField(title="回复人", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=50, message="回复内容长度必须介于 0 和 50 之间")
	@ExcelField(title="回复内容", align=2, sort=3)
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public Integer getThumbs() {
		return thumbs;
	}

	public void setThumbs(Integer thumbs) {
		this.thumbs = thumbs;
	}
	
}