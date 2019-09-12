package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.Collections3;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 任务Entity
 * @author javafast
 * @version 2017-07-08
 */
public class OaTask extends DataEntity<OaTask> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 任务编号
	private String name;		// 任务名称
	private String relationType;		// 任务类型
	private String relationId;		// 关联ID
	private String relationName;		// 关联名称
	private Date startDate;
	private Date endDate;		// 截止日期
	private String levelType;		// 优先级
	private Integer schedule;		// 进度
	private String content;		// 任务描述
	private String files;		// 附件
	private User ownBy;		// 负责人
	private String status;		// 任务状态
	private Date beginEndDate;		// 开始 截止日期
	private Date endEndDate;		// 结束 截止日期
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	private String procDef;//关联流程定义
	private List<OaTaskRecord> oaTaskRecordList = Lists.newArrayList();		// 子表列表
	
	private boolean isSelf;		// 是否只查询自己的任务
	private String readFlag;	// 本人阅读状态
	private boolean isUnComplete;    //未完成的
	
	public OaTask() {
		super();
	}

	public OaTask(String id){
		super(id);
	}

	@ExcelField(title="任务编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="任务名称长度必须介于 1 和 50 之间")
	@ExcelField(title="任务名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=30, message="任务类型长度必须介于 0 和 30 之间")
	@ExcelField(title="任务类型", dictType="relation_type", align=2, sort=3)
	public String getRelationType() {
		return relationType;
	}

	public void setRelationType(String relationType) {
		this.relationType = relationType;
	}
	
	@Length(min=0, max=30, message="关联ID长度必须介于 0 和 30 之间")
	public String getRelationId() {
		return relationId;
	}

	public void setRelationId(String relationId) {
		this.relationId = relationId;
	}
	
	@Length(min=0, max=50, message="关联名称长度必须介于 0 和 50 之间")
	@ExcelField(title="关联名称", align=2, sort=5)
	public String getRelationName() {
		return relationName;
	}

	public void setRelationName(String relationName) {
		this.relationName = relationName;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="截止日期", align=2, sort=6)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@Length(min=0, max=1, message="优先级长度必须介于 0 和 1 之间")
	@ExcelField(title="优先级", dictType="level_type", align=2, sort=7)
	public String getLevelType() {
		return levelType;
	}

	public void setLevelType(String levelType) {
		this.levelType = levelType;
	}
	
	public Integer getSchedule() {
		return schedule;
	}

	public void setSchedule(Integer schedule) {
		this.schedule = schedule;
	}
	
	@ExcelField(title="任务描述", align=2, sort=9)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=2000, message="附件长度必须介于 0 和 2000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=11)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="任务状态长度必须介于 0 和 1 之间")
	@ExcelField(title="任务状态", dictType="task_status", align=2, sort=12)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getBeginEndDate() {
		return beginEndDate;
	}

	public void setBeginEndDate(Date beginEndDate) {
		this.beginEndDate = beginEndDate;
	}
	
	public Date getEndEndDate() {
		return endEndDate;
	}

	public void setEndEndDate(Date endEndDate) {
		this.endEndDate = endEndDate;
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
		
	public List<OaTaskRecord> getOaTaskRecordList() {
		return oaTaskRecordList;
	}

	public void setOaTaskRecordList(List<OaTaskRecord> oaTaskRecordList) {
		this.oaTaskRecordList = oaTaskRecordList;
	}
	
	/**
	 * 获取任务抄送记录用户ID
	 * @return
	 */
	public String getOaTaskRecordIds() {
		return Collections3.extractToString(oaTaskRecordList, "user.id", ",") ;
	}
	
	/**
	 * 设置任务抄送记录用户ID
	 * @return
	 */
	public void setOaTaskRecordIds(String oaTaskRecord) {
		this.oaTaskRecordList = Lists.newArrayList();
		for (String id : StringUtils.split(oaTaskRecord, ",")){
			OaTaskRecord entity = new OaTaskRecord();
			entity.setOaTask(this);
			entity.setUser(new User(id));
			entity.setReadFlag("0");
			this.oaTaskRecordList.add(entity);
		}
	}
	
	/**
	 * 获取任务抄送记录用户Name
	 * @return
	 */
	public String getOaTaskRecordNames() {
		return Collections3.extractToString(oaTaskRecordList, "user.name", ",") ;
	}
	
	/**
	 * 设置任务抄送记录用户Name
	 * @return
	 */
	public void setOaTaskRecordNames(String oaTaskRecord) {
		// 什么也不做
	}

	public boolean isSelf() {
		return isSelf;
	}

	public void setSelf(boolean isSelf) {
		this.isSelf = isSelf;
	}

	public String getReadFlag() {
		return readFlag;
	}

	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}

	public boolean getIsUnComplete() {
		return isUnComplete;
	}

	public void setIsUnComplete(boolean isUnComplete) {
		this.isUnComplete = isUnComplete;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public String getProcDef() {
		return procDef;
	}

	public void setProcDef(String procDef) {
		this.procDef = procDef;
	}

	
}