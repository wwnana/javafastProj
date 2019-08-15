package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 审批流程Entity
 */
public class OaCommonAudit extends DataEntity<OaCommonAudit> {
	
	private static final long serialVersionUID = 1L;
	private String type;		// 审批类型   审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单, 5加班单
	private String title;		// 标题
	private String content;		// 内容
	private String files;		// 附件
	private User currentBy;		// 下一审批人
	private String status;		// 状态 0草稿，1审批中，2已通过，3不通过
	private Office office;		// 部门
	private Date beginCreateDate;		// 开始 申请时间
	private Date endCreateDate;		// 结束 申请时间
	private String createId;//申请人
	private String createName;//申请人
	
	private List<OaCommonAuditRecord> oaCommonAuditRecordList = Lists.newArrayList();		// 审批列表
	private List<OaCommonAuditRecord> oaCommonReadRecordList = Lists.newArrayList();//抄送列表
	
	private OaCommonLeave oaCommonLeave;//请假单
	private OaCommonExpense oaCommonExpense;//报销单
	private OaCommonTravel oaCommonTravel;//差旅单
	private OaCommonBorrow oaCommonBorrow;//借款单
	private OaCommonExtra oaCommonExtra;//加班单
	
	private String readNum;		// 已读
	private String unReadNum;	// 未读
	private boolean isSelf;		// 是否只查询自己的通知	
	private String readFlag;	// 本人阅读状态
	private String isSelfRead;		// 是否只查询抄送自己的审批
	
	private String oaCommonFlowId;//启动的流程ID
	
	public OaCommonAudit() {
		super();
	}

	public OaCommonAudit(String id){
		super(id);
	}

	@Length(min=0, max=2, message="审批类型长度必须介于 0 和 2 之间")
	@ExcelField(title="审批类型", dictType="common_audit_type", align=2, sort=1)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=0, max=50, message="标题长度必须介于 0 和 50 之间")
	@ExcelField(title="标题", align=2, sort=2)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@ExcelField(title="内容", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@ExcelField(title="下一审批人", fieldType=User.class, value="currentBy.name", align=2, sort=4)
	public User getCurrentBy() {
		return currentBy;
	}

	public void setCurrentBy(User currentBy) {
		this.currentBy = currentBy;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="common_audit_status", align=2, sort=5)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="部门", fieldType=Office.class, value="office.name", align=2, sort=6)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
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
		
	public List<OaCommonAuditRecord> getOaCommonAuditRecordList() {
		return oaCommonAuditRecordList;
	}

	public void setOaCommonAuditRecordList(List<OaCommonAuditRecord> oaCommonAuditRecordList) {
		this.oaCommonAuditRecordList = oaCommonAuditRecordList;
	}

	public OaCommonLeave getOaCommonLeave() {
		return oaCommonLeave;
	}

	public void setOaCommonLeave(OaCommonLeave oaCommonLeave) {
		this.oaCommonLeave = oaCommonLeave;
	}

	public OaCommonExpense getOaCommonExpense() {
		return oaCommonExpense;
	}

	public void setOaCommonExpense(OaCommonExpense oaCommonExpense) {
		this.oaCommonExpense = oaCommonExpense;
	}

	public OaCommonTravel getOaCommonTravel() {
		return oaCommonTravel;
	}

	public void setOaCommonTravel(OaCommonTravel oaCommonTravel) {
		this.oaCommonTravel = oaCommonTravel;
	}

	public OaCommonBorrow getOaCommonBorrow() {
		return oaCommonBorrow;
	}

	public void setOaCommonBorrow(OaCommonBorrow oaCommonBorrow) {
		this.oaCommonBorrow = oaCommonBorrow;
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

	public String getIsSelfRead() {
		return isSelfRead;
	}

	public void setIsSelfRead(String isSelfRead) {
		this.isSelfRead = isSelfRead;
	}

	public List<OaCommonAuditRecord> getOaCommonReadRecordList() {
		return oaCommonReadRecordList;
	}

	public void setOaCommonReadRecordList(
			List<OaCommonAuditRecord> oaCommonReadRecordList) {
		this.oaCommonReadRecordList = oaCommonReadRecordList;
	}

	public String getOaCommonFlowId() {
		return oaCommonFlowId;
	}

	public void setOaCommonFlowId(String oaCommonFlowId) {
		this.oaCommonFlowId = oaCommonFlowId;
	}

	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}

	public OaCommonExtra getOaCommonExtra() {
		return oaCommonExtra;
	}

	public void setOaCommonExtra(OaCommonExtra oaCommonExtra) {
		this.oaCommonExtra = oaCommonExtra;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
	}

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}
}