package com.javafast.modules.crm.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.javafast.common.persistence.TreeEntity;

/**
 * 客户分类Entity
 */
public class CrmCustomerType extends TreeEntity<CrmCustomerType> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomerType parent;		// 上级分类
	private String parentIds;		// 所有父级编号
	private String name;		// 分类名称
	private String authType;		// 数据权限 0公开，1私有
	private Integer sort;		// 排序
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public CrmCustomerType() {
		super();
	}

	public CrmCustomerType(String id){
		super(id);
	}

	@JsonBackReference
	public CrmCustomerType getParent() {
		return parent;
	}

	public void setParent(CrmCustomerType parent) {
		this.parent = parent;
	}
	
	@Length(min=0, max=1000, message="所有父级编号长度必须介于 0 和 1000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}
	
	@Length(min=1, max=50, message="分类名称长度必须介于 1 和 50 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=1, message="数据权限长度必须介于 0 和 1 之间")
	public String getAuthType() {
		return authType;
	}

	public void setAuthType(String authType) {
		this.authType = authType;
	}
	
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
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
		
	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}
}