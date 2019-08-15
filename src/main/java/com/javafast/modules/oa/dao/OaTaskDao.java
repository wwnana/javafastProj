package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.oa.entity.OaTask;

/**
 * 任务DAO接口
 */
@MyBatisDao
public interface OaTaskDao extends CrudDao<OaTask> {
	
	/**
	 * 查询记录数
	 * @param oaTask
	 * @return
	 */
	public Long findCount(OaTask oaTask);
	
	/**
	 * 查询项目任务数
	 */
	public int findProCount(OaTask oaTask);
	
	/**
	 * 查询项目完成任务数
	 */
	public int findProFinCount(OaTask oaTask);
}