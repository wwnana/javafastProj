/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.cg.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.FreeMarkers;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.cg.entity.CgConfig;
import com.javafast.modules.cg.entity.CgTable;
import com.javafast.modules.cg.dao.CgTableDao;
import com.javafast.modules.cg.entity.CgTableColumn;
import com.javafast.modules.cg.entity.CgTemplate;
import com.javafast.modules.cg.util.CodeGenerationUtils;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.service.MenuService;
import com.javafast.modules.cg.dao.CgDataBaseDictDao;
import com.javafast.modules.cg.dao.CgTableColumnDao;

/**
 * 表单设计Service
 * @author javafast
 * @version 2018-04-21
 */
@Service
@Transactional(readOnly = true)
public class CgTableService extends CrudService<CgTableDao, CgTable> {

	@Autowired
	private CgTableColumnDao cgTableColumnDao;
	
	@Autowired
	private CgDataBaseDictDao cgDataBaseDictDao;
	
	@Autowired
	private MenuService menuService;
	
	public CgTable get(String id) {
		CgTable cgTable = super.get(id);
		cgTable.setColumnList(cgTableColumnDao.findList(new CgTableColumn(cgTable)));
		return cgTable;
	}
	
	public List<CgTable> findList(CgTable cgTable) {
		return super.findList(cgTable);
	}
	
	public Page<CgTable> findPage(Page<CgTable> page, CgTable cgTable) {
		return super.findPage(page, cgTable);
	}
	
	@Transactional(readOnly = false)
	public void save(CgTable cgTable) {
		super.save(cgTable);
		for (CgTableColumn cgTableColumn : cgTable.getColumnList()){
			if (cgTableColumn.getId() == null){
				continue;
			}
			if (CgTableColumn.DEL_FLAG_NORMAL.equals(cgTableColumn.getDelFlag())){
				if (StringUtils.isBlank(cgTableColumn.getId())){
					cgTableColumn.setCgTable(cgTable);
					cgTableColumn.preInsert();
					cgTableColumnDao.insert(cgTableColumn);
				}else{
					cgTableColumn.preUpdate();
					cgTableColumnDao.update(cgTableColumn);
				}
			}else{
				cgTableColumnDao.delete(cgTableColumn);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(CgTable cgTable) {
		super.delete(cgTable);
		cgTableColumnDao.delete(new CgTableColumn(cgTable));
	}
	
	/**
	 * 获取物理数据表列表
	 * @param cgTable
	 * @return
	 */
	public List<CgTable> findTableListFormDb(CgTable cgTable){
		return cgDataBaseDictDao.findTableList(cgTable);
	}
	
	/**
	 * 获取数据表字段
	 * @param cgTable
	 * @return
	 */
	public List<CgTableColumn> findTableColumnList(CgTable cgTable){
		return cgDataBaseDictDao.findTableColumnList(cgTable);
	}
	
	/**
	 * 验证表名是否可用，如果已存在，则返回false
	 * @param cgTable
	 * @return
	 */
	public boolean checkTableName(String tableName){
		if (StringUtils.isBlank(tableName)){
			return true;
		}
		CgTable cgTable = new CgTable();
		cgTable.setName(tableName);
		List<CgTable> list = dao.findList(cgTable);
		return list.size() == 0;
	}
	
	/**
	 * 获取物理数据表列表
	 * @param cgTable
	 * @return
	 */
	public CgTable getTableFormDb(CgTable cgTable){
		// 如果有表名，则获取物理表
		if (StringUtils.isNotBlank(cgTable.getName())){
			
			List<CgTable> list = cgDataBaseDictDao.findTableList(cgTable);
			if (list.size() > 0){
				
				// 如果是新增，初始化表属性
				if (StringUtils.isBlank(cgTable.getId())){
					cgTable = list.get(0);
					// 设置字段说明
					if (StringUtils.isBlank(cgTable.getComments())){
						cgTable.setComments(cgTable.getName());
					}
					cgTable.setClassName(StringUtils.toCapitalizeCamelCase(cgTable.getName()));
				}
				
				// 添加新列
				List<CgTableColumn> columnList = cgDataBaseDictDao.findTableColumnList(cgTable);
				for (CgTableColumn column : columnList){
					boolean b = false;
					for (CgTableColumn e : cgTable.getColumnList()){
						if (e.getName().equals(column.getName())){
							b = true;
						}
					}
					if (!b){
						cgTable.getColumnList().add(column);
					}
				}
				
				// 删除已删除的列
				for (CgTableColumn e : cgTable.getColumnList()){
					boolean b = false;
					for (CgTableColumn column : columnList){
						if (column.getName().equals(e.getName())){
							b = true;
						}
					}
					if (!b){
						e.setDelFlag(CgTableColumn.DEL_FLAG_DELETE);
					}
				}
				
				// 获取主键
				cgTable.setPkList(cgDataBaseDictDao.findTablePK(cgTable));
				
				// 初始化列属性字段
				CodeGenerationUtils.initColumnField(cgTable);
				
			}
		}
		return cgTable;
	}
	
	/**
	 * 生成代码
	 * @param cgTable
	 * @return
	 */
	public String generateCode(CgTable cgTable){

		StringBuilder result = new StringBuilder();
		
		// 查询主表及字段列
		cgTable = this.get(cgTable.getId());
		
		// 获取所有代码模板
		CgConfig config = CodeGenerationUtils.getConfig();
		
		// 获取模板列表
		List<CgTemplate> templateList = CodeGenerationUtils.getTemplateList(config, cgTable.getCgCategory(), false);
		List<CgTemplate> childTableTemplateList = CodeGenerationUtils.getTemplateList(config, cgTable.getCgCategory(), true);
		
		// 如果有子表模板，则需要获取子表列表
		if (childTableTemplateList.size() > 0){
			CgTable parentTable = new CgTable();
			parentTable.setParentTable(cgTable.getName());
			cgTable.setChildList(dao.findList(parentTable));
		}
		
		// 生成子表模板代码
		for (CgTable childTable : cgTable.getChildList()){
			childTable.setParent(cgTable);
			childTable.setColumnList(cgTableColumnDao.findList(new CgTableColumn(new CgTable(childTable.getId()))));

			Map<String, Object> childTableModel = CodeGenerationUtils.getDataModel(childTable);
			for (CgTemplate tpl : childTableTemplateList){
				result.append(CodeGenerationUtils.generateToFile(tpl, childTableModel, cgTable.getReplaceFile()));
			}
		}
		
		// 生成主表模板代码
		Map<String, Object> model = CodeGenerationUtils.getDataModel(cgTable);
		for (CgTemplate tpl : templateList){
			result.append(CodeGenerationUtils.generateToFile(tpl, model, cgTable.getReplaceFile()));
		}
		return result.toString();
	}
	
	/**
	 * 生成菜单
	 * @param cgTable
	 * @param topMenu
	 */
	@Transactional(readOnly = false)
	public void createMenu(CgTable cgTable, Menu topMenu) {
		String permissionPrefix = StringUtils.lowerCase(cgTable.getModuleName())
				+ (StringUtils.isNotBlank(cgTable.getSubModuleName())
						? ":" + StringUtils.lowerCase(cgTable.getSubModuleName()) : "")
				+ ":" + StringUtils.uncapitalize(cgTable.getClassName());
		String url = "/" + StringUtils.lowerCase(cgTable.getModuleName())
				+ (StringUtils.isNotBlank(cgTable.getSubModuleName())
						? "/" + StringUtils.lowerCase(cgTable.getSubModuleName()) : "")
				+ "/" + StringUtils.uncapitalize(cgTable.getClassName());

		topMenu.setName(topMenu.getName());
		topMenu.setHref(url);
		topMenu.setIsShow("1");
		topMenu.setPermission(permissionPrefix + ":list");
		this.menuService.save(topMenu);

		Menu addMenu = new Menu();
		addMenu.setName("新增");

		addMenu.setIsShow("0");
		addMenu.setSort(Integer.valueOf(30));
		addMenu.setPermission(permissionPrefix + ":add");
		addMenu.setParent(topMenu);
		this.menuService.save(addMenu);
		Menu delMenu;
		(delMenu = new Menu()).setName("删除");
		delMenu.setIsShow("0");
		delMenu.setSort(Integer.valueOf(60));
		delMenu.setPermission(permissionPrefix + ":del");
		delMenu.setParent(topMenu);
		this.menuService.save(delMenu);
		Menu editMenu = new Menu();
		editMenu.setName("编辑");
		editMenu.setIsShow("0");
		editMenu.setSort(Integer.valueOf(90));
		editMenu.setPermission(permissionPrefix + ":edit");
		editMenu.setParent(topMenu);
		this.menuService.save(editMenu);
		Menu viewMenu;
		(viewMenu = new Menu()).setName("查看");
		viewMenu.setIsShow("0");
		viewMenu.setSort(Integer.valueOf(120));
		viewMenu.setPermission(permissionPrefix + ":view");
		viewMenu.setParent(topMenu);
		this.menuService.save(viewMenu);
		Menu importMenu;
		(importMenu = new Menu()).setName("导入");
		importMenu.setIsShow("0");
		importMenu.setSort(Integer.valueOf(150));
		importMenu.setPermission(permissionPrefix + ":import");
		importMenu.setParent(topMenu);
		this.menuService.save(importMenu);
		Menu exportMenu;
		(exportMenu = new Menu()).setName("导出");
		exportMenu.setIsShow("0");
		exportMenu.setSort(Integer.valueOf(180));
		exportMenu.setPermission(permissionPrefix + ":export");
		exportMenu.setParent(topMenu);
		this.menuService.save(exportMenu);
	}
	
	/**
	 * 生成代码并打包RAR
	 * @param cgTable
	 * @param zip
	 */
	private void generateCodeRar(CgTable cgTable,ZipOutputStream zip) {

		StringBuilder result = new StringBuilder();

		// 查询主表及字段列
		cgTable = this.get(cgTable.getId());

		// 获取所有代码模板
		CgConfig config = CodeGenerationUtils.getConfig();

		// 获取模板列表
		List<CgTemplate> templateList = CodeGenerationUtils.getTemplateList(config, cgTable.getCgCategory(), false);
		List<CgTemplate> childTableTemplateList = CodeGenerationUtils.getTemplateList(config, cgTable.getCgCategory(), true);

		// 如果有子表模板，则需要获取子表列表
		if (childTableTemplateList.size() > 0) {
			CgTable parentTable = new CgTable();
			parentTable.setParentTable(cgTable.getName());
			cgTable.setChildList(dao.findList(parentTable));
		}

		// 生成子表模板代码
		for (CgTable childTable : cgTable.getChildList()) {
			childTable.setParent(cgTable);
			childTable.setColumnList(cgTableColumnDao.findList(new CgTableColumn(new CgTable(childTable.getId()))));
			
			Map<String, Object> childTableModel = CodeGenerationUtils.getDataModel(childTable);
			for (CgTemplate tpl : childTableTemplateList) {
				generateToFile(tpl, childTableModel,zip);
			}
		}

		// 生成主表模板代码
		Map<String, Object> model = CodeGenerationUtils.getDataModel(cgTable);
		for (CgTemplate tpl : templateList) {
			generateToFile(tpl, model,zip);
		}
	}
	
	/**
	 * 生成代码文件
	 * @param tpl
	 * @param model
	 * @param zip
	 */
	private  void generateToFile(CgTemplate tpl, Map<String, Object> model,ZipOutputStream zip){
		// 获取生成文件
		String packagePath = "";
		
		String fileName = packagePath
				+ StringUtils.replaceEach(FreeMarkers.renderString(tpl.getFilePath() + "/", model), 
						new String[]{"//", "/", "."}, new String[]{File.separator, File.separator, File.separator})
				+ FreeMarkers.renderString(tpl.getFileName(), model);
		logger.debug(" fileName === " + fileName);

		// 获取生成文件内容
		logger.debug(" content === " + tpl.getContent());
		String content = FreeMarkers.renderString(StringUtils.trimToEmpty(tpl.getContent()), model);
		//添加到zip
		try {
			zip.putNextEntry(new ZipEntry(fileName));  
			IOUtils.write(content, zip, "UTF-8");
			zip.closeEntry();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		logger.debug(" content === \r\n" + content);
	
	}
	
	/**
	 * 生成代码并压缩打包
	 * @param cgTable
	 * @return
	 */
	@Transactional(readOnly = false)
	public byte[] generatorCode(CgTable cgTable) {
		
		// 生成代码
		if ("1".equals(cgTable.getFlag())) {
			
			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
			ZipOutputStream zip = new ZipOutputStream(outputStream);
			generateCodeRar(cgTable, zip);
			IOUtils.closeQuietly(zip);
			return outputStream.toByteArray();
			
		}
		return null;
	}
}