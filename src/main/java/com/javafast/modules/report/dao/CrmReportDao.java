package com.javafast.modules.report.dao;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.report.entity.CrmReport;

/**
 * 客户统计DAO接口
 * @author shi
 * @version 2016-06-28
 */
@MyBatisDao
public interface CrmReportDao {

	/**
	 * 综合统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findReportList(CrmReport crmReport);
	
	/**
	 * 客户统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findCustomerReportList(CrmReport crmReport);
	
	/**
	 * 业绩统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findAchReportList(CrmReport crmReport);
	
	/**
	 * 财务统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findFiReportList(CrmReport crmReport);
	
	/**
	 * 产品销售统计
	 * @param crmReport
	 * @return
	 */
	public List<CrmReport> findProductReportList(CrmReport crmReport);
	
	
	public CrmReport findCustomerReport(CrmReport crmReport);
}