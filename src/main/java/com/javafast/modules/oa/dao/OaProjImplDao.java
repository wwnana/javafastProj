package com.javafast.modules.oa.dao;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import javax.validation.constraints.NotNull;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaProjImpl;

/**
 * 项目实施流程表DAO接口
 * @author javafast
 * @version 2019-08-20
 */
@MyBatisDao
public interface OaProjImplDao extends CrudDao<OaProjImpl> {

	List<OaProjImpl> getProName(String insId);

	OaProjImpl findLastTask(@Param("procInsId") String procInsId, @Param("status") String status);

	void updateAuditText(OaProjImpl oaProjImpl);
	
	
}