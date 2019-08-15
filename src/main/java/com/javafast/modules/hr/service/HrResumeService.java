package com.javafast.modules.hr.service;

import java.util.List;

import com.javafast.modules.hr.entity.HrRecruit;
import org.hibernate.validator.constraints.Length;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.hr.entity.HrResumeRecord;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.hr.dao.HrResumeDao;
import com.javafast.modules.hr.dao.HrResumeRecordDao;

/**
 * 简历Service
 * @author javafast
 * @version 2018-06-29
 */
@Service
@Transactional(readOnly = true)
public class HrResumeService extends CrudService<HrResumeDao, HrResume> {

	@Autowired
	HrResumeRecordDao hrResumeRecordDao;
	
	public HrResume get(String id) {
		return super.get(id);
	}
	
	public List<HrResume> findList(HrResume hrResume) {
		dataScopeFilter(hrResume);//加入数据权限过滤
		return super.findList(hrResume);
	}
	
	public Page<HrResume> findPage(Page<HrResume> page, HrResume hrResume) {
		dataScopeFilter(hrResume);//加入数据权限过滤
		return super.findPage(page, hrResume);
	}
	
	@Transactional(readOnly = false)
	public void save(HrResume hrResume) {
		super.save(hrResume);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrResume hrResume) {
		super.delete(hrResume);
		
		//删除简历共享权限列表
		hrResumeRecordDao.delete(new HrResumeRecord(null, hrResume));
	}
	
	/**
	 * 查询简历共享权限列表
	 * @param hrResume
	 * @return
	 */
	public List<HrResumeRecord> findHrResumeRecordList(HrResume hrResume){
		return hrResumeRecordDao.findList(new HrResumeRecord(null, hrResume));
	}
	
	/**
	 * 添加简历共享权限
	 * @param hrResumeRecord
	 */
	@Transactional(readOnly = false)
	public void saveHrResumeRecord(HrResumeRecord hrResumeRecord){
		List<HrResumeRecord> list =hrResumeRecordDao.findList(hrResumeRecord);
		if(list == null || list.size() == 0){
			hrResumeRecord.preInsert();
			hrResumeRecordDao.insert(hrResumeRecord);
		}
	}
	
	/**
	 * 删除简历共享权限列表
	 * @param hrResume
	 */
	@Transactional(readOnly = false)
	public void deleteHrResumeRecordList(HrResume hrResume) {
		hrResumeRecordDao.delete(new HrResumeRecord(null, hrResume));
	}
}