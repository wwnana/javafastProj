package com.javafast.modules.sys.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.dao.SysBrowseLogDao;

/**
 * 足迹Service
 */
@Service
@Transactional(readOnly = true)
public class SysBrowseLogService extends CrudService<SysBrowseLogDao, SysBrowseLog> {

	public SysBrowseLog get(String id) {
		return super.get(id);
	}
	
	public List<SysBrowseLog> findList(SysBrowseLog sysBrowseLog) {
		sysBrowseLog.setUserId(UserUtils.getUser().getId());//加入权限过滤		
		return super.findList(sysBrowseLog);
	}
	
	public Page<SysBrowseLog> findPage(Page<SysBrowseLog> page, SysBrowseLog sysBrowseLog) {
		if(!sysBrowseLog.isApi()){
			sysBrowseLog.setUserId(UserUtils.getUser().getId());//加入权限过滤	
		}
		return super.findPage(page, sysBrowseLog);
	}
	
	@Transactional(readOnly = false)
	public void save(SysBrowseLog sysBrowseLog) {
		super.save(sysBrowseLog);
	}
	
	@Transactional(readOnly = false)
	public void delete(SysBrowseLog sysBrowseLog) {
		super.delete(sysBrowseLog);
	}
	
	/**
	 * 添加足迹
	 * @param targetType
	 * @param targetId
	 * @param targetName
	 */
	@Transactional(readOnly = false)
	public void add(String targetType, String targetId, String targetName) {
		
		SysBrowseLog sysBrowseLog = new SysBrowseLog();
		sysBrowseLog.setTargetType(targetType);
		sysBrowseLog.setTargetId(targetId);
		sysBrowseLog.setTargetName(targetName);
		sysBrowseLog.setUserId(UserUtils.getUser().getId());
		sysBrowseLog.setBrowseDate(new Date());
		
		dao.deleteSysBrowseLog(sysBrowseLog);
		
		super.save(sysBrowseLog);
	}
}