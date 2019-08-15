package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaProjectCon;
import com.javafast.modules.oa.entity.OaProjectImple;
import com.javafast.modules.oa.entity.TestAudit;

/**
 * 项目实施流程表DAO接口
 * @author javafast
 * @version 2019-07-15
 */
@MyBatisDao
public interface OaProjectImpleDao extends CrudDao<OaProjectImple> {
	
	public OaProjectImple getByProcInsId(String procInsId);

	public int updateInsId(OaProjectImple oaProjectImple);
	
	public int updateLeadText(OaProjectImple oaProjectImple);
	
	public int updateMainLeadText(OaProjectImple oaProjectImple);
	
	public OaProjectImple getProName(String procInsId);
}