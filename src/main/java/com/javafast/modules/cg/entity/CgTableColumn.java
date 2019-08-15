/**
 * Copyright &copy; 2015-2020 <a href="http://www.javafast.cn/">javafast</a> All rights reserved.
 */
package com.javafast.modules.cg.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 表单设计Entity
 * @author javafast
 * @version 2018-04-21
 */
public class CgTableColumn extends DataEntity<CgTableColumn> {
	
	private static final long serialVersionUID = 1L;
	private CgTable cgTable;		// 归属表编号 父类
	private String name;		// 列名
	private String comments;		// 说明
	private String jdbcType;		// 字段类型
	private String javaType;		// JAVA类型
	private String javaField;		// JAVA字段名
	private String isPk;		// 主键
	private String isInsert;		// 插入
	private String isEdit;		// 更新
	private String isList;		// 列表
	private String isSort;		// 排序
	private String isQuery;		// 查询
	private String queryType;		// 查询方式
	private String showType;		// 表单控件
	private String dictType;		// 字典类型
	private String isNotNull;		// 非空
	private String validateType;		// 校验类型
	private String settings;		// 其它设置（扩展字段JSON）
	private BigDecimal sort;		// 排序（升序）
	
	public CgTableColumn() {
		super();
	}

	public CgTableColumn(String id){
		super(id);
	}

	public CgTableColumn(CgTable cgTable){
		this.cgTable = cgTable;
	}

	@Length(min=0, max=64, message="归属表编号长度必须介于 0 和 64 之间")
	public CgTable getCgTable() {
		return cgTable;
	}

	public void setCgTable(CgTable cgTable) {
		this.cgTable = cgTable;
	}
	
	@Length(min=1, max=50, message="列名长度必须介于 1 和 50 之间")
	@ExcelField(title="列名", align=2, sort=2)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=50, message="说明长度必须介于 1 和 50 之间")
	@ExcelField(title="说明", align=2, sort=3)
	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}
	
	@Length(min=1, max=100, message="字段类型长度必须介于 1 和 100 之间")
	@ExcelField(title="字段类型", dictType="", align=2, sort=4)
	public String getJdbcType() {
		return jdbcType;
	}

	public void setJdbcType(String jdbcType) {
		this.jdbcType = jdbcType;
	}
	
	@Length(min=1, max=100, message="JAVA类型长度必须介于 1 和 100 之间")
	@ExcelField(title="JAVA类型", dictType="", align=2, sort=5)
	public String getJavaType() {
		return javaType;
	}

	public void setJavaType(String javaType) {
		this.javaType = javaType;
	}
	
	@Length(min=1, max=50, message="JAVA字段名长度必须介于 1 和 50 之间")
	@ExcelField(title="JAVA字段名", align=2, sort=6)
	public String getJavaField() {
		return javaField;
	}

	public void setJavaField(String javaField) {
		this.javaField = javaField;
	}
	
	@Length(min=0, max=1, message="主键长度必须介于 0 和 1 之间")
	@ExcelField(title="主键", dictType="", align=2, sort=7)
	public String getIsPk() {
		return isPk;
	}

	public void setIsPk(String isPk) {
		this.isPk = isPk;
	}
	
	@Length(min=0, max=1, message="插入长度必须介于 0 和 1 之间")
	@ExcelField(title="插入", dictType="", align=2, sort=8)
	public String getIsInsert() {
		return isInsert;
	}

	public void setIsInsert(String isInsert) {
		this.isInsert = isInsert;
	}
	
	@Length(min=0, max=1, message="更新长度必须介于 0 和 1 之间")
	@ExcelField(title="更新", dictType="", align=2, sort=9)
	public String getIsEdit() {
		return isEdit;
	}

	public void setIsEdit(String isEdit) {
		this.isEdit = isEdit;
	}
	
	@Length(min=0, max=1, message="列表长度必须介于 0 和 1 之间")
	@ExcelField(title="列表", dictType="", align=2, sort=10)
	public String getIsList() {
		return isList;
	}

	public void setIsList(String isList) {
		this.isList = isList;
	}
	
	@Length(min=0, max=1, message="排序长度必须介于 0 和 1 之间")
	@ExcelField(title="排序", dictType="", align=2, sort=11)
	public String getIsSort() {
		return isSort;
	}

	public void setIsSort(String isSort) {
		this.isSort = isSort;
	}
	
	@Length(min=0, max=1, message="查询长度必须介于 0 和 1 之间")
	@ExcelField(title="查询", dictType="", align=2, sort=12)
	public String getIsQuery() {
		return isQuery;
	}

	public void setIsQuery(String isQuery) {
		this.isQuery = isQuery;
	}
	
	@Length(min=1, max=50, message="查询方式长度必须介于 1 和 50 之间")
	@ExcelField(title="查询方式", dictType="", align=2, sort=13)
	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
	
	@Length(min=1, max=50, message="表单控件长度必须介于 1 和 50 之间")
	@ExcelField(title="表单控件", dictType="", align=2, sort=14)
	public String getShowType() {
		return showType;
	}

	public void setShowType(String showType) {
		this.showType = showType;
	}
	
	@Length(min=0, max=50, message="字典类型长度必须介于 0 和 50 之间")
	@ExcelField(title="字典类型", align=2, sort=15)
	public String getDictType() {
		return dictType;
	}

	public void setDictType(String dictType) {
		this.dictType = dictType;
	}
	
	@Length(min=0, max=1, message="非空长度必须介于 0 和 1 之间")
	@ExcelField(title="非空", dictType="", align=2, sort=16)
	public String getIsNotNull() {
		return isNotNull;
	}

	public void setIsNotNull(String isNotNull) {
		this.isNotNull = isNotNull;
	}
	
	@Length(min=0, max=50, message="校验类型长度必须介于 0 和 50 之间")
	@ExcelField(title="校验类型", dictType="", align=2, sort=17)
	public String getValidateType() {
		return validateType;
	}

	public void setValidateType(String validateType) {
		this.validateType = validateType;
	}
	
	@Length(min=0, max=2000, message="其它设置（扩展字段JSON）长度必须介于 0 和 2000 之间")
	@ExcelField(title="其它设置（扩展字段JSON）", align=2, sort=18)
	public String getSettings() {
		return settings;
	}

	public void setSettings(String settings) {
		this.settings = settings;
	}
	
	@ExcelField(title="排序（升序）", align=2, sort=19)
	public BigDecimal getSort() {
		return sort;
	}

	public void setSort(BigDecimal sort) {
		this.sort = sort;
	}
	
	/**
	 * 获取列名和说明
	 * @return
	 */
	public String getNameAndComments() {
		return getName() + (comments == null ? "" : "  :  " + comments);
	}
	
	/**
	 * 获取字符串长度
	 * @return
	 */
	public String getDataLength(){
		String[] ss = StringUtils.split(StringUtils.substringBetween(getJdbcType(), "(", ")"), ",");
		if (ss != null && ss.length == 1){// && "String".equals(getJavaType())){
			return ss[0];
		}
		return "0";
	}

	/**
	 * 获取简写Java类型
	 * @return
	 */
	public String getSimpleJavaType(){
		if ("This".equals(getJavaType())){
			return StringUtils.capitalize(cgTable.getClassName());
		}
		return StringUtils.indexOf(getJavaType(), ".") != -1 
				? StringUtils.substringAfterLast(getJavaType(), ".")
						: getJavaType();
	}
	
	/**
	 * 获取简写Java字段
	 * @return
	 */
	public String getSimpleJavaField(){
		return StringUtils.substringBefore(getJavaField(), ".");
	}
	
	/**
	 * 获取Java字段，如果是对象，则获取对象.附加属性1
	 * @return
	 */
	public String getJavaFieldId(){
		return StringUtils.substringBefore(getJavaField(), "|");
	}
	
	/**
	 * 获取Java字段，如果是对象，则获取对象.附加属性2
	 * @return
	 */
	public String getJavaFieldName(){
		String[][] ss = getJavaFieldAttrs();
		return ss.length>0 ? getSimpleJavaField()+"."+ss[0][0] : "";
	}
	
	/**
	 * 获取Java字段，所有属性名
	 * @return
	 */
	public String[][] getJavaFieldAttrs(){
		String[] ss = StringUtils.split(StringUtils.substringAfter(getJavaField(), "|"), "|");
		String[][] sss = new String[ss.length][2];
		if (ss!=null){
			for (int i=0; i<ss.length; i++){
				sss[i][0] = ss[i];
				sss[i][1] = StringUtils.toUnderScoreCase(ss[i]);
			}
		}
		return sss;
	}
	
	/**
	 * 获取列注解列表
	 * @return
	 */
	public List<String> getAnnotationList(){
		List<String> list = Lists.newArrayList();
		// 导入Jackson注解
		if ("This".equals(getJavaType())){
			list.add("com.fasterxml.jackson.annotation.JsonBackReference");
		}
		if ("java.util.Date".equals(getJavaType())){
			list.add("com.fasterxml.jackson.annotation.JsonFormat(pattern = \"yyyy-MM-dd HH:mm:ss\")");
		}
		// 导入JSR303验证依赖包
		if ("1".equals(getIsNotNull()) && !"String".equals(getJavaType())){
			list.add("javax.validation.constraints.NotNull(message=\""+getComments()+"不能为空\")");
		}
		else if ("1".equals(getIsNotNull()) && "String".equals(getJavaType()) && !"0".equals(getDataLength())){
			list.add("org.hibernate.validator.constraints.Length(min=1, max="+getDataLength()
					+", message=\""+getComments()+"长度必须介于 1 和 "+getDataLength()+" 之间\")");
		}
		else if ("String".equals(getJavaType()) && !"0".equals(getDataLength())){
			list.add("org.hibernate.validator.constraints.Length(min=0, max="+getDataLength()
					+", message=\""+getComments()+"长度必须介于 0 和 "+getDataLength()+" 之间\")");
		}
		return list;
	}
	
	/**
	 * 获取简写列注解列表
	 * @return
	 */
	public List<String> getSimpleAnnotationList(){
		List<String> list = Lists.newArrayList();
		for (String ann : getAnnotationList()){
			list.add(StringUtils.substringAfterLast(ann, "."));
		}
		return list;
	}
	
	/**
	 * 是否是基类字段
	 * @return
	 */
	public Boolean getIsNotBaseField(){
		return !StringUtils.equals(getSimpleJavaField(), "id")
				&& !StringUtils.equals(getSimpleJavaField(), "remarks")
				&& !StringUtils.equals(getSimpleJavaField(), "createBy")
				&& !StringUtils.equals(getSimpleJavaField(), "createDate")
				&& !StringUtils.equals(getSimpleJavaField(), "updateBy")
				&& !StringUtils.equals(getSimpleJavaField(), "updateDate")
				&& !StringUtils.equals(getSimpleJavaField(), "delFlag")
				&& !StringUtils.equals(getSimpleJavaField(), "accountId");
	}
	
}