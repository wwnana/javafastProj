package com.javafast.modules.hr.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 模板Entity
 * @author javafast
 * @version 2018-07-03
 */
public class HrTemplate extends DataEntity<HrTemplate> {
	
	private static final long serialVersionUID = 1L;
	private String type;		// 模板分类 0：面试邀请，1：OFFER
	private String name;		// 模板名称
	private String title;		// 标题
	private String content;		// 模板内容
	private String isDefault;		// 是否默认
	
	public HrTemplate() {
		super();
	}

	public HrTemplate(String id){
		super(id);
	}

	@Length(min=0, max=1, message="模板分类长度必须介于 0 和 1 之间")
	@ExcelField(title="模板分类", dictType="hr_template_type", align=2, sort=1)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=0, max=50, message="模板名称长度必须介于 0 和 50 之间")
	@ExcelField(title="模板名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="标题长度必须介于 0 和 50 之间")
	@ExcelField(title="标题", align=2, sort=3)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=10000, message="模板内容长度必须介于 0 和 10000 之间")
	@ExcelField(title="模板内容", align=2, sort=4)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=1, message="是否默认长度必须介于 0 和 1 之间")
	@ExcelField(title="是否默认", dictType="yes_no", align=2, sort=5)
	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
	
}