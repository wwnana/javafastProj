package com.javafast.modules.iim.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.iim.dao.MyCalendarDao;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 日历Service
 */
@Service
@Transactional(readOnly = true)
public class MyCalendarService extends CrudService<MyCalendarDao, MyCalendar> {

	public MyCalendar get(String id) {
		return super.get(id);
	}
	
	public List<MyCalendar> findList(MyCalendar myCalendar) {
		myCalendar.setUser(UserUtils.getUser());
		return super.findList(myCalendar);
	}
	
	public Page<MyCalendar> findPage(Page<MyCalendar> page, MyCalendar myCalendar) {
		myCalendar.setUser(UserUtils.getUser());
		return super.findPage(page, myCalendar);
	}
	
	@Transactional(readOnly = false)
	public void save(MyCalendar myCalendar) {
		super.save(myCalendar);
	}
	
	@Transactional(readOnly = false)
	public void delete(MyCalendar myCalendar) {
		super.delete(myCalendar);
	}
	
	/**
	 * 查询记录数
	 * @param myCalendar
	 * @return
	 */
	public Long findCount(MyCalendar myCalendar){
		return dao.findCount(myCalendar);
	}
	
	public List<MyCalendar> findListByUser(User user) {
		MyCalendar myCalendar = new MyCalendar();
		myCalendar.setUser(user);
		myCalendar.setBeginStart(DateUtils.getDate());
		myCalendar.setEndStart(DateUtils.getDayAfter(30));
		return super.findList(myCalendar);
	}
}