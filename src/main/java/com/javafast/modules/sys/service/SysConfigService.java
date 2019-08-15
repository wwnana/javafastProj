package com.javafast.modules.sys.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.dao.SysConfigDao;

/**
 * 系统配置Service
 * @author javafast
 * @version 2018-05-24
 */
@Service
@Transactional(readOnly = true)
public class SysConfigService extends CrudService<SysConfigDao, SysConfig> {

	public SysConfig get(String id) {
		return super.get(id);
	}
	
	public List<SysConfig> findList(SysConfig sysConfig) {
		return super.findList(sysConfig);
	}
	
	public Page<SysConfig> findPage(Page<SysConfig> page, SysConfig sysConfig) {
		return super.findPage(page, sysConfig);
	}
	
	@Transactional(readOnly = false)
	public void save(SysConfig sysConfig) {
		if(sysConfig.getIsNewRecord()){
			
			sysConfig.preInsert();
			sysConfig.setId(UserUtils.getUser().getAccountId());
			dao.insert(sysConfig);
		}else{
			
			sysConfig.preUpdate();
			dao.update(sysConfig);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(SysConfig sysConfig) {
		super.delete(sysConfig);
	}
	
}