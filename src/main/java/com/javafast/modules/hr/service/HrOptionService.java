package com.javafast.modules.hr.service;

import java.util.List;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrOption;
import com.javafast.modules.hr.dao.HrOptionDao;

/**
 * 期权Service
 * @author javafast
 * @version 2018-07-06
 */
@Service
@Transactional(readOnly = true)
public class HrOptionService extends CrudService<HrOptionDao, HrOption> {

	public HrOption get(String id) {
		return super.get(id);
	}
	
	public List<HrOption> findList(HrOption hrOption) {
		dataScopeFilter(hrOption);//加入数据权限过滤
		return super.findList(hrOption);
	}
	
	public Page<HrOption> findPage(Page<HrOption> page, HrOption hrOption) {
		dataScopeFilter(hrOption);//加入数据权限过滤
		return super.findPage(page, hrOption);
	}
	
	@Transactional(readOnly = false)
	public void save(HrOption hrOption) {
		super.save(hrOption);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrOption hrOption) {
		super.delete(hrOption);
	}
	
}