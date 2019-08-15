package com.javafast.modules.sys.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.dao.RoleDao;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 角色Service
 * @author JavaFast
 */
@Service
@Transactional(readOnly = true)
public class RoleService extends CrudService<RoleDao, Role> {

	public Role get(String id) {
		return super.get(id);
	}
	
	public List<Role> findList(Role role) {
		dataScopeFilter(role);//加入权限过滤
		return super.findList(role);
	}
	
	public List<Role> findAllRole(){
		return UserUtils.getRoleList();
	}
	
	public Page<Role> findPage(Page<Role> page, Role role) {
		dataScopeFilter(role);//加入权限过滤
		return super.findPage(page, role);
	}
	
	@Transactional(readOnly = false)
	public void save(Role role) {
		
		if(!"0".equals(UserUtils.getUser().getAccountId())){
			role.setSysData("0");
			role.setRoleType("user");
		}
		
		if (StringUtils.isBlank(role.getId())){
			role.preInsert();
			dao.insert(role);
		}else{
			role.preUpdate();
			dao.update(role);
		}
		// 更新角色与菜单关联
		dao.deleteRoleMenu(role);
		if (role.getMenuList().size() > 0){
			dao.insertRoleMenu(role);
		}
		
		// 清除用户角色缓存
		removeRoleCache();
	}
	
	@Transactional(readOnly = false)
	public void delete(Role role) {
		dao.delete(role);
		// 清除用户角色缓存
		removeRoleCache();
	}
	
	public void removeRoleCache(){
		// 清除用户角色缓存
		UserUtils.removeCache(UserUtils.CACHE_ROLE_LIST);
//		// 清除权限缓存
//		systemRealm.clearAllCachedAuthorizationInfo();
	}
	
	/**
	 * 根据名称查询角色
	 * @param name
	 * @return
	 */
	public Role getRoleByName(String name) {
		Role r = new Role();
		r.setName(name);
		dataScopeFilter(r);//加入企业权限隔离过滤
		return dao.getByName(r);
	}
	
	/**
	 * 根据英文名称查询角色
	 * @param enname
	 * @return
	 */
	public Role getRoleByEnname(String enname) {
		Role r = new Role();
		r.setEnname(enname);
		dataScopeFilter(r);//加入企业权限隔离过滤
		return dao.getByEnname(r);
	}
}
