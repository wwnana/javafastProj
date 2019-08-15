package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 流程配置Entity
 * @author javafast
 * @version 2017-08-25
 */
public class OaCommonFlow extends DataEntity<OaCommonFlow> {
	
	private static final long serialVersionUID = 1L;
	private String type;		// 审批类型
	private String title;		// 流程名称
	private String status;		// 状态
	private List<OaCommonFlowDetail> oaCommonFlowDetailList = Lists.newArrayList();		// 子表列表
	
	public OaCommonFlow() {
		super();
	}

	public OaCommonFlow(String id){
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
	
	@Length(min=0, max=50, message="流程名称长度必须介于 0 和 50 之间")
	@ExcelField(title="流程名称", align=2, sort=2)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="use_status", align=2, sort=3)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public List<OaCommonFlowDetail> getOaCommonFlowDetailList() {
		return oaCommonFlowDetailList;
	}

	public void setOaCommonFlowDetailList(List<OaCommonFlowDetail> oaCommonFlowDetailList) {
		this.oaCommonFlowDetailList = oaCommonFlowDetailList;
	}
}