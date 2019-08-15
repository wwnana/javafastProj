package com.javafast.modules.oa.dao;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaNotify;

/**
 * 通知通告DAO接口
 */
@MyBatisDao
public interface OaNotifyDao extends CrudDao<OaNotify> {
	
	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify);
	
	public List<OaNotify> findListByUser(OaNotify oaNotify);
	
	public OaNotify getById(String id);
	
}