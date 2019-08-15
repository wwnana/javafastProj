package com.javafast.modules.crm.entity;

import com.javafast.modules.crm.entity.CrmCustomer;
import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 附件管理Entity
 * @author javafast
 * @version 2018-04-27
 */
public class CrmDocument extends DataEntity<CrmDocument> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomer customer;		// 所属客户
	private String name;		// 附件名称
	private String content;		// 附件
	
	public CrmDocument() {
		super();
	}

	public CrmDocument(String id){
		super(id);
	}

	@ExcelField(title="所属客户", align=2, sort=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=50, message="附件名称长度必须介于 0 和 50 之间")
	@ExcelField(title="附件名称", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=500, message="附件长度必须介于 0 和 500 之间")
	@ExcelField(title="附件", align=2, sort=3)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}