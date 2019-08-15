package com.javafast.modules.hr.service;

import java.util.List;

import com.javafast.modules.sys.entity.Office;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrPositionChange;
import com.javafast.modules.hr.dao.HrPositionChangeDao;

/**
 * 调岗Service
 * @author javafast
 * @version 2018-07-05
 */
@Service
@Transactional(readOnly = true)
public class HrPositionChangeService extends CrudService<HrPositionChangeDao, HrPositionChange> {

	public HrPositionChange get(String id) {
		return super.get(id);
	}
	
	public List<HrPositionChange> findList(HrPositionChange hrPositionChange) {
		dataScopeFilter(hrPositionChange);//加入数据权限过滤
		return super.findList(hrPositionChange);
	}
	
	public Page<HrPositionChange> findPage(Page<HrPositionChange> page, HrPositionChange hrPositionChange) {
		dataScopeFilter(hrPositionChange);//加入数据权限过滤
		return super.findPage(page, hrPositionChange);
	}
	
	@Transactional(readOnly = false)
	public void save(HrPositionChange hrPositionChange) {
		super.save(hrPositionChange);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrPositionChange hrPositionChange) {
		super.delete(hrPositionChange);
	}
	
}