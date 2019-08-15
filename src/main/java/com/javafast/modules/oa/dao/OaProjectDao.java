package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import java.util.List;
import com.google.common.collect.Lists;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProject;

/**
 * 项目DAO接口
 * @author javafast
 * @version 2018-05-18
 */
@MyBatisDao
public interface OaProjectDao extends CrudDao<OaProject> {
	
	/**
	 * 查询记录数
	 * @param oaProject
	 * @return
	 */
	public Long findCount(OaProject oaProject);
	
}