package com.javafast.modules.oa.dao;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProjCons;

/**
 * 项目咨询流程表DAO接口
 * @author javafast
 * @version 2019-08-16
 */
@MyBatisDao
public interface OaProjConsDao extends CrudDao<OaProjCons> {

	OaProjCons findLastTask(@Param("procInsId")String procInsId, @Param("status")String status);

	void updateAuditText(OaProjCons oaProjCons);

	List<OaProjCons> getProName(String insId);
	
}