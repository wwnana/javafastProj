package com.javafast.modules.sys.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.SysConfig;

/**
 * 系统配置DAO接口
 * @author javafast
 * @version 2018-05-24
 */
@MyBatisDao
public interface SysConfigDao extends CrudDao<SysConfig> {
	
}