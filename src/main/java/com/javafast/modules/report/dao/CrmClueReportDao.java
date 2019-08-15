package com.javafast.modules.report.dao;

import java.util.List;

import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.report.entity.CrmChanceReport;
import com.javafast.modules.report.entity.CrmClueReport;

@MyBatisDao
public interface CrmClueReportDao {

	public CrmClueReport findClueReport(CrmClueReport crmClueReport);
}
