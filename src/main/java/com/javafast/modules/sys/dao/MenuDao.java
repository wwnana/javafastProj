package com.javafast.modules.sys.dao;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.Menu;

import java.util.List;

/**
 * 菜单DAO接口
 * @author JavaFast
 */
@MyBatisDao
public interface MenuDao extends TreeDao<Menu> {

	public List<Menu> findByParentIdsLike(Menu menu);

	public List<Menu> findByUserId(Menu menu);
	
	public int updateParentIds(Menu menu);
	
	public int updateSort(Menu menu);
	
	public List<Menu> getChildren(String id);
	
}

