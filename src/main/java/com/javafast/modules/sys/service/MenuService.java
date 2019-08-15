package com.javafast.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.dao.MenuDao;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.utils.LogUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 菜单Service
 * @author JavaFast
 */
@Service
@Transactional(readOnly = true)
public class MenuService extends TreeService<MenuDao, Menu> {

	public List<Menu> findList(){
		return UserUtils.getMenuList();
	}
	
	public List<Menu> findAllMenu(){
		return UserUtils.getMenuList();
	}
	
	public List<Menu> getChildrenMenu(String id) {
		return dao.getChildren(id);
	}

	/**
	 * 保存或更新菜单
	 */
	@Transactional(readOnly = false)
	public void save(Menu menu) {
			
		super.save(menu);
		//清除菜单相关缓存
		removeMenuCache();
	}
	
	@Transactional(readOnly = false)
	public void delete(Menu menu) {
		dao.delete(menu);
		//清除菜单相关缓存
		removeMenuCache();
	}
	
	/**
	 * 更新菜单排序
	 * @param menu
	 */
	@Transactional(readOnly = false)
	public void updateMenuSort(Menu menu) {
		dao.updateSort(menu);
		
		//清除菜单相关缓存
		removeMenuCache();
	}
	
	/**
	 * 清除菜单相关缓存
	 */
	public void removeMenuCache(){
		// 清除用户菜单缓存
		UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
//		// 清除权限缓存
//=		systemRealm.clearAllCachedAuthorizationInfo();
		// 清除日志相关缓存
		CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
	}
}
