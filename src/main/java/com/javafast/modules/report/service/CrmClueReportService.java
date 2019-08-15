package com.javafast.modules.report.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.modules.report.dao.CrmChanceReportDao;
import com.javafast.modules.report.dao.CrmClueReportDao;
import com.javafast.modules.report.entity.CrmChanceReport;
import com.javafast.modules.report.entity.CrmClueReport;

@Service
@Transactional(readOnly = true)
public class CrmClueReportService {

	@Autowired
	CrmClueReportDao crmClueReportDao;
	
	public CrmClueReport findClueReport(CrmClueReport crmClueReport) {
		
		return crmClueReportDao.findClueReport(crmClueReport);
	}
}
