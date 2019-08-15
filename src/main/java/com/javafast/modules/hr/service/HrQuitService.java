package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.hr.entity.HrEmployee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrQuit;
import com.javafast.modules.hr.dao.HrEmployeeDao;
import com.javafast.modules.hr.dao.HrQuitDao;

/**
 * 离职Service
 * @author javafast
 * @version 2018-07-06
 */
@Service
@Transactional(readOnly = true)
public class HrQuitService extends CrudService<HrQuitDao, HrQuit> {

	@Autowired
	private HrEmployeeDao hrEmployeeDao;
	
	@Autowired
	private UserService userService;
	
	public HrQuit get(String id) {
		return super.get(id);
	}
	
	public List<HrQuit> findList(HrQuit hrQuit) {
		dataScopeFilter(hrQuit);//加入数据权限过滤
		return super.findList(hrQuit);
	}
	
	public Page<HrQuit> findPage(Page<HrQuit> page, HrQuit hrQuit) {
		dataScopeFilter(hrQuit);//加入数据权限过滤
		return super.findPage(page, hrQuit);
	}
	
	@Transactional(readOnly = false)
	public void save(HrQuit hrQuit) {
		super.save(hrQuit);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrQuit hrQuit) {
		super.delete(hrQuit);
	}
	
	/**
	 * 审核离职
	 * @param hrQuit
	 */
	@Transactional(readOnly = false)
	public void audit(HrQuit hrQuit) {
		
		HrEmployee hrEmployee = hrEmployeeDao.get(hrQuit.getHrEmployee().getId());
		hrEmployee.setStatus("1");//离职状态
		hrEmployeeDao.update(hrEmployee);
		
		//账号冻结
		User user = userService.get(hrEmployee.getId());
		if(user != null){
			user.setLoginFlag(Global.NO);
			userService.updateLoginFlag(user);
		}
		
		hrQuit.setStatus("1");
		super.save(hrQuit);
	}
}