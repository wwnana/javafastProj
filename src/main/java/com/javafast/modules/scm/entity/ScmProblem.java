/**
 * Copyright 2015-2020
 */
package com.javafast.modules.scm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 常见问题Entity
 * @author javafast
 * @version 2017-08-18
 */
public class ScmProblem extends DataEntity<ScmProblem> {
	
	private static final long serialVersionUID = 1L;
	private ScmProblemType scmProblemType;		// 分类
	private String name;		// 问题名称
	private String content;		// 内容
	private String status;		// 状态
	private String createName; 
	
	public ScmProblem() {
		super();
	}

	public ScmProblem(String id){
		super(id);
	}

	@Length(min=1, max=50, message="问题名称长度必须介于 1 和 50 之间")
	@ExcelField(title="问题名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=100000, message="内容长度必须介于 0 和 100000 之间")
	@ExcelField(title="内容", align=2, sort=2)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="oa_notify_status", align=2, sort=3)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public ScmProblemType getScmProblemType() {
		return scmProblemType;
	}

	public void setScmProblemType(ScmProblemType scmProblemType) {
		this.scmProblemType = scmProblemType;
	}

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}
	
}