package com.javafast.modules.oa.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.oa.entity.OaNote;

/**
 * 便签DAO接口
 */
@MyBatisDao
public interface OaNoteDao extends CrudDao<OaNote> {
	
}