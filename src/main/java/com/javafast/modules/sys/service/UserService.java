package com.javafast.modules.sys.service;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.security.Digests;
import com.javafast.common.security.shiro.session.SessionDAO;
import com.javafast.common.service.CrudService;
import com.javafast.common.service.ServiceException;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.Encodes;
import com.javafast.common.utils.MD5Util;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.dao.HrEmployeeDao;
import com.javafast.modules.hr.entity.HrEmployee;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.security.SystemAuthorizingRealm;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 用户Service
 * @author JavaFast
 */
@Service
@Transactional(readOnly = true)
public class UserService extends CrudService<UserDao, User> implements InitializingBean {
	
	public static final int SALT_SIZE = 8;
	public static final String HASH_ALGORITHM = "SHA-1";
	public static final int HASH_INTERATIONS = 1024;
	
	@Autowired
	private HrEmployeeDao hrEmployeeDao;
	
	@Autowired
	private SessionDAO sessionDao;
	
	@Autowired
	private SystemAuthorizingRealm systemRealm;
	
	public SessionDAO getSessionDao() {
		return sessionDao;
	}
	
	/**
	 * 根据ID获取用户
	 * @param id
	 * @return
	 */
	public User getUser(String id) {
		return UserUtils.get(id);
	}
	
	/**
	 * 分页查询用户列表
	 */
	public Page<User> findPage(Page<User> page, User user) {

		dataScopeFilter(user);//加入数据权限过滤
		user.setPage(page);
		page.setList(dao.findList(user));
		return page;
	}
	
	/**
	 * 无分页查询用户列表
	 * @param user
	 * @return
	 */
	public List<User> findUser(User user){

		dataScopeFilter(user);//加入数据权限过滤
		List<User> list = dao.findList(user);
		return list;
	}
	
	/**
	 * 保存用户
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void saveUser(User user) {
		
		if (StringUtils.isBlank(user.getId())){
			
			//创建用户
			user.preInsert();
			dao.insert(user);
			
			//创建员工
			HrEmployee hrEmployee = new HrEmployee();
			hrEmployee.setName(user.getName());
			hrEmployee.setMobile(user.getMobile());
			hrEmployee.setEmail(user.getEmail());
			hrEmployee.setUser(user);
			hrEmployee.setStatus("0");
			hrEmployee.preInsert();
			hrEmployee.setId(user.getId());
			hrEmployeeDao.insert(hrEmployee);
		}else{
			// 清除原用户机构用户缓存
			User oldUser = dao.get(user.getId());
			if (oldUser.getOffice() != null && oldUser.getOffice().getId() != null){
				CacheUtils.remove(UserUtils.USER_CACHE, UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + oldUser.getOffice().getId());
			}
			// 更新用户数据
			user.preUpdate();
			dao.update(user);
		}
		if (StringUtils.isNotBlank(user.getId())){
			// 更新用户与角色关联
			dao.deleteUserRole(user);
			if (user.getRoleList() != null && user.getRoleList().size() > 0){
				dao.insertUserRole(user);
			}else{
				throw new ServiceException(user.getLoginName() + "没有设置角色！");
			}
			// 清除用户缓存
			removeUserCache(user);
		}
	}
	
	/**
	 * 修改用户信息
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void updateUser(User user) {
		
		// 更新用户数据
		user.preUpdate();
		dao.update(user);
		
		// 清除用户缓存
		removeUserCache(user);
	}
	/**
	 * 更新用户状态
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void updateLoginFlag(User user){
		dao.updateLoginFlag(user);
		// 清除用户缓存
		removeUserCache(user);
	}
	
	/**
	 * 更新用户信息
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void updateUserInfo(User user) {
		user.preUpdate();
		dao.updateUserInfo(user);
		// 清除用户缓存
		removeUserCache(user);
	}
	
	@Transactional(readOnly = false)
	public void delete(User user) {
		
		dao.delete(user);
		
//		//删除员工档案
//		HrEmployee hrEmployee = hrEmployeeDao.get(user.getId());
//		if(hrEmployee !=null)
//			hrEmployeeDao.delete(new HrEmployee(user.getId()));
		
		// 清除用户缓存
		removeUserCache(user);
	}
	
	/**
	 * 查询企业用户数目
	 * @return
	 */
	public long findCount(User user){
		user.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"'");
		return dao.findCount(user);
	}
	
	/**
	 * 角色分配 -- 从角色中移除用户
	 * @param role
	 * @param user
	 * @return
	 */
	@Transactional(readOnly = false)
	public Boolean outUserInRole(Role role, User user) {
		List<Role> roles = user.getRoleList();
		for (Role e : roles){
			if (e.getId().equals(role.getId())){
				roles.remove(e);
				saveUser(user);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 角色分配 -- 添加用户到角色
	 * @param role
	 * @param user
	 * @return
	 */
	@Transactional(readOnly = false)
	public User assignUserToRole(Role role, User user) {
		if (user == null){
			return null;
		}
		List<String> roleIds = user.getRoleIdList();
		if (roleIds.contains(role.getId())) {
			return null;
		}
		user.getRoleList().add(role);
		saveUser(user);
		return user;
	}
	
	/**
	 * 从数据库读取用户信息
	 * @param id
	 * @return
	 */
	public User getUserByDb(String id) {
		return dao.get(id);
	}
	
	/**
	 * 保存用户信息到数据库
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void saveUserByDb(User user) {
		
		dao.insert(user);
		if (user.getRoleList() != null && user.getRoleList().size() > 0){
			dao.insertUserRole(user);
		}else{
			throw new ServiceException(user.getLoginName() + "没有设置角色！");
		}
		
		// 清除用户缓存
		//UserUtils.clearCache(user);
	}
	
	/**
	 * 通过部门ID获取用户列表，仅返回用户id和name（树查询用户时用）
	 * @param user
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> findUserByOfficeId(String officeId) {
		List<User> list = (List<User>)CacheUtils.get(UserUtils.USER_CACHE, UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId);
		if (list == null){
			User user = new User();
			user.setOffice(new Office(officeId));
			list = dao.findUserByOfficeId(user);
			CacheUtils.put(UserUtils.USER_CACHE, UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId, list);
		}
		return list;
	}
	
	/**
	 * 根据部门查询
	 * @param user
	 * @return
	 */
	public List<User> findListByOffice(User user){
		//机构、角色、用户，隔离企业账号数据，加入权限过滤
		user.getSqlMap().put("dsf", " AND a.account_id='"+UserUtils.getUser().getAccountId()+"' ");
		return dao.findListByOffice(user);
	}
	
	/**
	 * 获取我的好友列表
	 * @param currentUser
	 * @return
	 */
	public List<User> findFriends(User currentUser){
		return dao.findFriends(currentUser);
	}
	
	/**
	 * 查找好友
	 * @param userId
	 * @param friendId
	 * @return
	 */
	public User findFriend(@Param("userId")String userId, @Param("friendId")String friendId){
		return dao.findFriend(userId, friendId);
	}
	
	/**
	 * 查询用户-->用来添加到常用联系人
	 * @param user
	 * @return
	 */
	public List<User> searchUsers(User user){
		return dao.searchUsers(user);
	}
	
	/**
	 * 插入好友
	 * @param id
	 * @param userId
	 * @param friendId
	 * @return
	 */
	@Transactional(readOnly = false)
	public int insertFriend(@Param("id")String id, @Param("userId")String userId, @Param("friendId")String friendId){
		return dao.insertFriend(id, userId, friendId);
	}
	
	/**
	 * 删除好友
	 * @param userId
	 * @param friendId
	 */
	@Transactional(readOnly = false)
	public void deleteFriend(@Param("userId")String userId, @Param("friendId")String friendId){
		dao.deleteFriend(userId, friendId);
	}
	
	/**
	 * 更新密码
	 * @param id
	 * @param loginName
	 * @param newPassword
	 */
	@Transactional(readOnly = false)
	public void updatePasswordById(String id, String loginName, String newPassword) {
		User user = new User(id);
		user.setPassword(entryptPassword(newPassword));
		dao.updatePasswordById(user);
		// 清除用户缓存
		user.setLoginName(loginName);
		removeUserCache(user);
	}
	
	/**
	 * 生成安全的密码，生成随机的16位salt并经过1024次 sha-1 hash
	 */
	public static String entryptPassword(String plainPassword) {
		byte[] salt = Digests.generateSalt(SALT_SIZE);
		byte[] hashPassword = Digests.sha1(plainPassword.getBytes(), salt, HASH_INTERATIONS);
		return Encodes.encodeHex(salt)+Encodes.encodeHex(hashPassword);
	}
	
	/**
	 * 验证密码
	 * @param plainPassword 明文密码
	 * @param password 密文密码
	 * @return 验证成功返回true
	 */
	public static boolean validatePassword(String plainPassword, String password) {
		byte[] salt = Encodes.decodeHex(password.substring(0,16));
		byte[] hashPassword = Digests.sha1(plainPassword.getBytes(), salt, HASH_INTERATIONS);
		return password.equals(Encodes.encodeHex(salt)+Encodes.encodeHex(hashPassword));
	}
	
	/**
	 * 清除用户缓存
	 * @param user
	 */
	public void removeUserCache(User user){
		// 清除用户缓存
		UserUtils.clearCache(user);
//		// 清除权限缓存
//		systemRealm.clearAllCachedAuthorizationInfo();
	}
	
	/**
	 * 根据登录名获取用户
	 * @param loginName
	 * @return
	 */
	public User getUserByLoginName(String loginName) {
		User user = dao.getByLoginName(new User(null, loginName));
		if (user == null){
			return null;
		}
		return user;
	}
	
	/**
	 * 更新用户登录信息
	 * @param user
	 */
	@Transactional(readOnly = false)
	public void updateUserLoginInfo(User user) {
		// 保存上次登录信息
		user.setOldLoginIp(user.getLoginIp());
		user.setOldLoginDate(user.getLoginDate());
		// 更新本次登录信息
		user.setLoginIp(UserUtils.getSession().getHost());
		user.setLoginDate(new Date());
		dao.updateLoginInfo(user);
	}
	
	/**
	 * 获得活动会话
	 * @return
	 */
	public Collection<Session> getActiveSessions(){
		return sessionDao.getActiveSessions(false);
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
	}
	
	/**
	 * 通过企业微信相关信息查询用户列表
	 * @param accountId 企业ID
	 * @param userId 企业微信用户ID
	 * @return
	 */
	public User findUserByWorkWechat(String accountId, String userId){
		
		User conUser = new User();
		conUser.setAccountId(accountId);
		conUser.setUserId(userId);
		List<User> userList = dao.findListByUserId(conUser);
		if(userList != null && userList.size() == 1){
			return userList.get(0);
		}
		
		return null;
	}
	
	/**
	 * 生成token并保存到数据库 ，用于APP登录，支持账号密码登录、验证码登录
	 * @param user
	 * @param machCode
	 * @return
	 */
	@Transactional(readOnly = false)
	public String createToken(User user, String machCode){
		
		//token生成 = MD5( 账号 + 机器码 )
		String token = MD5Util.string2MD5(user.getName() + machCode);
		user.setLoginDate(new Date());
		user.setLoginIp(machCode);
		user.setToken(token);
		dao.updateLoginInfo(user);
		return token;
	}
	
	/**
	 * 解码
	 * @param inputPasswrod
	 * @param userPassword
	 * @return
	 */
	public String entryptPassword(String inputPasswrod, String userPassword) {
		String plain = Encodes.unescapeHtml(inputPasswrod);
		//byte[] salt = Digests.generateSalt(SALT_SIZE);
		byte[] salt = Encodes.decodeHex(userPassword.substring(0,16));
		byte[] hashPassword = Digests.sha1(plain.getBytes(), salt, 1024);
		return Encodes.encodeHex(salt)+Encodes.encodeHex(hashPassword);
	}
	
	/**
	 * TOKEN身份校验
	 * @param userId
	 * @param token
	 * @return
	 */
	public boolean checkToken(String userId, String token){
		User User = this.get(userId);
		if(token.equals(User.getToken())){
			return true;
		}
		return false;
	}
	
	/**
	 * 根据手机号码进行查询
	 * @param mobile
	 * @return
	 */
	public User getByMobile(String mobile){
		List<User> list = dao.findListByMobile(mobile);
		if(list != null && list.size()>0){
			
			return list.get(0);
		}
		return null;
	}
}
