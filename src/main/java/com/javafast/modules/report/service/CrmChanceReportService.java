package com.javafast.modules.report.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.modules.report.dao.CrmChanceReportDao;
import com.javafast.modules.report.entity.CrmChanceReport;

@Service
@Transactional(readOnly = true)
public class CrmChanceReportService {

	@Autowired
	CrmChanceReportDao crmChanceReportDao;
	
	/**
	 * 单个企业各销售阶段数
	 * @param crmChanceReport
	 * @return
	 */
	public CrmChanceReport findChanceReport(CrmChanceReport crmChanceReport) {
		return crmChanceReportDao.findChanceReport(crmChanceReport);
	}
	
	/**
	 * 单个企业各销售阶段总额 
	 * @param crmChanceReport
	 * @return
	 */
	public CrmChanceReport findChanceAmountReport(CrmChanceReport crmChanceReport) {
		return crmChanceReportDao.findChanceAmountReport(crmChanceReport);
	}
}
