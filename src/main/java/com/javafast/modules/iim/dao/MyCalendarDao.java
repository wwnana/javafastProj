package com.javafast.modules.iim.dao;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.oa.entity.OaTask;


/**
 * 日历DAO接口
 */
@MyBatisDao
public interface MyCalendarDao extends CrudDao<MyCalendar> {
	
	/**
	 * 查询记录数
	 * @param myCalendar
	 * @return
	 */
	public Long findCount(MyCalendar myCalendar);
}