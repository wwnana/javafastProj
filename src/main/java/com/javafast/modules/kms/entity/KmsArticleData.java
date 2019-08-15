/**
 * Copyright 2015-2020
 */
package com.javafast.modules.kms.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 知识详情Entity
 * @author javafast
 * @version 2017-08-03
 */
public class KmsArticleData extends DataEntity<KmsArticleData> {
	
	private static final long serialVersionUID = 1L;
	private String content;		// 知识内容
	private String files;       //相关附件
	private String copyfrom;		// 知识来源
	
	public KmsArticleData() {
		super();
	}

	public KmsArticleData(String id){
		super(id);
	}

	@ExcelField(title="知识内容", align=2, sort=1)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=255, message="知识来源长度必须介于 0 和 255 之间")
	@ExcelField(title="知识来源", align=2, sort=2)
	public String getCopyfrom() {
		return copyfrom;
	}

	public void setCopyfrom(String copyfrom) {
		this.copyfrom = copyfrom;
	}

	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
}