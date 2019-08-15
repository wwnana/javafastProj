package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import com.javafast.common.persistence.ActEntity;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 项目咨询流程表Entity
 * @author javafast
 * @version 2019-08-06
 */
public class OaProjectCon extends ActEntity<OaProjectCon> {
	
	private static final long serialVersionUID = 1L;
	//private String procInsId;		// 流程实例ID
	private User user;		// 申请用户
	private Office office;		// 归属部门
	private String post;		// 岗位
	private String hrText;		// 项目负责人意见
	private String leadFstText;		// 院领导1意见
	private String leadSecText;		// 院领导2意见
	private String files;		// 附件
	private OaProject project;		// 所属项目
	private String userId1;
	private String userId2;
	private String userId3;
	
	public OaProjectCon() {
		super();
	}

	public OaProjectCon(String id){
		super(id);
	}

//	@Length(min=0, max=64, message="流程实例ID长度必须介于 0 和 64 之间")
//	@ExcelField(title="流程实例ID", align=2, sort=1)
//	public String getProcInsId() {
//		return procInsId;
//	}
//
//	public void setProcInsId(String procInsId) {
//		this.procInsId = procInsId;
//	}
	
	@ExcelField(title="申请用户", fieldType=User.class, value="user.name", align=2, sort=2)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="归属部门", fieldType=Office.class, value="office.name", align=2, sort=3)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=0, max=255, message="岗位长度必须介于 0 和 255 之间")
	@ExcelField(title="岗位", align=2, sort=4)
	public String getPost() {
		return post;
	}

	public void setPost(String post) {
		this.post = post;
	}
	
	@Length(min=0, max=255, message="项目负责人意见长度必须介于 0 和 255 之间")
	@ExcelField(title="项目负责人意见", align=2, sort=5)
	public String getHrText() {
		return hrText;
	}

	public void setHrText(String hrText) {
		this.hrText = hrText;
	}
	
	@Length(min=0, max=255, message="院领导1意见长度必须介于 0 和 255 之间")
	@ExcelField(title="院领导1意见", align=2, sort=6)
	public String getLeadFstText() {
		return leadFstText;
	}

	public void setLeadFstText(String leadFstText) {
		this.leadFstText = leadFstText;
	}
	
	@Length(min=0, max=255, message="院领导2意见长度必须介于 0 和 255 之间")
	@ExcelField(title="院领导2意见", align=2, sort=7)
	public String getLeadSecText() {
		return leadSecText;
	}

	public void setLeadSecText(String leadSecText) {
		this.leadSecText = leadSecText;
	}
	
	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	@ExcelField(title="附件", align=2, sort=14)
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@ExcelField(title="所属项目", fieldType=OaProject.class, value="project.name", align=2, sort=15)
	public OaProject getProject() {
		return project;
	}

	public void setProject(OaProject project) {
		this.project = project;
	}

	public String getUserId1() {
		return userId1;
	}

	public void setUserId1(String userId1) {
		this.userId1 = userId1;
	}

	public String getUserId2() {
		return userId2;
	}

	public void setUserId2(String userId2) {
		this.userId2 = userId2;
	}

	public String getUserId3() {
		return userId3;
	}

	public void setUserId3(String userId3) {
		this.userId3 = userId3;
	}

	
}