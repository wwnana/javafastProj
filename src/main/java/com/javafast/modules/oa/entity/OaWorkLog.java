package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.Collections3;
import com.javafast.common.utils.IdGen;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;

/**
 * 工作报告Entity
 * @author javafast
 * @version 2018-05-03
 */
public class OaWorkLog extends DataEntity<OaWorkLog> {
	
	private static final long serialVersionUID = 1L;
	private String workLogType;		// 类型
	private String title;		// 标题
	private String name;		// 标题
	private String content;		// 内容
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private String createId;//汇报人
	private String createName;//汇报人
	private Date workDate;	// 汇报日期
	private User auditBy;		// 汇报给
	private List<OaWorkLogRecord> oaWorkLogRecordList = Lists.newArrayList();		// 抄送给
	private String status;  //0未发送，1已发送
	
	private String readNum;		// 已读
	private String unReadNum;	// 未读	
	private boolean isSelf;		// 是否只查询自己的通知	
	private String readFlag;	// 本人阅读状态
	
	public OaWorkLog() {
		super();
	}

	public OaWorkLog(String id){
		super(id);
	}

	@Length(min=0, max=2, message="类型长度必须介于 0 和 2 之间")
	@ExcelField(title="类型", dictType="work_log_type", align=2, sort=1)
	public String getWorkLogType() {
		return workLogType;
	}

	public void setWorkLogType(String workLogType) {
		this.workLogType = workLogType;
	}
	
	@Length(min=0, max=50, message="标题长度必须介于 0 和 50 之间")
	@ExcelField(title="标题", align=2, sort=2)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=5000, message="内容长度必须介于 0 和 5000 之间")
	@ExcelField(title="内容", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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
		
	public List<OaWorkLogRecord> getOaWorkLogRecordList() {
		return oaWorkLogRecordList;
	}

	public void setOaWorkLogRecordList(List<OaWorkLogRecord> oaWorkLogRecordList) {
		this.oaWorkLogRecordList = oaWorkLogRecordList;
	}

	@ExcelField(title="汇报人", align=2, sort=4)
	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
	}

	@ExcelField(title="汇报日期", align=2, sort=5)
	public Date getWorkDate() {
		return workDate;
	}

	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}
	
	/**
	 * 获取通知发送记录用户ID
	 * @return
	 */
	public String getOaWorkLogRecordIds() {
		return Collections3.extractToString(oaWorkLogRecordList, "user.id", ",") ;
	}
	
	/**
	 * 设置通知发送记录用户ID
	 * @return
	 */
	public void setOaWorkLogRecordIds(String oaWorkLogRecord) {
		this.oaWorkLogRecordList = Lists.newArrayList();
		for (String id : StringUtils.split(oaWorkLogRecord, ",")){
			OaWorkLogRecord entity = new OaWorkLogRecord();
			entity.setId(IdGen.uuid());
			entity.setOaWorkLog(this);
			entity.setUser(new User(id));
			entity.setReadFlag("0");
			this.oaWorkLogRecordList.add(entity);
		}
	}

	/**
	 * 获取通知发送记录用户Name
	 * @return
	 */
	public String getOaWorkLogRecordNames() {
		return Collections3.extractToString(oaWorkLogRecordList, "user.name", ",") ;
	}
	
	/**
	 * 设置通知发送记录用户Name
	 * @return
	 */
	public void setOaWorkLogRecordNames(String oaWorkLogRecord) {
		// 什么也不做
	}

	public String getReadNum() {
		return readNum;
	}

	public void setReadNum(String readNum) {
		this.readNum = readNum;
	}

	public String getUnReadNum() {
		return unReadNum;
	}

	public void setUnReadNum(String unReadNum) {
		this.unReadNum = unReadNum;
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

	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
}