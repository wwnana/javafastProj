package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 话题Entity
 * @author javafast
 * @version 2018-06-12
 */
public class OaTopic extends DataEntity<OaTopic> {
	
	private static final long serialVersionUID = 1L;
	private String title;		// 标题
	private String content;		// 内容
	private String accountId;		// account_id
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private List<OaTopicRecord> oaTopicRecordList = Lists.newArrayList();		// 子表列表
	
	private String notes;		// 回复内容
	
	public OaTopic() {
		super();
	}

	public OaTopic(String id){
		super(id);
	}

	@Length(min=0, max=50, message="标题长度必须介于 0 和 50 之间")
	@ExcelField(title="标题", align=2, sort=1)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=10000, message="内容长度必须介于 0 和10000 之间")
	@ExcelField(title="内容", align=2, sort=2)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=30, message="account_id长度必须介于 0 和 30 之间")
	@ExcelField(title="account_id", align=2, sort=6)
	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
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
		
	public List<OaTopicRecord> getOaTopicRecordList() {
		return oaTopicRecordList;
	}

	public void setOaTopicRecordList(List<OaTopicRecord> oaTopicRecordList) {
		this.oaTopicRecordList = oaTopicRecordList;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
}