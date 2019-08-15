package com.javafast.modules.sys.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 动态Entity
 */
public class SysDynamic extends DataEntity<SysDynamic> {
	
	private static final long serialVersionUID = 1L;
	private String objectType;		// 对象类型
	private String actionType;		// 动作类型
	private String targetId;		// 对象ID
	private String targetName;		// 对象名称
	private String customerId;		// 关联客户
	private String customerName;		// 关联客户名称
	
	private Date beginCreateDate;		// 开始 操作时间
	private Date endCreateDate;		// 结束 操作时间
	
	private String userName;
	private String userPhoto;
	
	public SysDynamic() {
		super();
	}

	public SysDynamic(String id){
		super(id);
	}

	public SysDynamic(String objectType, String targetId){
		this.objectType = objectType;
		this.targetId = targetId;
	}
	
	public SysDynamic(String customerId, boolean byCustomerId){
		this.customerId = customerId;
	}
	
	@Length(min=0, max=2, message="对象类型长度必须介于 0 和 2 之间")
	@ExcelField(title="对象类型", dictType="object_type", align=2, sort=1)
	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	
	@Length(min=0, max=2, message="动作类型长度必须介于 0 和 2 之间")
	@ExcelField(title="动作类型", dictType="action_type", align=2, sort=2)
	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
	}
	
	@Length(min=0, max=30, message="对象ID长度必须介于 0 和 30 之间")
	@ExcelField(title="对象ID", align=2, sort=3)
	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}
	
	@Length(min=0, max=50, message="对象名称长度必须介于 0 和 50 之间")
	@ExcelField(title="对象名称", align=2, sort=4)
	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}
	
	@Length(min=0, max=30, message="关联客户长度必须介于 0 和 30 之间")
	@ExcelField(title="关联客户", align=2, sort=7)
	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
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

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhoto() {
		return userPhoto;
	}

	public void setUserPhoto(String userPhoto) {
		this.userPhoto = userPhoto;
	}
		
}