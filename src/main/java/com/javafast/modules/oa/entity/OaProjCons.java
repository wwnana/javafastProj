package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.ActEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;

/**
 * 项目咨询流程表Entity
 * @author javafast
 * @version 2019-08-16
 */
public class OaProjCons extends ActEntity<OaProjCons> {
	
	private static final long serialVersionUID = 1L;
	private String procInsId;		// 流程实例ID
	private OaProject project;		// 项目ID
	private String status;		// 定位当前节点
	private User user;		// 申请用户
	private String files;		// 附件
	private User audit;		// 审批人
	private String auditText;		// 审批意见
	private Office office;//申请用户的所属部门
	
	public OaProjCons() {
		super();
	}

	public OaProjCons(String id){
		super(id);
	}

	@Length(min=0, max=64, message="流程实例ID长度必须介于 0 和 64 之间")
	@ExcelField(title="流程实例ID", align=2, sort=1)
	public String getProcInsId() {
		return procInsId;
	}

	public void setProcInsId(String procInsId) {
		this.procInsId = procInsId;
	}
	
	@Length(min=0, max=64, message="定位当前节点长度必须介于 0 和 64 之间")
	@ExcelField(title="定位当前节点", align=2, sort=3)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="申请用户", fieldType=User.class, value="user.name", align=2, sort=4)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	@ExcelField(title="附件", align=2, sort=5)
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=0, max=255, message="审批意见长度必须介于 0 和 255 之间")
	@ExcelField(title="审批意见", align=2, sort=7)
	public String getAuditText() {
		return auditText;
	}

	public void setAuditText(String auditText) {
		this.auditText = auditText;
	}

	public OaProject getProject() {
		return project;
	}

	public void setProject(OaProject project) {
		this.project = project;
	}

	public User getAudit() {
		return audit;
	}

	public void setAudit(User audit) {
		this.audit = audit;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

}