package com.javafast.modules.sys.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.sys.entity.SysPanel;

/**
 * 面板设置DAO接口
 * @author javafast
 * @version 2018-07-09
 */
@MyBatisDao
public interface SysPanelDao extends CrudDao<SysPanel> {
	
	public List<SysPanel> findCurrentList(SysPanel sysPanel);
}