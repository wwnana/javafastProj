package com.javafast.modules.oa.dao;

import org.apache.ibatis.annotations.Param;
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
	
	/**
	 * 根据流程阶段名称查询所有任务
	 */
	public List<OaTask> findTaskByProc(@Param("projId") String projId,@Param("procDef") String procDef);

	/**
	 * 查询用户提交的流程表单对应的任务项，将开始状态改为完成状态
	 * @param taskName
	 * @param projId
	 * @param userId
	 * @param procDef
	 * @return
	 */
	public OaTask getTaskByName(@Param("taskName")String taskName, @Param("projId")String projId, 
			@Param("userId")String userId);

	public List<OaTask> findTaskByStatus(@Param("projId")String projId, @Param("status")String status);
	
}