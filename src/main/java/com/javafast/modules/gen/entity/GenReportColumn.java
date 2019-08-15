package com.javafast.modules.gen.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 图表配置Entity
 */
public class GenReportColumn extends DataEntity<GenReportColumn> {
	
	private static final long serialVersionUID = 1L;
	private GenReport genReport;		// 归属图表配置 父类
	private String javaField;		// 字段名
	private String name;		// 字段描述
	private String javaType;		// 字段类型
	private String isList;		// 是否显示
	private String isQuery;		// 是否查询
	private String queryType;		// 查询方式
	private String showType;		// 显示类型
	private String dictType;		// 字典类型
	private BigDecimal sort;		// 排序（升序）
	
	public GenReportColumn() {
		super();
	}

	public GenReportColumn(String id){
		super(id);
	}

	public GenReportColumn(GenReport genReport){
		this.genReport = genReport;
	}

	public GenReport getGenReport() {
		return genReport;
	}

	public void setGenReport(GenReport genReport) {
		this.genReport = genReport;
	}
	
	@Length(min=0, max=200, message="字段名长度必须介于 0 和 200 之间")
	@ExcelField(title="字段名", align=2, sort=2)
	public String getJavaField() {
		return javaField;
	}

	public void setJavaField(String javaField) {
		this.javaField = javaField;
	}
	
	@Length(min=0, max=50, message="字段描述长度必须介于 0 和 50 之间")
	@ExcelField(title="字段描述", align=2, sort=3)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=500, message="字段类型长度必须介于 0 和 500 之间")
	@ExcelField(title="字段类型", dictType="java_type", align=2, sort=4)
	public String getJavaType() {
		return javaType;
	}

	public void setJavaType(String javaType) {
		this.javaType = javaType;
	}
	
	@Length(min=0, max=1, message="是否显示长度必须介于 0 和 1 之间")
	@ExcelField(title="是否显示", dictType="yes_no", align=2, sort=5)
	public String getIsList() {
		return isList;
	}

	public void setIsList(String isList) {
		this.isList = isList;
	}
	
	@Length(min=0, max=1, message="是否查询长度必须介于 0 和 1 之间")
	@ExcelField(title="是否查询", dictType="yes_no", align=2, sort=6)
	public String getIsQuery() {
		return isQuery;
	}

	public void setIsQuery(String isQuery) {
		this.isQuery = isQuery;
	}
	
	@Length(min=0, max=200, message="查询方式长度必须介于 0 和 200 之间")
	@ExcelField(title="查询方式", dictType="query_type", align=2, sort=7)
	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
	
	@Length(min=0, max=200, message="显示类型长度必须介于 0 和 200 之间")
	@ExcelField(title="显示类型", dictType="show_type", align=2, sort=8)
	public String getShowType() {
		return showType;
	}

	public void setShowType(String showType) {
		this.showType = showType;
	}
	
	@Length(min=0, max=200, message="字典类型长度必须介于 0 和 200 之间")
	@ExcelField(title="字典类型", align=2, sort=9)
	public String getDictType() {
		return dictType;
	}

	public void setDictType(String dictType) {
		this.dictType = dictType;
	}
	
	@ExcelField(title="排序（升序）", align=2, sort=10)
	public BigDecimal getSort() {
		return sort;
	}

	public void setSort(BigDecimal sort) {
		this.sort = sort;
	}
	
}