package com.javafast.modules.crm.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 客户标签Entity
 */
public class CrmTag extends DataEntity<CrmTag> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 标签名称
	
	public CrmTag() {
		super();
	}

	public CrmTag(String id){
		super(id);
	}

	@Length(min=0, max=30, message="标签名称长度必须介于 0 和 30 之间")
	@ExcelField(title="标签名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
}