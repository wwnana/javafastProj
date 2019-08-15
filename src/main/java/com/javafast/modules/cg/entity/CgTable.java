/**
 * Copyright &copy; 2015-2020 <a href="http://www.javafast.cn/">javafast</a> All rights reserved.
 */
package com.javafast.modules.cg.entity;

import org.hibernate.validator.constraints.Length;
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
public class CgTable extends DataEntity<CgTable> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 表名称
	private String comments;		// 表描述
	private String className;		// 实体类名称
	private String parentTable;		// 关联父表
	private String parentTableFk;		// 关联父表外键
	private String cgCategory;		// 生成模板分类
	private String packageName;		// 生成包路径
	private String moduleName;		// 生成模块名
	private String subModuleName;		// 生成子模块名
	private String functionName;		// 生成功能名
	private String functionNameSimple;		// 生成功能名（简写）
	private String functionAuthor;		// 生成功能作者
	private String pageModel;		// 编辑页面模型:0:弹窗，1:跳转
	private String treeData;		// 树形列表数据
	private String isListCheckbox;		// 是否支持列表多选
	private String isTableSelect;		// 是否生成列表选择器
	private String isExcel;		// 是否支持导入导出
	private String isSynch;		// 同步数据库
	private List<CgTableColumn> columnList = Lists.newArrayList();		// 子表列表
	
	private String nameLike; 	// 按名称模糊查询	
	private List<String> pkList; // 当前表主键列表	
	private CgTable parent;	// 父表对象
	private List<CgTable> childList = Lists.newArrayList();	// 子表列表
	
	private String flag; 	// 0：保存方案； 1：保存方案并生成代码	
	private Boolean replaceFile;	// 是否替换现有文件    0：不替换；1：替换文件
	
	public CgTable() {
		super();
	}

	public CgTable(String id){
		super(id);
	}

	@Length(min=1, max=50, message="表名称长度必须介于 1 和 50 之间")
	@ExcelField(title="表名称", align=2, sort=1)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=50, message="表描述长度必须介于 1 和 50 之间")
	@ExcelField(title="表描述", align=2, sort=2)
	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}
	
	@Length(min=1, max=50, message="实体类名称长度必须介于 1 和 50 之间")
	@ExcelField(title="实体类名称", align=2, sort=3)
	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}
	
	@Length(min=0, max=50, message="关联父表长度必须介于 0 和 50 之间")
	@ExcelField(title="关联父表", align=2, sort=4)
	public String getParentTable() {
		return parentTable;
	}

	public void setParentTable(String parentTable) {
		this.parentTable = parentTable;
	}
	
	@Length(min=0, max=50, message="关联父表外键长度必须介于 0 和 50 之间")
	@ExcelField(title="关联父表外键", align=2, sort=5)
	public String getParentTableFk() {
		return parentTableFk;
	}

	public void setParentTableFk(String parentTableFk) {
		this.parentTableFk = parentTableFk;
	}
	
	@Length(min=0, max=50, message="生成模板分类长度必须介于 0 和 50 之间")
	@ExcelField(title="生成模板分类", align=2, sort=6)
	public String getCgCategory() {
		return cgCategory;
	}

	public void setCgCategory(String cgCategory) {
		this.cgCategory = cgCategory;
	}
	
	@Length(min=1, max=50, message="生成包路径长度必须介于 1 和 50 之间")
	@ExcelField(title="生成包路径", align=2, sort=7)
	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}
	
	@Length(min=1, max=50, message="生成模块名长度必须介于 1 和 50 之间")
	@ExcelField(title="生成模块名", align=2, sort=8)
	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}
	
	@Length(min=0, max=50, message="生成子模块名长度必须介于 0 和 50 之间")
	@ExcelField(title="生成子模块名", align=2, sort=9)
	public String getSubModuleName() {
		return subModuleName;
	}

	public void setSubModuleName(String subModuleName) {
		this.subModuleName = subModuleName;
	}
	
	@Length(min=1, max=50, message="生成功能名长度必须介于 1 和 50 之间")
	@ExcelField(title="生成功能名", align=2, sort=10)
	public String getFunctionName() {
		return functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}
	
	@Length(min=0, max=50, message="生成功能名（简写）长度必须介于 0 和 50 之间")
	@ExcelField(title="生成功能名（简写）", align=2, sort=11)
	public String getFunctionNameSimple() {
		return functionNameSimple;
	}

	public void setFunctionNameSimple(String functionNameSimple) {
		this.functionNameSimple = functionNameSimple;
	}
	
	@Length(min=1, max=50, message="生成功能作者长度必须介于 1 和 50 之间")
	@ExcelField(title="生成功能作者", align=2, sort=12)
	public String getFunctionAuthor() {
		return functionAuthor;
	}

	public void setFunctionAuthor(String functionAuthor) {
		this.functionAuthor = functionAuthor;
	}
	
	@Length(min=1, max=50, message="编辑页面模型:0:弹窗，1:跳转长度必须介于 1 和 50 之间")
	@ExcelField(title="编辑页面模型:0:弹窗，1:跳转", dictType="page_model", align=2, sort=13)
	public String getPageModel() {
		return pageModel;
	}

	public void setPageModel(String pageModel) {
		this.pageModel = pageModel;
	}
	
	@Length(min=0, max=50, message="树形列表数据长度必须介于 0 和 50 之间")
	@ExcelField(title="树形列表数据", align=2, sort=14)
	public String getTreeData() {
		return treeData;
	}

	public void setTreeData(String treeData) {
		this.treeData = treeData;
	}
	
	@Length(min=0, max=1, message="是否支持列表多选长度必须介于 0 和 1 之间")
	@ExcelField(title="是否支持列表多选", dictType="yes_no", align=2, sort=15)
	public String getIsListCheckbox() {
		return isListCheckbox;
	}

	public void setIsListCheckbox(String isListCheckbox) {
		this.isListCheckbox = isListCheckbox;
	}
	
	@Length(min=0, max=1, message="是否生成列表选择器长度必须介于 0 和 1 之间")
	@ExcelField(title="是否生成列表选择器", dictType="yes_no", align=2, sort=16)
	public String getIsTableSelect() {
		return isTableSelect;
	}

	public void setIsTableSelect(String isTableSelect) {
		this.isTableSelect = isTableSelect;
	}
	
	@Length(min=0, max=1, message="是否支持导入导出长度必须介于 0 和 1 之间")
	@ExcelField(title="是否支持导入导出", dictType="yes_no", align=2, sort=17)
	public String getIsExcel() {
		return isExcel;
	}

	public void setIsExcel(String isExcel) {
		this.isExcel = isExcel;
	}
	
	@Length(min=0, max=1, message="同步数据库长度必须介于 0 和 1 之间")
	@ExcelField(title="同步数据库", dictType="yes_no", align=2, sort=18)
	public String getIsSynch() {
		return isSynch;
	}

	public void setIsSynch(String isSynch) {
		this.isSynch = isSynch;
	}

	public List<CgTableColumn> getColumnList() {
		return columnList;
	}

	public void setColumnList(List<CgTableColumn> columnList) {
		this.columnList = columnList;
	}
	
	public String getNameLike() {
		return nameLike;
	}

	public void setNameLike(String nameLike) {
		this.nameLike = nameLike;
	}

	public List<String> getPkList() {
		return pkList;
	}

	public void setPkList(List<String> pkList) {
		this.pkList = pkList;
	}

	public CgTable getParent() {
		return parent;
	}

	public void setParent(CgTable parent) {
		this.parent = parent;
	}

	public List<CgTable> getChildList() {
		return childList;
	}

	public void setChildList(List<CgTable> childList) {
		this.childList = childList;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public Boolean getReplaceFile() {
		return replaceFile;
	}

	public void setReplaceFile(Boolean replaceFile) {
		this.replaceFile = replaceFile;
	}

	/**
	 * 获取列名和说明
	 * @return
	 */
	public String getNameAndComments() {
		return getName() + (comments == null ? "" : "  :  " + comments);
	}

	/**
	 * 获取导入依赖包字符串
	 * @return
	 */
	public List<String> getImportList(){
		List<String> importList = Lists.newArrayList(); // 引用列表
		for (CgTableColumn column : getColumnList()){
			if (column.getIsNotBaseField() || ("1".equals(column.getIsQuery()) && "between".equals(column.getQueryType())
							&& ("createDate".equals(column.getSimpleJavaField()) || "updateDate".equals(column.getSimpleJavaField())))){
				// 导入类型依赖包， 如果类型中包含“.”，则需要导入引用。
				if (StringUtils.indexOf(column.getJavaType(), ".") != -1 && !importList.contains(column.getJavaType())){
					importList.add(column.getJavaType());
				}
			}
			if (column.getIsNotBaseField()){
				// 导入JSR303、Json等依赖包
				for (String ann : column.getAnnotationList()){
					if (!importList.contains(StringUtils.substringBeforeLast(ann, "("))){
						importList.add(StringUtils.substringBeforeLast(ann, "("));
					}
				}
			}
		}
		// 如果有子表，则需要导入List相关引用
		if (getChildList() != null && getChildList().size() > 0){
			if (!importList.contains("java.util.List")){
				importList.add("java.util.List");
			}
			if (!importList.contains("com.google.common.collect.Lists")){
				importList.add("com.google.common.collect.Lists");
			}
		}
		return importList;
	}
	
	/**
	 * 是否存在父类
	 * @return
	 */
	public Boolean getParentExists(){
		return parent != null && StringUtils.isNotBlank(parentTable) && StringUtils.isNotBlank(parentTableFk);
	}

	/**
	 * 是否存在create_date列
	 * @return
	 */
	public Boolean getCreateDateExists(){
		for (CgTableColumn c : columnList){
			if ("create_date".equals(c.getName())){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 是否存在update_date列
	 * @return
	 */
	public Boolean getUpdateDateExists(){
		for (CgTableColumn c : columnList){
			if ("update_date".equals(c.getName())){
				return true;
			}
		}
		return false;
	}

	/**
	 * 是否存在del_flag列
	 * @return
	 */
	public Boolean getDelFlagExists(){
		for (CgTableColumn c : columnList){
			if ("del_flag".equals(c.getName())){
				return true;
			}
		}
		return false;
	}
}