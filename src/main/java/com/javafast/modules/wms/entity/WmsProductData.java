/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.entity;


import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 产品详情表Entity
 * @author javafast
 * @version 2017-10-24
 */
public class WmsProductData extends DataEntity<WmsProductData> {
	
	private static final long serialVersionUID = 1L;
	private String content;		// 产品详情
	
	public WmsProductData() {
		super();
	}

	public WmsProductData(String id){
		super(id);
	}

	@ExcelField(title="产品详情", align=2, sort=1)
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
}