package com.javafast.modules.gen.entity;

import org.hibernate.validator.constraints.Length;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 图表配置Entity
 */
public class GenReport extends DataEntity<GenReport> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String comments;		// 描述
	private String tableName;		// 表名
	private String reportType;		// 图表类型
	private String xAxis;		// X轴字段
	private String yAxis;		// Y轴字段
	private String querySql;		// 查询数据SQL
	private List<GenReportColumn> genReportColumnList = Lists.newArrayList();		// 子表列表
	
	private int sort; //排序
	private String status;		// 审核状态
	private String countType;   //发布模块
	
	public GenReport() {
		super();
	}

	public GenReport(String id){
		super(id);
	}

	@Length(min=1, max=50, message="名称长度必须介于 1 和 50 之间")
	@ExcelField(title="名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="描述长度必须介于 0 和 50 之间")
	@ExcelField(title="描述", align=2, sort=2)
	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}
	
	@Length(min=0, max=50, message="表名长度必须介于 0 和 50 之间")
	@ExcelField(title="表名", align=2, sort=3)
	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	
	@Length(min=1, max=30, message="图表类型长度必须介于 1 和 30 之间")
	@ExcelField(title="图表类型", dictType="report_type", align=2, sort=4)
	public String getReportType() {
		return reportType;
	}

	public void setReportType(String reportType) {
		this.reportType = reportType;
	}
	
	@Length(min=1, max=255, message="X轴字段长度必须介于 1 和 255 之间")
	@ExcelField(title="X轴字段", align=2, sort=5)
	public String getXAxis() {
		return xAxis;
	}

	public void setXAxis(String xAxis) {
		this.xAxis = xAxis;
	}
	
	@Length(min=1, max=255, message="Y轴字段长度必须介于 1 和 255 之间")
	@ExcelField(title="Y轴字段", align=2, sort=6)
	public String getYAxis() {
		return yAxis;
	}

	public void setYAxis(String yAxis) {
		this.yAxis = yAxis;
	}
	
	@Length(min=0, max=1000, message="查询数据SQL长度必须介于 0 和1000 之间")
	@ExcelField(title="查询数据SQL", align=2, sort=8)
	public String getQuerySql() {
		return querySql;
	}

	public void setQuerySql(String querySql) {
		this.querySql = querySql;
	}
	
	public List<GenReportColumn> getGenReportColumnList() {
		return genReportColumnList;
	}

	public void setGenReportColumnList(List<GenReportColumn> genReportColumnList) {
		this.genReportColumnList = genReportColumnList;
	}
	
	@Length(min=0, max=1, message="审核状态长度必须介于 0 和 1 之间")
	@ExcelField(title="审核状态", dictType="audit_status", align=2, sort=10)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}

	public String getCountType() {
		return countType;
	}

	public void setCountType(String countType) {
		this.countType = countType;
	}

	
}