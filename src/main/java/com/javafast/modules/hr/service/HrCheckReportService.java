package com.javafast.modules.hr.service;

import java.util.Date;
import java.util.List;

import com.javafast.common.service.ServiceException;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.dao.HrCheckReportDayDao;
import com.javafast.modules.hr.entity.HrCheckReportDay;
import com.javafast.modules.iim.utils.DateUtil;
import com.javafast.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.Office;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrCheckReport;
import com.javafast.modules.hr.dao.HrCheckReportDao;

/**
 * 月度打卡汇总Service
 *
 * @author javafast
 * @version 2018-07-09
 */
@Service
@Transactional(readOnly = true)
public class HrCheckReportService extends CrudService<HrCheckReportDao, HrCheckReport> {

    @Autowired
    private HrCheckReportDao hrCheckReportDao;

    public HrCheckReport get(String id) {
        return super.get(id);
    }

    public List<HrCheckReport> findList(HrCheckReport hrCheckReport) {
        dataScopeFilter(hrCheckReport);//加入数据权限过滤
        return super.findList(hrCheckReport);
    }

    public Page<HrCheckReport> findPage(Page<HrCheckReport> page, HrCheckReport hrCheckReport) {
        dataScopeFilter(hrCheckReport);//加入数据权限过滤
        return super.findPage(page, hrCheckReport);
    }

    @Transactional(readOnly = false)
    public void save(HrCheckReport hrCheckReport) {
        super.save(hrCheckReport);
    }

    @Transactional(readOnly = false)
    public void delete(HrCheckReport hrCheckReport) {
        super.delete(hrCheckReport);
    }

    //按日期重新生成月份考勤统计
    //传入参数：月份，企业ID
    //1.查询该企业 该月份是否已经生成了记录，生成了则更新
    //1.如果没有记录，则根据该企业下用户的日统计，汇总成月统计


    /**
     * 按日期重新生成月份考勤统计
     *
     * @param beginCheckinDate 开始时间
     * @param endCheckinDate   结束时间
     * @param accountId        企业ID
     * @param user
     */
    @Transactional(readOnly = false)
    public int generateMonthReport(Date beginCheckinDate, Date endCheckinDate, String accountId, String sysUserId) {

        //校验参数
        if (StringUtils.isBlank(accountId)) {
            throw new ServiceException("0", "缺少参数accountId");
        }
        //
        HrCheckReport hrCheckReport = new HrCheckReport();
        if (beginCheckinDate == null) {
            //当月开始时间
            beginCheckinDate = DateUtils.getBeginDayOfMonth();
        }
        //结束时间
        if (endCheckinDate == null) {
            //当月结束时间
            endCheckinDate = DateUtils.getEndDayOfMonth();
        }

        hrCheckReport.setBeginCheckinDate(beginCheckinDate);
        hrCheckReport.setEndCheckinDate(endCheckinDate);
        hrCheckReport.setAccountId(accountId);
        if (StringUtils.isNotBlank(sysUserId)) {
            hrCheckReport.setUser(new User(sysUserId));
        }
        return initMonthCheck(hrCheckReport);
    }

    private int initMonthCheck(HrCheckReport hrCheckReport) {
        try {
            //1.先删除当月统计
            int count = hrCheckReportDao.deleteByMonth(hrCheckReport);
            logger.info("删除accountId:{}月统计数量{}", hrCheckReport.getAccountId(), count);
            //2.生成月打卡统计报表

            count = hrCheckReportDao.generateMonthReport(hrCheckReport);
            logger.info("生成accountId:{}月统计数量{}", hrCheckReport.getAccountId(), count);
            return count;
        } catch (Exception e) {
            logger.error(e.getMessage());
            throw new ServiceException("0", "月考勤统计失败");
        }
    }

}