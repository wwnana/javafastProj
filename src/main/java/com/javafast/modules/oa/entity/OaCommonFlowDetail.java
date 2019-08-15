package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 流程配置Entity
 * @author javafast
 * @version 2017-08-25
 */
public class OaCommonFlowDetail extends DataEntity<OaCommonFlowDetail> {
	
	private static final long serialVersionUID = 1L;
	private OaCommonFlow commonFlow;		// 流程ID 父类
	private Integer sort;		// 审批顺序
	private String dealType;		// 执行类型
	private User user;		// 执行人
	
	public OaCommonFlowDetail() {
		super();
	}

	public OaCommonFlowDetail(String id){
		super(id);
	}

	public OaCommonFlowDetail(OaCommonFlow commonFlow){
		this.commonFlow = commonFlow;
	}

	public OaCommonFlow getCommonFlow() {
		return commonFlow;
	}

	public void setCommonFlow(OaCommonFlow commonFlow) {
		this.commonFlow = commonFlow;
	}
	
	@ExcelField(title="审批顺序", align=2, sort=2)
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
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
	
}