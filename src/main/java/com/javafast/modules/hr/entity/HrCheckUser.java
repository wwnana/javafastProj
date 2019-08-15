package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 打卡规则用户Entity
 * @author javafast
 * @version 2018-07-08
 */
public class HrCheckUser extends DataEntity<HrCheckUser> {
	
	private static final long serialVersionUID = 1L;
	private String userid;		// 用户id
	private String checkRuleId;		// 打卡规则表
	
	public HrCheckUser() {
		super();
	}

	public HrCheckUser(String id){
		super(id);
	}

	@Length(min=1, max=64, message="用户id长度必须介于 1 和 64 之间")
	@ExcelField(title="用户id", align=2, sort=1)
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	@Length(min=0, max=30, message="打卡规则表长度必须介于 0 和 30 之间")
	@ExcelField(title="打卡规则表", align=2, sort=2)
	public String getCheckRuleId() {
		return checkRuleId;
	}

	public void setCheckRuleId(String checkRuleId) {
		this.checkRuleId = checkRuleId;
	}
	
}