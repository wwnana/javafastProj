package com.javafast.modules.oa.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaProjectCon;

/**
 * 项目咨询流程表DAO接口
 * @author javafast
 * @version 2019-08-06
 */
@MyBatisDao
public interface OaProjectConDao extends CrudDao<OaProjectCon> {
	public OaProjectCon getByProcInsId(String procInsId);
	
	public int updateInsId(OaProjectCon oaProjectCon);
	
	public int updateHrText(OaProjectCon oaProjectCon);
	
	public int updateLeadFstText(OaProjectCon oaProjectCon);
	
	public OaProjectCon getProName(String procInsId);
	
	public int updateUserId1(OaProjectCon oaProjectCon);
	
	public int updateUserId2(OaProjectCon oaProjectCon);
	
	public int updateUserId3(OaProjectCon oaProjectCon);
	
}