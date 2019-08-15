package com.javafast.modules.sys.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.User;

/**
 * 用户DAO接口
 */
@MyBatisDao
public interface UserDao extends CrudDao<User> {
	
	/**
	 * 根据登录名称查询用户
	 * @param loginName
	 * @return
	 */
	public User getByLoginName(User user);

	/**
	 * 通过OfficeId获取用户列表，仅返回用户id和name（树查询用户时用）
	 * @param user
	 * @return
	 */
	public List<User> findUserByOfficeId(User user);
	
	/**
	 * 更新用户密码
	 * @param user
	 * @return
	 */
	public int updatePasswordById(User user);
	
	/**
	 * 更新用户状态
	 * @param user
	 */
	public void updateLoginFlag(User user);
	
	/**
	 * 更新登录信息，如：登录IP、登录时间
	 * @param user
	 * @return
	 */
	public int updateLoginInfo(User user);

	/**
	 * 删除用户角色关联数据
	 * @param user
	 * @return
	 */
	public int deleteUserRole(User user);
	
	/**
	 * 插入用户角色关联数据
	 * @param user
	 * @return
	 */
	public int insertUserRole(User user);
	
	/**
	 * 更新用户信息
	 * @param user
	 * @return
	 */
	public int updateUserInfo(User user);
	
	/**
	 * 更新用户数据权限
	 * @param user
	 * @return
	 */
	public int updateUserDataScope(User user);
	
	/**
	 * 查询企业用户数目
	 * @return
	 */
	public long findCount(User user);
	
	/**
	 * 插入好友
	 * @param id
	 * @param userId
	 * @param friendId
	 * @return
	 */
	public int insertFriend(@Param("id")String id, @Param("userId")String userId, @Param("friendId")String friendId);
	
	/**
	 * 查找好友
	 * @param userId
	 * @param friendId
	 * @return
	 */
	public User findFriend(@Param("userId")String userId, @Param("friendId")String friendId);
	
	/**
	 * 删除好友
	 * @param userId
	 * @param friendId
	 */
	public void deleteFriend(@Param("userId")String userId, @Param("friendId")String friendId);
	
	/**
	 * 获取我的好友列表
	 * @param currentUser
	 * @return
	 */
	public List<User> findFriends(User currentUser);
	
	/**
	 * 查询用户-->用来添加到常用联系人
	 * @param user
	 * @return
	 */
	public List<User> searchUsers(User user);
	
	/**
	 * 根据部门查询
	 * @param user
	 * @return
	 */
	public List<User> findListByOffice(User user);
	
	/**
	 * 根据条件查询企业微信用户列表
	 * @param user
	 * @return
	 */
	public List<User> findQywxUserList2(User user);
	
	/**
	 * 通过企业微信相关信息查询用户列表
	 * @param user
	 * @return
	 */
	public List<User> findListByUserId(User user);
	
	/**
	 * 通过手机号进行查询
	 * @param mobile
	 * @return
	 */
	public List<User> findListByMobile(String mobile);
}
