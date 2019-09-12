package com.javafast.modules.act.dao;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.act.entity.Act;

/**
 * 审批DAO接口
 */
@MyBatisDao
public interface ActDao extends CrudDao<Act> {

	public int updateProcInsIdByBusinessId(Act act);
	
	public List<String> findProcDefName();
	
}
