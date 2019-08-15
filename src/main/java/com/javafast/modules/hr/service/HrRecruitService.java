package com.javafast.modules.hr.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrRecruit;
import com.javafast.modules.hr.dao.HrRecruitDao;

/**
 * 招聘任务Service
 * @author javafast
 * @version 2018-06-29
 */
@Service
@Transactional(readOnly = true)
public class HrRecruitService extends CrudService<HrRecruitDao, HrRecruit> {

	public HrRecruit get(String id) {
		return super.get(id);
	}
	
	public List<HrRecruit> findList(HrRecruit hrRecruit) {
		dataScopeFilter(hrRecruit);//加入数据权限过滤
		return super.findList(hrRecruit);
	}
	
	public Page<HrRecruit> findPage(Page<HrRecruit> page, HrRecruit hrRecruit) {
		dataScopeFilter(hrRecruit);//加入数据权限过滤
		return super.findPage(page, hrRecruit);
	}
	
	@Transactional(readOnly = false)
	public void save(HrRecruit hrRecruit) {
		super.save(hrRecruit);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrRecruit hrRecruit) {
		super.delete(hrRecruit);
	}
	
}