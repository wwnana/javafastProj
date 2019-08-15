package com.javafast.modules.sys.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.SysBrowseLog;

/**
 * 足迹DAO接口
 */
@MyBatisDao
public interface SysBrowseLogDao extends CrudDao<SysBrowseLog> {
	
	public void deleteSysBrowseLog(SysBrowseLog sysBrowseLog);
}