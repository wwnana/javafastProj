package com.javafast.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 便签Entity
 * @author javafast
 * @version 2017-07-16
 */
public class OaNote extends DataEntity<OaNote> {
	
	private static final long serialVersionUID = 1L;
	private String notes;		// 内容
	
	public OaNote() {
		super();
	}

	public OaNote(String id){
		super(id);
	}

	@Length(min=1, max=50, message="内容长度必须介于 1 和 50 之间")
	@ExcelField(title="内容", align=2, sort=1)
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
}