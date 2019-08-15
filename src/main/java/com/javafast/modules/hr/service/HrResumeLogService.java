package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrResumeLog;
import com.javafast.modules.hr.dao.HrResumeLogDao;

/**
 * HR日志Service
 * @author javafast
 * @version 2018-06-29
 */
@Service
@Transactional(readOnly = true)
public class HrResumeLogService extends CrudService<HrResumeLogDao, HrResumeLog> {

	public HrResumeLog get(String id) {
		return super.get(id);
	}
	
	public List<HrResumeLog> findList(HrResumeLog hrResumeLog) {
		dataScopeFilter(hrResumeLog);//加入数据权限过滤
		return super.findList(hrResumeLog);
	}
	
	public Page<HrResumeLog> findPage(Page<HrResumeLog> page, HrResumeLog hrResumeLog) {
		dataScopeFilter(hrResumeLog);//加入数据权限过滤
		return super.findPage(page, hrResumeLog);
	}
	
	@Transactional(readOnly = false)
	public void save(HrResumeLog hrResumeLog) {
		super.save(hrResumeLog);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrResumeLog hrResumeLog) {
		super.delete(hrResumeLog);
	}
	
}