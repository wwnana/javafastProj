package com.javafast.modules.sys.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 足迹Entity
 */
public class SysBrowseLog extends DataEntity<SysBrowseLog> {
	
	private static final long serialVersionUID = 1L;
	private String targetType;		// 目标类型   1:客户,2：联系人,3：商机，4：报价，5：合同
	private String targetId;		// 目标ID
	private String targetName;		// 目标名称
	private String userId;		// 浏览者
	private Date browseDate;		// 最新浏览时间
	private Date beginBrowseDate;		// 开始 最新浏览时间
	private Date endBrowseDate;		// 结束 最新浏览时间
	
	public SysBrowseLog() {
		super();
	}

	public SysBrowseLog(String id){
		super(id);
	}

	@Length(min=0, max=2, message="目标类型长度必须介于 0 和 2 之间")
	@ExcelField(title="目标类型", dictType="target_type", align=2, sort=1)
	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}
	
	@Length(min=0, max=30, message="目标ID长度必须介于 0 和 30 之间")
	@ExcelField(title="目标ID", align=2, sort=2)
	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}
	
	@Length(min=0, max=50, message="目标名称长度必须介于 0 和 50 之间")
	@ExcelField(title="目标名称", align=2, sort=3)
	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}
	
	@Length(min=1, max=30, message="浏览者长度必须介于 1 和 30 之间")
	@ExcelField(title="浏览者", align=2, sort=4)
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="最新浏览时间不能为空")
	@ExcelField(title="最新浏览时间", align=2, sort=5)
	public Date getBrowseDate() {
		return browseDate;
	}

	public void setBrowseDate(Date browseDate) {
		this.browseDate = browseDate;
	}
	
	public Date getBeginBrowseDate() {
		return beginBrowseDate;
	}

	public void setBeginBrowseDate(Date beginBrowseDate) {
		this.beginBrowseDate = beginBrowseDate;
	}
	
	public Date getEndBrowseDate() {
		return endBrowseDate;
	}

	public void setEndBrowseDate(Date endBrowseDate) {
		this.endBrowseDate = endBrowseDate;
	}
		
}