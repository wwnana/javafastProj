package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrSalaryDetail;
import com.javafast.modules.hr.dao.HrSalaryDetailDao;

/**
 * 工资明细Service
 * @author javafast
 * @version 2018-07-05
 */
@Service
@Transactional(readOnly = true)
public class HrSalaryDetailService extends CrudService<HrSalaryDetailDao, HrSalaryDetail> {

	public HrSalaryDetail get(String id) {
		return super.get(id);
	}
	
	public List<HrSalaryDetail> findList(HrSalaryDetail hrSalaryDetail) {
		dataScopeFilter(hrSalaryDetail);//加入数据权限过滤
		return super.findList(hrSalaryDetail);
	}
	
	public Page<HrSalaryDetail> findPage(Page<HrSalaryDetail> page, HrSalaryDetail hrSalaryDetail) {
		dataScopeFilter(hrSalaryDetail);//加入数据权限过滤
		return super.findPage(page, hrSalaryDetail);
	}
	
	@Transactional(readOnly = false)
	public void save(HrSalaryDetail hrSalaryDetail) {
		super.save(hrSalaryDetail);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrSalaryDetail hrSalaryDetail) {
		super.delete(hrSalaryDetail);
	}
	
}