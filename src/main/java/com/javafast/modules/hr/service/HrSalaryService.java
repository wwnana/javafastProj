package com.javafast.modules.hr.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.entity.HrSalary;
import com.javafast.modules.hr.dao.HrSalaryDao;
import com.javafast.modules.hr.entity.HrSalaryDetail;
import com.javafast.modules.hr.dao.HrSalaryDetailDao;

/**
 * 工资表Service
 * @author javafast
 * @version 2018-07-05
 */
@Service
@Transactional(readOnly = true)
public class HrSalaryService extends CrudService<HrSalaryDao, HrSalary> {

	@Autowired
	private HrSalaryDetailDao hrSalaryDetailDao;
	
	public HrSalary get(String id) {
		HrSalary hrSalary = super.get(id);
		hrSalary.setHrSalaryDetailList(hrSalaryDetailDao.findList(new HrSalaryDetail(hrSalary)));
		return hrSalary;
	}
	
	public List<HrSalary> findList(HrSalary hrSalary) {
		dataScopeFilter(hrSalary);//加入数据权限过滤
		return super.findList(hrSalary);
	}
	
	public Page<HrSalary> findPage(Page<HrSalary> page, HrSalary hrSalary) {
		dataScopeFilter(hrSalary);//加入数据权限过滤
		return super.findPage(page, hrSalary);
	}
	
	@Transactional(readOnly = false)
	public void save(HrSalary hrSalary) {
		super.save(hrSalary);
		for (HrSalaryDetail hrSalaryDetail : hrSalary.getHrSalaryDetailList()){
			if (hrSalaryDetail.getId() == null){
				continue;
			}
			if (HrSalaryDetail.DEL_FLAG_NORMAL.equals(hrSalaryDetail.getDelFlag())){
				if (StringUtils.isBlank(hrSalaryDetail.getId())){
					hrSalaryDetail.setHrSalaryId(hrSalary);
					hrSalaryDetail.preInsert();
					hrSalaryDetailDao.insert(hrSalaryDetail);
				}else{
					hrSalaryDetail.preUpdate();
					hrSalaryDetailDao.update(hrSalaryDetail);
				}
			}else{
				hrSalaryDetailDao.delete(hrSalaryDetail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(HrSalary hrSalary) {
		super.delete(hrSalary);
		hrSalaryDetailDao.delete(new HrSalaryDetail(hrSalary));
	}
	
}