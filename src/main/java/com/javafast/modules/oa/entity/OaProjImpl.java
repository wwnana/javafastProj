package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.ActEntity;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 项目实施流程表Entity
 * @author javafast
 * @version 2019-08-20
 */
public class OaProjImpl extends ActEntity<OaProjImpl> {
	
	private static final long serialVersionUID = 1L;
	private String procInsId;		// 流程实例ID
	private OaProject project;		// 项目ID
	private String status;		// 定位当前节点
	private User user;		// 申请用户ID
	private String userName;		// 申请用户名称
	private Office office;		// 申请用户部门ID
	private String officeName;		// 申请用户部门名
	private String files;		// 附件
	private User audit;		// 审批人ID
	private String auditName;		// 审批人姓名
	private String auditText;		// 审批意见
	private String createByName;
	private String updateByName;
	
	public OaProjImpl() {
		super();
	}

	public OaProjImpl(String id){
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
	
	@ExcelField(title="申请用户ID", fieldType=User.class, value="user.name", align=2, sort=4)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=64, message="申请用户名称长度必须介于 0 和 64 之间")
	@ExcelField(title="申请用户名称", align=2, sort=5)
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	@ExcelField(title="申请用户部门ID", fieldType=Office.class, value="office.name", align=2, sort=6)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=0, max=255, message="申请用户部门名长度必须介于 0 和 255 之间")
	@ExcelField(title="申请用户部门名", align=2, sort=7)
	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}
	
	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	@ExcelField(title="附件", align=2, sort=8)
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=0, max=64, message="审批人姓名长度必须介于 0 和 64 之间")
	@ExcelField(title="审批人姓名", align=2, sort=10)
	public String getAuditName() {
		return auditName;
	}

	public void setAuditName(String auditName) {
		this.auditName = auditName;
	}
	
	@Length(min=0, max=255, message="审批意见长度必须介于 0 和 255 之间")
	@ExcelField(title="审批意见", align=2, sort=11)
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

	public String getCreateByName() {
		return createByName;
	}

	public void setCreateByName(String createByName) {
		this.createByName = createByName;
	}

	public String getUpdateByName() {
		return updateByName;
	}

	public void setUpdateByName(String updateByName) {
		this.updateByName = updateByName;
	}
	
	
}