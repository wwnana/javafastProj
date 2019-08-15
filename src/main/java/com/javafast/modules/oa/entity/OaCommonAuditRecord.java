package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 审批流程Entity
 */
public class OaCommonAuditRecord extends DataEntity<OaCommonAuditRecord> {
	
	private static final long serialVersionUID = 1L;
	private Integer auditOrder;		// 审批顺序
	private OaCommonAudit commonAudit;		// 审批ID 父类
	private String dealType;		// 执行类型 0 审批，1查阅
	private User user;		// 执行人
	private String readFlag;		// 阅读标记
	private Date readDate;		// 阅读时间
	private String auditStatus;		// 审批结果
	private Date auditDate;		// 审批时间
	private String auditNotes;		// 审批意见
	
	public OaCommonAuditRecord() {
		super();
	}

	public OaCommonAuditRecord(String id){
		super(id);
	}

	public OaCommonAuditRecord(OaCommonAudit commonAudit){
		this.commonAudit = commonAudit;
	}

	@ExcelField(title="审批顺序", align=2, sort=1)
	public Integer getAuditOrder() {
		return auditOrder;
	}

	public void setAuditOrder(Integer auditOrder) {
		this.auditOrder = auditOrder;
	}
	
	public OaCommonAudit getCommonAudit() {
		return commonAudit;
	}

	public void setCommonAudit(OaCommonAudit commonAudit) {
		this.commonAudit = commonAudit;
	}
	
	@Length(min=0, max=1, message="执行类型长度必须介于 0 和 1 之间")
	@ExcelField(title="执行类型", dictType="audit_deal_type", align=2, sort=3)
	public String getDealType() {
		return dealType;
	}

	public void setDealType(String dealType) {
		this.dealType = dealType;
	}
	
	@ExcelField(title="执行人", fieldType=User.class, value="user.name", align=2, sort=4)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=1, message="阅读标记长度必须介于 0 和 1 之间")
	@ExcelField(title="阅读标记", align=2, sort=5)
	public String getReadFlag() {
		return readFlag;
	}

	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="阅读时间", align=2, sort=6)
	public Date getReadDate() {
		return readDate;
	}

	public void setReadDate(Date readDate) {
		this.readDate = readDate;
	}
	
	@Length(min=0, max=1, message="审批结果长度必须介于 0 和 1 之间")
	@ExcelField(title="审批结果", dictType="common_audit_status", align=2, sort=7)
	public String getAuditStatus() {
		return auditStatus;
	}

	public void setAuditStatus(String auditStatus) {
		this.auditStatus = auditStatus;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="审批时间", align=2, sort=8)
	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}
	
	@Length(min=0, max=200, message="审批意见长度必须介于 0 和 200 之间")
	@ExcelField(title="审批意见", align=2, sort=9)
	public String getAuditNotes() {
		return auditNotes;
	}

	public void setAuditNotes(String auditNotes) {
		this.auditNotes = auditNotes;
	}
	
}