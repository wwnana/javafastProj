package com.javafast.modules.report.dao;

import java.util.List;

import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.report.entity.CrmChanceReport;

@MyBatisDao
public interface CrmChanceReportDao {

	public List<CrmChanceReport> findChanceReportList(CrmChanceReport crmChanceReport);
	
	/**
	 * 单个企业各销售阶段数
	 * @param crmChanceReport
	 * @return
	 */
	public CrmChanceReport findChanceReport(CrmChanceReport crmChanceReport);
	
	/**
	 * 单个企业各销售阶段总额 
	 * @param crmChanceReport
	 * @return
	 */
	public CrmChanceReport findChanceAmountReport(CrmChanceReport crmChanceReport);
}
