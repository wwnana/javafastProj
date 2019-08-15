package com.javafast.modules.sys.utils;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.UnavailableSecurityManagerException;
import org.apache.shiro.session.InvalidSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;

import com.javafast.common.service.BaseService;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.modules.sys.dao.AreaDao;
import com.javafast.modules.sys.dao.MenuDao;
import com.javafast.modules.sys.dao.OfficeDao;
import com.javafast.modules.sys.dao.RoleDao;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Area;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.security.SystemAuthorizingRealm.Principal;

/**
 * 用户工具类
 */
public class UserUtils {

	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
	private static RoleDao roleDao = SpringContextHolder.getBean(RoleDao.class);
	private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);
	private static AreaDao areaDao = SpringContextHolder.getBean(AreaDao.class);
	private static OfficeDao officeDao = SpringContextHolder.getBean(OfficeDao.class);
	private static SysAccountDao sysAccountDao = SpringContextHolder.getBean(SysAccountDao.class);

	public static final String USER_CACHE = "userCache";
	public static final String USER_CACHE_ID_ = "id_";
	public static final String ACCOUNT_CACHE = "accountCache";
	public static final String ACCOUNT_CACHE_ID_ = "accountid_";
	public static final String USER_CACHE_LOGIN_NAME_ = "ln";
	public static final String USER_CACHE_LIST_BY_OFFICE_ID_ = "oid_";

	public static final String CACHE_USER_LIST = "userList";
	public static final String CACHE_ROLE_LIST = "roleList";
	public static final String CACHE_MENU_LIST = "menuList";
	public static final String CACHE_AREA_LIST = "areaList";
	public static final String CACHE_OFFICE_LIST = "officeList";
	public static final String CACHE_OFFICE_ALL_LIST = "officeAllList";
	
	/**
	 * 获取用户列表
	 * @return List<User> 用户列表
	 */
	public static List<User> getUserList(){
		
		@SuppressWarnings("unchecked")
		List<User> userList = (List<User>)CacheUtils.get(CACHE_USER_LIST, ACCOUNT_CACHE_ID_ + getUser().getAccountId());
		if(userList == null){
			//从数据库查询
			User conUser = new User();
			conUser.getSqlMap().put("dsf", " AND a.account_id='"+getUser().getAccountId()+"' ");//隔离企业数据
			userList = userDao.findList(conUser);
			CacheUtils.put(CACHE_USER_LIST, ACCOUNT_CACHE_ID_ + getUser().getAccountId(), userList);
		}
		return userList;
	}
	
	/**
	 * 根据ID获取用户
	 * @param id
	 * @return 取不到返回null
	 */
	public static User get(String id){
		User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_ID_ + id);
		if (user ==  null){
			user = userDao.get(id);
			if (user == null){
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}
	
	/**
	 * 根据登录名获取用户
	 * @param loginName
	 * @return 取不到返回null
	 */
	public static User getByLoginName(String loginName){
		User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginName);
		if (user == null){
			user = userDao.getByLoginName(new User(null, loginName));
			if (user == null){
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}
	
	/**
	 * 清除当前用户缓存
	 */
	public static void clearCache(){
		removeCache(CACHE_USER_LIST);
		removeCache(CACHE_ROLE_LIST);
		removeCache(CACHE_MENU_LIST);
		removeCache(CACHE_AREA_LIST);
		removeCache(CACHE_OFFICE_LIST);
		removeCache(CACHE_OFFICE_ALL_LIST);
		UserUtils.clearCache(getUser());
	}
	
	/**
	 * 清除指定用户缓存
	 * @param user
	 */
	public static void clearCache(User user){
		CacheUtils.remove(USER_CACHE, USER_CACHE_ID_ + user.getId());
		CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName());
		CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getOldLoginName());
		if (user.getOffice() != null && user.getOffice().getId() != null){
			CacheUtils.remove(USER_CACHE, USER_CACHE_LIST_BY_OFFICE_ID_ + user.getOffice().getId());
		}
	}
	
	/**
	 * 清除指定企业缓存
	 * @param sysAccount
	 */
	public static void clearCacheAccount(SysAccount sysAccount){
		CacheUtils.remove(ACCOUNT_CACHE , ACCOUNT_CACHE_ID_+ sysAccount.getId());
	}
	
	/**
	 * 获取当前用户
	 * @return 取不到返回 new User()
	 */
	public static User getUser(){
		Principal principal = getPrincipal();
		if (principal!=null){
			User user = get(principal.getId());
			if (user != null){
				return user;
			}
			return new User();
		}
		// 如果没有登录，则返回实例化空的User对象。
		return new User();
	}

	/**
	 * 获取当前用户角色列表
	 * @return
	 */
	public static List<Role> getRoleList(){
		@SuppressWarnings("unchecked")
		List<Role> roleList = (List<Role>)getCache(CACHE_ROLE_LIST);
		if (roleList == null){
			
			Role role = new Role();
			//role.getSqlMap().put("dsf", BaseService.dataScopeFilter(user.getCurrentUser(), "o", "u"));
			
			//机构、角色、用户，隔离企业账号数据，加入权限过滤
			role.getSqlMap().put("dsf", " AND a.account_id='"+getUser().getAccountId()+"' ");
			roleList = roleDao.findList(role);
			
			if(!"0".equals(getUser().getAccountId())){
				//企业管理员
				Role adminRole = roleDao.get("admin");
				if(adminRole != null)
					roleList.add(adminRole);
			}
			
			putCache(CACHE_ROLE_LIST, roleList);
		}
		return roleList;
	}
	
	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static List<Menu> getMenuList(){
		@SuppressWarnings("unchecked")
		List<Menu> menuList = (List<Menu>)getCache(CACHE_MENU_LIST);
		if (menuList == null || menuList.size() == 0){
			User user = getUser();
			if (user.isAdmin()){
				menuList = menuDao.findAllList(new Menu());
			}else{
				Menu m = new Menu();
				m.setUserId(user.getId());
				menuList = menuDao.findByUserId(m);
			}
			putCache(CACHE_MENU_LIST, menuList);
		}
		return menuList;
	}
	
	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static Menu getTopMenu(){
		Menu topMenu =  getMenuList().get(0);
		return topMenu;
	}
	
	public static Menu getTopMenuByParent(String menuid){
		Menu topMenu =  menuDao.get(menuid);
		return topMenu;
	}

	
	/**
	 * 获取当前用户授权的区域
	 * @return
	 */
	public static List<Area> getAreaList(){
		@SuppressWarnings("unchecked")
		List<Area> areaList = (List<Area>)getCache(CACHE_AREA_LIST);
		if (areaList == null){
			areaList = areaDao.findAllList(new Area());
			putCache(CACHE_AREA_LIST, areaList);
		}
		return areaList;
	}
	
	/**
	 * 获取当前用户有权限访问的部门
	 * @return
	 */
	public static List<Office> getOfficeList(){
		
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_LIST);
		if (officeList == null){
			User user = getUser();
			if (user.isAdmin()){
				
				Office office = new Office();
				//机构、角色、用户，隔离企业账号数据，加入权限过滤
				office.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
				officeList = officeDao.findAllList(office);
			}else{
				Office office = new Office();
				//office.getSqlMap().put("dsf", BaseService.dataScopeFilter(user, "a", ""));
				
				//机构、角色、用户，隔离企业账号数据，加入权限过滤
				office.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
				officeList = officeDao.findList(office);
			}
			putCache(CACHE_OFFICE_LIST, officeList);
		}
		return officeList;
	}

	/**
	 * 获取当前用户有权限访问的部门
	 * @return
	 */
	public static List<Office> getOfficeAllList(){
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_ALL_LIST);
		if (officeList == null){
			
			Office office = new Office();
			//机构、角色、用户，隔离企业账号数据，加入权限过滤
			office.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
			officeList = officeDao.findAllList(office);
		}
		return officeList;
	}
	
	/**
	 * 获取授权主要对象
	 */
	public static Subject getSubject(){
		return SecurityUtils.getSubject();
	}
	
	/**
	 * 获取当前登录者对象
	 */
	public static Principal getPrincipal(){
		try{
			Subject subject = SecurityUtils.getSubject();
			Principal principal = (Principal)subject.getPrincipal();
			if (principal != null){
				return principal;
			}
//			subject.logout();
		}catch (UnavailableSecurityManagerException e) {
			
		}catch (InvalidSessionException e){
			
		}
		return null;
	}
	
	public static Session getSession(){
		try{
			Subject subject = SecurityUtils.getSubject();
			Session session = subject.getSession(false);
			if (session == null){
				session = subject.getSession();
			}
			if (session != null){
				return session;
			}
//			subject.logout();
		}catch (InvalidSessionException e){
			
		}
		return null;
	}
	
	// ============== User Cache ==============
	
	public static Object getCache(String key) {
		return getCache(key, null);
	}
	
	public static Object getCache(String key, Object defaultValue) {
//		Object obj = getCacheMap().get(key);
		Object obj = getSession().getAttribute(key);
		return obj==null?defaultValue:obj;
	}

	public static void putCache(String key, Object value) {
//		getCacheMap().put(key, value);
		getSession().setAttribute(key, value);
	}

	public static void removeCache(String key) {
//		getCacheMap().remove(key);
		getSession().removeAttribute(key);
	}
	
	/**
	 * 导出Excel调用,根据姓名转换为ID
	 */
	public static User getByUserName(String name){
		User u = new User();
		u.setName(name);
		List<User> list = userDao.findList(u);
		if(list.size()>0){
			return list.get(0);
		}else{
			return new User();
		}
	}
	/**
	 * 导出Excel使用，根据名字转换为id
	 */
	public static Office getByOfficeName(String name){
		Office o = new Office();
		o.setName(name);
		List<Office> list = officeDao.findList(o);
		if(list.size()>0){
			return list.get(0);
		}else{
			return new Office();
		}
	}
	/**
	 * 导出Excel使用，根据名字转换为id
	 */
	public static Area getByAreaName(String name){
		Area a = new Area();
		a.setName(name);
		List<Area> list = areaDao.findList(a);
		if(list.size()>0){
			return list.get(0);
		}else{
			return new Area();
		}
	}
	
	/**
	 * 获取当前企业信息 缓存优先
	 * @return
	 */
	public static SysAccount getSysAccount(){
		User user = getUser();
		SysAccount sysAccount = (SysAccount) CacheUtils.get(ACCOUNT_CACHE , ACCOUNT_CACHE_ID_+ user.getAccountId());
		if(sysAccount == null){
			sysAccount = sysAccountDao.get(user.getAccountId());
			CacheUtils.put(ACCOUNT_CACHE, ACCOUNT_CACHE_ID_+ user.getAccountId(), sysAccount);
		}
		return sysAccount;
	}
}
