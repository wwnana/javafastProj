package com.javafast.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 面板设置Entity
 * @author javafast
 * @version 2018-07-09
 */
public class SysPanel extends DataEntity<SysPanel> {
	
	private static final long serialVersionUID = 1L;
	private String panelId;		// 面板ID
	private String userId;		// 用户ID
	private String value;
	private String label;
	
	public SysPanel() {
		super();
	}

	public SysPanel(String id){
		super(id);
	}
	
	public SysPanel(String id, String userId){
		super(id);
		this.userId = userId;
	}

	@ExcelField(title="面板ID", dictType="panel_type", align=2, sort=1)
	public String getPanelId() {
		return panelId;
	}

	public void setPanelId(String panelId) {
		this.panelId = panelId;
	}
	
	@ExcelField(title="用户ID", align=2, sort=2)
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	
}