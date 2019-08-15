package com.javafast.modules.report.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.modules.report.dao.SysSearchDao;
import com.javafast.modules.report.entity.SysSearch;

@Service
@Transactional(readOnly = true)
public class SysSearchService {

	@Autowired
	SysSearchDao sysSearchDao;
	
	public Page<SysSearch> findPage(Page<SysSearch> page, SysSearch sysSearch) {
		
		sysSearch.setPage(page);
		page.setList(sysSearchDao.findList(sysSearch));
		return page;
	}
}
