/**
 * Copyright &copy; 2016-2020 <a href="https://github.com.javafast">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.wms.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.TreeEntity;

/**
 * 产品分类Entity
 * @author javafast
 * @version 2017-07-04
 */
public class WmsProductType extends TreeEntity<WmsProductType> {
	
	private static final long serialVersionUID = 1L;
	private WmsProductType parent;		// 上级分类
	private String parentIds;		// 所有父级编号
	private String name;		// 分类名称
	private Integer sort;		// 排序
	
	public WmsProductType() {
		super();
	}

	public WmsProductType(String id){
		super(id);
	}

	@JsonBackReference
	public WmsProductType getParent() {
		return parent;
	}

	public void setParent(WmsProductType parent) {
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
	
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}
}