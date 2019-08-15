/**
 * Copyright &copy; 2016-2020 <a href="https://github.com.javafast">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.kms.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.TreeEntity;

/**
 * 知识分类Entity
 * @author javafast
 * @version 2017-08-03
 */
public class KmsCategory extends TreeEntity<KmsCategory> {
	
	private static final long serialVersionUID = 1L;
	private KmsCategory parent;		// 上级分类
	private String parentIds;		// 所有父级编号
	private String name;		// 知识分类名称
	private Integer sort;		// 排序
	private String inMenu;		// 是否在导航中显示
	
	public KmsCategory() {
		super();
	}

	public KmsCategory(String id){
		super(id);
	}

	@JsonBackReference
	public KmsCategory getParent() {
		return parent;
	}

	public void setParent(KmsCategory parent) {
		this.parent = parent;
	}
	
	@Length(min=0, max=1000, message="所有父级编号长度必须介于 0 和 1000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}
	
	@Length(min=0, max=50, message="知识分类名称长度必须介于 0 和 50 之间")
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
	
	@Length(min=0, max=1, message="是否在导航中显示长度必须介于 0 和 1 之间")
	public String getInMenu() {
		return inMenu;
	}

	public void setInMenu(String inMenu) {
		this.inMenu = inMenu;
	}
	
	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}
}