/**
 * Copyright 2015-2020
 */
package com.javafast.modules.kms.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 知识Entity
 * @author javafast
 * @version 2017-08-03
 */
public class KmsArticle extends DataEntity<KmsArticle> {
	
	private static final long serialVersionUID = 1L;
	private KmsCategory kmsCategory;		// 栏目名称
	private String title;		// 知识标题
	private String link;		// 知识链接
	private String image;		// 知识图片
	private String keywords;		// 关键字
	private String description;		// 摘要
	private Integer sort;		// 排序
	private Integer hits;		// 点击数
	private String status;		// 状态
	private Date beginUpdateDate;		// 开始 更新时间
	private Date endUpdateDate;		// 结束 更新时间
	
	private KmsArticleData articleData;
	private List<KmsComment> commentList = Lists.newArrayList(); //评论列表
	
	public KmsArticle() {
		super();
	}

	public KmsArticle(String id){
		super(id);
	}

	@ExcelField(title="栏目名称", align=2, sort=1)
	public KmsCategory getKmsCategory() {
		return kmsCategory;
	}

	public void setKmsCategory(KmsCategory kmsCategory) {
		this.kmsCategory = kmsCategory;
	}
	
	@Length(min=1, max=50, message="知识标题长度必须介于 1 和 50 之间")
	@ExcelField(title="知识标题", align=2, sort=2)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=250, message="知识链接长度必须介于 0 和 250 之间")
	@ExcelField(title="知识链接", align=2, sort=3)
	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}
	
	@Length(min=0, max=250, message="知识图片长度必须介于 0 和 250 之间")
	@ExcelField(title="知识图片", align=2, sort=4)
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}
	
	@Length(min=0, max=50, message="关键字长度必须介于 0 和 50 之间")
	@ExcelField(title="关键字", align=2, sort=5)
	public String getKeywords() {
		return keywords;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	
	@Length(min=0, max=250, message="摘要长度必须介于 0 和 250 之间")
	@ExcelField(title="摘要", align=2, sort=6)
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	@ExcelField(title="排序", align=2, sort=7)
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	@ExcelField(title="点击数", align=2, sort=8)
	public Integer getHits() {
		return hits;
	}

	public void setHits(Integer hits) {
		this.hits = hits;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=9)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getBeginUpdateDate() {
		return beginUpdateDate;
	}

	public void setBeginUpdateDate(Date beginUpdateDate) {
		this.beginUpdateDate = beginUpdateDate;
	}
	
	public Date getEndUpdateDate() {
		return endUpdateDate;
	}

	public void setEndUpdateDate(Date endUpdateDate) {
		this.endUpdateDate = endUpdateDate;
	}

	public KmsArticleData getArticleData() {
		return articleData;
	}

	public void setArticleData(KmsArticleData articleData) {
		this.articleData = articleData;
	}

	public List<KmsComment> getCommentList() {
		return commentList;
	}

	public void setCommentList(List<KmsComment> commentList) {
		this.commentList = commentList;
	}
		
}