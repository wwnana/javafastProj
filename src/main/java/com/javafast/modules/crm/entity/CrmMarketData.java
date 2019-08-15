package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 活动详情Entity
 * @author javafast
 * @version 2019-05-09
 */
public class CrmMarketData extends DataEntity<CrmMarketData> {
	
	private static final long serialVersionUID = 1L;
	private String title;		// 展示标题
	private String coverImage;		// 封面图
	private String content;		// 活动内容
	
	public CrmMarketData() {
		super();
	}

	public CrmMarketData(String id){
		super(id);
	}

	@Length(min=0, max=200, message="展示标题长度必须介于 0 和 200 之间")
	@ExcelField(title="展示标题", align=2, sort=1)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=255, message="封面图长度必须介于 0 和 255 之间")
	@ExcelField(title="封面图", align=2, sort=2)
	public String getCoverImage() {
		return coverImage;
	}

	public void setCoverImage(String coverImage) {
		this.coverImage = coverImage;
	}
	
	@Length(min=0, max=10000, message="活动内容长度必须介于 0 和 10000 之间")
	@ExcelField(title="活动内容", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}