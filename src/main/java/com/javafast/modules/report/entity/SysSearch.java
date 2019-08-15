package com.javafast.modules.report.entity;

import com.javafast.common.persistence.DataEntity;

/**
 * 搜索类
 * @author syh
 *
 */
public class SysSearch extends DataEntity<SysSearch> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4095091823852501992L;
	
	private String name;//名称
	private String type;//对象类型, 10：项目，11：任务，20：客户，21：联系人，22：商机，23：报价，24：合同订单， 30：产品，39：供应商
	
	private String keyWords;//关键字
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getKeyWords() {
		return keyWords;
	}
	public void setKeyWords(String keyWords) {
		this.keyWords = keyWords;
	}
	
	
	
	
}
