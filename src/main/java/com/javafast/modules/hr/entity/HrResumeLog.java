package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * HR日志Entity
 * @author javafast
 * @version 2018-06-29
 */
public class HrResumeLog extends DataEntity<HrResumeLog> {
	
	private static final long serialVersionUID = 1L;
	private String hrResumeId;		// 简历编号
	private String note;		// 内容
	private String type;		// 事件类型：resume_action 0:创建员工信息， 1上传简历，2邀约面试，3：下发录用OFFER，4：入职    5：放弃   6：调岗   7：加薪  8：激励， ,30：离职
	
	public HrResumeLog() {
		super();
	}

	public HrResumeLog(String id){
		super(id);
	}
	
	public HrResumeLog(String id, String hrResumeId){
		super(id);
		this.hrResumeId = hrResumeId;
	}

	@Length(min=1, max=64, message="简历编号长度必须介于 1 和 64 之间")
	@ExcelField(title="简历编号", align=2, sort=1)
	public String getHrResumeId() {
		return hrResumeId;
	}

	public void setHrResumeId(String hrResumeId) {
		this.hrResumeId = hrResumeId;
	}
	
	@Length(min=0, max=200, message="内容长度必须介于 0 和 200 之间")
	@ExcelField(title="内容", align=2, sort=2)
	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}
	
	@Length(min=0, max=2, message="事件类型： 1上传简历，2邀约面试，3：下发录用OFFER，4：入职长度必须介于 0 和 2 之间")
	@ExcelField(title="事件类型： 1上传简历，2邀约面试，3：下发录用OFFER，4：入职", align=2, sort=3)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
}