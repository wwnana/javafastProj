package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrCheckRule;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrCheckReportDetail;

/**
 * 每日打卡明细DAO接口
 * @author javafast
 * @version 2018-07-09
 */
@MyBatisDao
public interface HrCheckReportDetailDao extends CrudDao<HrCheckReportDetail> {
	
	public List<HrCheckReportDetail> findCheckUserList(HrCheckReportDetail hrCheckReportDetail);

	public int getCount(HrCheckReportDetail hrCheckReportDetail);
}