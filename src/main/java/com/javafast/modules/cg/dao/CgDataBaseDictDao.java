package com.javafast.modules.cg.dao;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.cg.entity.CgTable;
import com.javafast.modules.cg.entity.CgTableColumn;

/**
 * 业务表字段DAO接口
 */
@MyBatisDao
public interface CgDataBaseDictDao extends CrudDao<CgTableColumn> {

	/**
	 * 查询表列表
	 * @param cgTable
	 * @return
	 */
	List<CgTable> findTableList(CgTable cgTable);

	/**
	 * 获取数据表字段
	 * @param cgTable
	 * @return
	 */
	List<CgTableColumn> findTableColumnList(CgTable cgTable);
	
	/**
	 * 获取数据表主键
	 * @param cgTable
	 * @return
	 */
	List<String> findTablePK(CgTable cgTable);
	
}
