package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.entity.HrEmployee;
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.hr.dao.HrEmployeeDao;

/**
 * 员工信息Service
 * @author javafast
 * @version 2018-07-03
 */
@Service
@Transactional(readOnly = true)
public class HrEmployeeService extends CrudService<HrEmployeeDao, HrEmployee> {

	@Autowired
	private UserDao userDao;
	
	public HrEmployee get(String id) {
		return super.get(id);
	}
	
	public List<HrEmployee> findList(HrEmployee hrEmployee) {
		dataScopeFilter(hrEmployee);//加入数据权限过滤
		return super.findList(hrEmployee);
	}
	
	public Page<HrEmployee> findPage(Page<HrEmployee> page, HrEmployee hrEmployee) {
		dataScopeFilter(hrEmployee);//加入数据权限过滤
		return super.findPage(page, hrEmployee);
	}
	
	/**
	 * 创建员工
	 * @param hrEmployee
	 */
	@Transactional(readOnly = false)
	public void create(HrEmployee hrEmployee) {
		
		//ID，用于员工账号、员工信息主键
		String id = IdUtils.getId();
		if(hrEmployee.getIsNewRecord()){
			
			//创建员工信息
			hrEmployee.preInsert();
			hrEmployee.setId(id);
			//如果不关联简历，也要赋一个值，用于查询日志
			if(hrEmployee.getHrResume() == null || StringUtils.isBlank(hrEmployee.getHrResume().getId())){
				hrEmployee.setHrResume(new HrResume(id));
			}
			dao.insert(hrEmployee);
			
			//创建用户账号
			User user = hrEmployee.getUser();
			user.setLoginName(hrEmployee.getMobile());
			user.setName(hrEmployee.getName());
			user.setMobile(hrEmployee.getMobile());
			user.setEmail(hrEmployee.getEmail());
			user.setLoginFlag("1");
			user.setPhoto("/static/images/user.jpg");
			user.setNo(hrEmployee.getUser().getNo());
			user.setCompany(hrEmployee.getUser().getCompany());
			user.setOffice(hrEmployee.getUser().getOffice());
			String loginPass = String.valueOf((int) (Math.random() * 9000 + 1000));//初始密码，生成随机4位验证码
			user.setPassword(UserService.entryptPassword(loginPass));//密码
			user.preInsert();
			user.setId(id);
			userDao.insert(user);
			
			//授权普通用户角色
			List<Role> roleList = Lists.newArrayList();
			Role role = new Role("member");//企业普通用户角色
			roleList.add(role);
			user.setRoleList(roleList);
			userDao.insertUserRole(user);
		}
	}
	
	@Transactional(readOnly = false)
	public void save(HrEmployee hrEmployee) {
		super.save(hrEmployee);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrEmployee hrEmployee) {
		super.delete(hrEmployee);
	}
	
}