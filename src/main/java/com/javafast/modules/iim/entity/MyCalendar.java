package com.javafast.modules.iim.entity;

import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;
import com.javafast.modules.sys.entity.User;

/**
 * 日历Entity
 */
public class MyCalendar extends DataEntity<MyCalendar> {
	
	private static final long serialVersionUID = 1L;
	private String title;		// 事件标题
	private String start;		// 事件开始时间
	private String end;		// 事件结束时间
	private String adllDay;		// 是否为全天时间
	private String color;		// 时间的背景色
	private User user;		// 所属用户
	
	private String beginStart;		//查询条件 开始
	private String endStart;		// 查询条件 结束
	
	private String customerId;
	
	public MyCalendar() {
		super();
	}

	public MyCalendar(String id){
		super(id);
	}

	@Length(min=0, max=64, message="事件标题长度必须介于 0 和 64 之间")
	@ExcelField(title="事件标题", align=2, sort=1)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@ExcelField(title="事件开始时间", align=2, sort=2)
	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}
	
	@ExcelField(title="事件结束时间", align=2, sort=3)
	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}
	
	@Length(min=0, max=64, message="是否为全天时间长度必须介于 0 和 64 之间")
	@ExcelField(title="是否为全天时间", align=2, sort=4)
	public String getAdllDay() {
		return adllDay;
	}

	public void setAdllDay(String adllDay) {
		this.adllDay = adllDay;
	}
	
	@Length(min=0, max=64, message="时间的背景色长度必须介于 0 和 64 之间")
	@ExcelField(title="时间的背景色", align=2, sort=5)
	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public User getUser() {
		return user;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getBeginStart() {
		return beginStart;
	}

	public void setBeginStart(String beginStart) {
		this.beginStart = beginStart;
	}

	public String getEndStart() {
		return endStart;
	}

	public void setEndStart(String endStart) {
		this.endStart = endStart;
	}	
}