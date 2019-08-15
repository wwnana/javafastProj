package com.javafast.modules.report.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.utils.DateUtils;
import com.javafast.modules.report.dao.HrReportDao;
import com.javafast.modules.report.entity.HrReport;

/**
 * HR统计Service
 * @author shi
 * @version 2016-06-28
 */
@Service
@Transactional(readOnly = true)
public class HrReportService {

	@Autowired
	HrReportDao hrReportDao;

	/**
	 * 获取本月综合统计
	 * @param accountId
	 * @return
	 */
	public HrReport getReport(HrReport hrReport){
		
		List<HrReport> list = hrReportDao.findReport(hrReport);
		if(list != null && list.size()>0){
			return list.get(0);
		}
		return null;
	}
	
	public List<HrReport> findReport(HrReport hrReport){
		return hrReportDao.findReport(hrReport);
	}
}