package com.javafast.modules.sys.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.SysAccount;

/**
 * 企业帐户DAO接口
 */
@MyBatisDao
public interface SysAccountDao extends CrudDao<SysAccount> {
	
	/**
	 * 修改状态
	 * @param sysAccount
	 */
	public void updateStatus(SysAccount sysAccount);
	
	/**
	 * 更新企业当前用户数
	 * @param sysAccount
	 */
	public void updateUserNum(SysAccount sysAccount);
	
	/**
	 * 获取开通企业微信的帐户
	 * @param sysAccount
	 * @return
	 */
	public List<SysAccount> findCorpList(SysAccount sysAccount);
}