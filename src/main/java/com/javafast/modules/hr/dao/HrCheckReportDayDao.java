package com.javafast.modules.hr.dao;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrCheckReportDay;

/**
 * 每日打卡汇总DAO接口
 *
 * @author javafast
 * @version 2018-07-10
 */
@MyBatisDao
public interface HrCheckReportDayDao extends CrudDao<HrCheckReportDay> {
    /**
     * 删除日统计，排除当日已经审核通过的记录
     * @param hrCheckReportDay
     * @return
     */
    public int deleteByDateButNotAudit(HrCheckReportDay hrCheckReportDay);

    /**
     * 生成日统计，那些已经审核过的统计，将排除
     * @param hrCheckReportDay
     * @return
     */
    public int generateDayReportButNotAudit(HrCheckReportDay hrCheckReportDay);

    /***
     * 修改审核状态
     * @param hrCheckReportDay
     * @return
     */
    public int updateAuditStatusByOa(HrCheckReportDay hrCheckReportDay);

}