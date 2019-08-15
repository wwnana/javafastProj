package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.Collections3;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 项目Entity
 * @author javafast
 * @version 2018-05-18
 */
public class OaProject extends DataEntity<OaProject> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 项目编号
	private String name;		// 项目名称
	private Date startDate;		// 开始日期
	private Date endDate;		// 截止日期
	private Integer schedule;		// 进度
	private String content;		// 项目描述
	private String files;		// 附件
	private User ownBy;		// 负责人
	private String status;		// 状态

	private List<OaProjectRecord> oaProjectRecordList = Lists.newArrayList();		// 子表列表
	
	private Date beginEndDate;		// 开始 截止日期
	private Date endEndDate;		// 结束 截止日期
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	private boolean isSelf;		// 是否只查询自己的任务
	private String readFlag;	// 本人阅读状态
	private boolean isUnComplete;    //未完成的
	
	public OaProject() {
		super();
	}

	public OaProject(String id){
		super(id);
	}

	@ExcelField(title="项目编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=50, message="项目名称长度必须介于 1 和 50 之间")
	@ExcelField(title="项目名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="开始日期", align=2, sort=3)
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="截止日期", align=2, sort=4)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	@ExcelField(title="进度", align=2, sort=5)
	public Integer getSchedule() {
		return schedule;
	}

	public void setSchedule(Integer schedule) {
		this.schedule = schedule;
	}
	
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
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=8)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="task_status", align=2, sort=9)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public List<OaProjectRecord> getOaProjectRecordList() {
		return oaProjectRecordList;
	}

	public void setOaProjectRecordList(List<OaProjectRecord> oaProjectRecordList) {
		this.oaProjectRecordList = oaProjectRecordList;
	}
	
	/**
	 * 获取任务抄送记录用户ID
	 * @return
	 */
	public String getOaProjectRecordIds() {
		return Collections3.extractToString(oaProjectRecordList, "user.id", ",") ;
	}
	
	/**
	 * 设置任务抄送记录用户ID
	 * @return
	 */
	public void setOaProjectRecordIds(String oaProjectRecord) {
		this.oaProjectRecordList = Lists.newArrayList();
		for (String id : StringUtils.split(oaProjectRecord, ",")){
			OaProjectRecord entity = new OaProjectRecord();
			entity.setOaProject(this);
			entity.setUser(new User(id));
			entity.setReadFlag("0");
			this.oaProjectRecordList.add(entity);
		}
	}
	
	/**
	 * 获取任务抄送记录用户Name
	 * @return
	 */
	public String getOaProjectRecordNames() {
		return Collections3.extractToString(oaProjectRecordList, "user.name", ",") ;
	}
	
	/**
	 * 设置任务抄送记录用户Name
	 * @return
	 */
	public void setOaProjectRecordNames(String oaProjectRecord) {
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
	
	
}