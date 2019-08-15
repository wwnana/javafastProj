package com.javafast.modules.report.dao;

import java.util.List;

import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.report.entity.HrReport;

@MyBatisDao
public interface HrReportDao {

	/**
	 * 综合统计
	 * @param hrReport
	 * @return
	 */
	public List<HrReport> findReport(HrReport hrReport);
}
