package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrCheckReportDay;
import com.javafast.modules.hr.entity.HrCheckRule;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.Office;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrCheckReport;

/**
 * 月度打卡汇总DAO接口
 * @author javafast
 * @version 2018-07-09
 */
@MyBatisDao
public interface HrCheckReportDao extends CrudDao<HrCheckReport> {

	//删除当月统计
    public int deleteByMonth(HrCheckReport hrCheckReport);

    //生成月打卡统计报表
    public int generateMonthReport(HrCheckReport hrCheckReport);


}