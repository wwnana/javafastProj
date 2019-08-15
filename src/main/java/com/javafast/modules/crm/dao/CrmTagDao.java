package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmTag;

/**
 * 客户标签DAO接口
 */
@MyBatisDao
public interface CrmTagDao extends CrudDao<CrmTag> {
	
}