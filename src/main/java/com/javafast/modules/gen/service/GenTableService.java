package com.javafast.modules.gen.service;

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
import com.javafast.common.service.BaseService;
import com.javafast.common.utils.FreeMarkers;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.gen.entity.GenConfig;
import com.javafast.modules.gen.entity.GenTable;
import com.javafast.modules.gen.entity.GenTableColumn;
import com.javafast.modules.gen.entity.GenTemplate;
import com.javafast.modules.gen.util.GenUtils;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.service.MenuService;
import com.javafast.modules.gen.dao.GenDataBaseDictDao;
import com.javafast.modules.gen.dao.GenTableColumnDao;
import com.javafast.modules.gen.dao.GenTableDao;

/**
 * 业务表Service
 */
@Service
@Transactional(readOnly = true)
public class GenTableService extends BaseService {

	@Autowired
	private GenTableDao genTableDao;
	
	@Autowired
	private GenTableColumnDao genTableColumnDao;
	
	@Autowired
	private GenDataBaseDictDao genDataBaseDictDao;
	
	@Autowired
	private MenuService menuService;
	
	public GenTable get(String id) {
		GenTable genTable = genTableDao.get(id);
		GenTableColumn genTableColumn = new GenTableColumn();
		genTableColumn.setGenTable(genTable);
		genTable.setColumnList(genTableColumnDao.findList(genTableColumn));
		return genTable;
	}
	
	public Page<GenTable> find(Page<GenTable> page, GenTable genTable) {
		genTable.setPage(page);
		page.setList(genTableDao.findList(genTable));
		return page;
	}

	public List<GenTable> findAll() {
		return genTableDao.findAllList(new GenTable());
	}
	
	/**
	 * 获取物理数据表列表
	 * @param genTable
	 * @return
	 */
	public List<GenTable> findTableListFormDb(GenTable genTable){
		return genDataBaseDictDao.findTableList(genTable);
	}
	
	/**
	 * 获取数据表字段
	 * @param genTable
	 * @return
	 */
	public List<GenTableColumn> findTableColumnList(GenTable genTable){
		return genDataBaseDictDao.findTableColumnList(genTable);
	}
	
	/**
	 * 验证表名是否可用，如果已存在，则返回false
	 * @param genTable
	 * @return
	 */
	public boolean checkTableName(String tableName){
		if (StringUtils.isBlank(tableName)){
			return true;
		}
		GenTable genTable = new GenTable();
		genTable.setName(tableName);
		List<GenTable> list = genTableDao.findList(genTable);
		return list.size() == 0;
	}
	
	/**
	 * 获取物理数据表列表
	 * @param genTable
	 * @return
	 */
	public GenTable getTableFormDb(GenTable genTable){
		// 如果有表名，则获取物理表
		if (StringUtils.isNotBlank(genTable.getName())){
			
			List<GenTable> list = genDataBaseDictDao.findTableList(genTable);
			if (list.size() > 0){
				
				// 如果是新增，初始化表属性
				if (StringUtils.isBlank(genTable.getId())){
					genTable = list.get(0);
					// 设置字段说明
					if (StringUtils.isBlank(genTable.getComments())){
						genTable.setComments(genTable.getName());
					}
					genTable.setClassName(StringUtils.toCapitalizeCamelCase(genTable.getName()));
				}
				
				// 添加新列
				List<GenTableColumn> columnList = genDataBaseDictDao.findTableColumnList(genTable);
				for (GenTableColumn column : columnList){
					boolean b = false;
					for (GenTableColumn e : genTable.getColumnList()){
						if (e.getName().equals(column.getName())){
							b = true;
						}
					}
					if (!b){
						genTable.getColumnList().add(column);
					}
				}
				
				// 删除已删除的列
				for (GenTableColumn e : genTable.getColumnList()){
					boolean b = false;
					for (GenTableColumn column : columnList){
						if (column.getName().equals(e.getName())){
							b = true;
						}
					}
					if (!b){
						e.setDelFlag(GenTableColumn.DEL_FLAG_DELETE);
					}
				}
				
				// 获取主键
				genTable.setPkList(genDataBaseDictDao.findTablePK(genTable));
				
				// 初始化列属性字段
				GenUtils.initColumnField(genTable);
				
			}
		}
		return genTable;
	}
	
	@Transactional(readOnly = false)
	public void save(GenTable genTable) {
		if (StringUtils.isBlank(genTable.getId())){
			genTable.preInsert();
			genTableDao.insert(genTable);
		}else{
			genTable.preUpdate();
			genTableDao.update(genTable);
		}
		// 保存列
		for (GenTableColumn column : genTable.getColumnList()){
			column.setGenTable(genTable);
			if (StringUtils.isBlank(column.getId())){
				column.preInsert();
				genTableColumnDao.insert(column);
			}else{
				column.preUpdate();
				genTableColumnDao.update(column);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(GenTable genTable) {
		genTableDao.delete(genTable);
		genTableColumnDao.deleteByGenTableId(genTable.getId());
	}
	
	/**
	 * 生成代码
	 * @param genTable
	 * @return
	 */
	@Transactional(readOnly = false)
	public String generateCode(GenTable genTable){

		StringBuilder result = new StringBuilder();
		
		// 查询主表及字段列
		genTable = genTableDao.get(genTable.getId());
		genTable.setColumnList(genTableColumnDao.findList(new GenTableColumn(genTable)));
		
		// 获取所有代码模板
		GenConfig config = GenUtils.getConfig();
		
		// 获取模板列表
		List<GenTemplate> templateList = GenUtils.getTemplateList(config, genTable.getCategory(), false);
		List<GenTemplate> childTableTemplateList = GenUtils.getTemplateList(config, genTable.getCategory(), true);
		
		// 如果有子表模板，则需要获取子表列表
		if (childTableTemplateList.size() > 0){
			GenTable parentTable = new GenTable();
			parentTable.setParentTable(genTable.getName());
			genTable.setChildList(genTableDao.findList(parentTable));
		}
		
		// 生成子表模板代码
		for (GenTable childTable : genTable.getChildList()){
			childTable.setParent(genTable);
			childTable.setColumnList(genTableColumnDao.findList(new GenTableColumn(new GenTable(childTable.getId()))));
			Map<String, Object> childTableModel = GenUtils.getDataModel(childTable);
			for (GenTemplate tpl : childTableTemplateList){
				result.append(GenUtils.generateToFile(tpl, childTableModel, childTable.getReplaceFile()));
			}
		}
		
		// 生成主表模板代码
		Map<String, Object> model = GenUtils.getDataModel(genTable);
		for (GenTemplate tpl : templateList){
			result.append(GenUtils.generateToFile(tpl, model, genTable.getReplaceFile()));
		}
		return result.toString();
	}
	
	/**
	 * 生成菜单
	 * @param genTable
	 * @param topMenu
	 */
	@Transactional(readOnly = false)
	public void createMenu(GenTable genTable, Menu topMenu) {
		String permissionPrefix = StringUtils.lowerCase(genTable.getModuleName())
				+ (StringUtils.isNotBlank(genTable.getSubModuleName())
						? ":" + StringUtils.lowerCase(genTable.getSubModuleName()) : "")
				+ ":" + StringUtils.uncapitalize(genTable.getClassName());
		String url = "/" + StringUtils.lowerCase(genTable.getModuleName())
				+ (StringUtils.isNotBlank(genTable.getSubModuleName())
						? "/" + StringUtils.lowerCase(genTable.getSubModuleName()) : "")
				+ "/" + StringUtils.uncapitalize(genTable.getClassName());

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
	 * @param genTable
	 * @param zip
	 */
	private void generateCodeRar(GenTable genTable,ZipOutputStream zip) {

		StringBuilder result = new StringBuilder();

		// 查询主表及字段列
		genTable = genTableDao.get(genTable.getId());
		genTable.setColumnList(genTableColumnDao.findList(new GenTableColumn(genTable)));

		// 获取所有代码模板
		GenConfig config = GenUtils.getConfig();

		// 获取模板列表
		List<GenTemplate> templateList = GenUtils.getTemplateList(config, genTable.getCategory(), false);
		List<GenTemplate> childTableTemplateList = GenUtils.getTemplateList(config, genTable.getCategory(), true);

		// 如果有子表模板，则需要获取子表列表
		if (childTableTemplateList.size() > 0) {
			GenTable parentTable = new GenTable();
			parentTable.setParentTable(genTable.getName());
			genTable.setChildList(genTableDao.findList(parentTable));
		}

		// 生成子表模板代码
		for (GenTable childTable : genTable.getChildList()) {
			childTable.setParent(genTable);
			childTable.setColumnList(genTableColumnDao.findList(new GenTableColumn(new GenTable(childTable.getId()))));
			
			Map<String, Object> childTableModel = GenUtils.getDataModel(childTable);
			for (GenTemplate tpl : childTableTemplateList) {
				generateToFile(tpl, childTableModel,zip);
			}
		}

		// 生成主表模板代码
		Map<String, Object> model = GenUtils.getDataModel(genTable);
		for (GenTemplate tpl : templateList) {
			generateToFile(tpl, model,zip);
		}
	}
	
	/**
	 * 生成代码文件
	 * @param tpl
	 * @param model
	 * @param zip
	 */
	private  void generateToFile(GenTemplate tpl, Map<String, Object> model,ZipOutputStream zip){
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
	 * @param genTable
	 * @return
	 */
	@Transactional(readOnly = false)
	public byte[] generatorCode(GenTable genTable) {
		
		// 生成代码
		if ("1".equals(genTable.getFlag())) {
			
			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
			ZipOutputStream zip = new ZipOutputStream(outputStream);
			generateCodeRar(genTable, zip);
			IOUtils.closeQuietly(zip);
			return outputStream.toByteArray();
			
		}
		return null;
	}
}
