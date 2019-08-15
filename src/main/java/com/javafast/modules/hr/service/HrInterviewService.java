package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrInterview;
import com.javafast.modules.hr.dao.HrInterviewDao;

/**
 * 面试Service
 * @author javafast
 * @version 2018-06-29
 */
@Service
@Transactional(readOnly = true)
public class HrInterviewService extends CrudService<HrInterviewDao, HrInterview> {

	public HrInterview get(String id) {
		return super.get(id);
	}
	
	public List<HrInterview> findList(HrInterview hrInterview) {
		dataScopeFilter(hrInterview);//加入数据权限过滤
		return super.findList(hrInterview);
	}
	
	public Page<HrInterview> findPage(Page<HrInterview> page, HrInterview hrInterview) {
		dataScopeFilter(hrInterview);//加入数据权限过滤
		return super.findPage(page, hrInterview);
	}
	
	@Transactional(readOnly = false)
	public void save(HrInterview hrInterview) {
		super.save(hrInterview);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrInterview hrInterview) {
		super.delete(hrInterview);
	}
	
}