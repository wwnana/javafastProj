package com.javafast.modules.hr.service;

import java.util.List;

import com.javafast.modules.hr.entity.HrEmployee;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrSalaryChange;
import com.javafast.modules.hr.dao.HrEmployeeDao;
import com.javafast.modules.hr.dao.HrSalaryChangeDao;

/**
 * 调薪Service
 * @author javafast
 * @version 2018-07-05
 */
@Service
@Transactional(readOnly = true)
public class HrSalaryChangeService extends CrudService<HrSalaryChangeDao, HrSalaryChange> {

	@Autowired
	private HrEmployeeDao hrEmployeeDao;
	
	public HrSalaryChange get(String id) {
		return super.get(id);
	}
	
	public List<HrSalaryChange> findList(HrSalaryChange hrSalaryChange) {
		dataScopeFilter(hrSalaryChange);//加入数据权限过滤
		return super.findList(hrSalaryChange);
	}
	
	public Page<HrSalaryChange> findPage(Page<HrSalaryChange> page, HrSalaryChange hrSalaryChange) {
		dataScopeFilter(hrSalaryChange);//加入数据权限过滤
		return super.findPage(page, hrSalaryChange);
	}
	
	@Transactional(readOnly = false)
	public void save(HrSalaryChange hrSalaryChange) {
		super.save(hrSalaryChange);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrSalaryChange hrSalaryChange) {
		super.delete(hrSalaryChange);
	}
	
	/**
	 * 审核调薪
	 * @param hrSalaryChange
	 */
	@Transactional(readOnly = false)
	public void audit(HrSalaryChange hrSalaryChange) {
		
		if("0".equals(hrSalaryChange.getStatus())){
			
			//修改工资
			HrEmployee hrEmployee = hrEmployeeDao.get(hrSalaryChange.getHrEmployee().getId());

			if("0".equals(hrEmployee.getRegularStatus())){
				hrEmployee.setProbationSalaryBase(hrSalaryChange.getBaseSalary());
			}
			if("1".equals(hrEmployee.getRegularStatus())){
				hrEmployee.setFormalSalaryBase(hrSalaryChange.getBaseSalary());
			}
			hrEmployeeDao.update(hrEmployee);
			
			//审核调薪
			hrSalaryChange.setStatus("1");
			super.save(hrSalaryChange);
		}
	}
	
}