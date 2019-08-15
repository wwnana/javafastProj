package com.javafast.modules.kms.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 知识评论Entity
 * @author javafast
 * @version 2018-05-14
 */
public class KmsComment extends DataEntity<KmsComment> {
	
	private static final long serialVersionUID = 1L;
	private String categoryId;		// 栏目编号
	private String articleId;		// 知识编号
	private String content;		// 评论内容
	
	public KmsComment() {
		super();
	}

	public KmsComment(String id){
		super(id);
	}
	
	public KmsComment(String id, String articleId){
		super(id);
	}

	@Length(min=1, max=30, message="栏目编号长度必须介于 1 和 30 之间")
	@ExcelField(title="栏目编号", align=2, sort=1)
	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}
	
	@Length(min=1, max=30, message="知识编号长度必须介于 1 和 30 之间")
	@ExcelField(title="知识编号", align=2, sort=2)
	public String getArticleId() {
		return articleId;
	}

	public void setArticleId(String articleId) {
		this.articleId = articleId;
	}
	
	@Length(min=0, max=250, message="评论内容长度必须介于 0 和 250 之间")
	@ExcelField(title="评论内容", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}