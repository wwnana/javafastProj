package com.javafast.modules.hr.service;

import com.alibaba.fastjson.JSON;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.service.ServiceException;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.api.WxCheckData;
import com.javafast.modules.hr.api.WxCheckInAPI;
import com.javafast.modules.hr.dao.HrCheckReportDetailDao;
import com.javafast.modules.hr.entity.HrCheckReportDetail;
import com.javafast.modules.hr.entity.HrCheckRule;
import com.javafast.modules.qws.utils.WorkWechatUtils;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.AccountUtils;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 每日打卡明细Service
 *
 * @author javafast
 * @version 2018-07-09
 */
@Service
@Transactional(readOnly = true)
public class HrCheckReportDetailService extends CrudService<HrCheckReportDetailDao, HrCheckReportDetail> {
    @Autowired
    private HrCheckReportDetailDao hrCheckReportDetailDao;
    @Autowired
    UserDao userDao;
    @Autowired
    private HrCheckReportDayService hrCheckReportDayService;
    @Autowired
    private HrCheckReportService hrCheckReportService;

    @Autowired
    private HrCheckRuleService hrCheckRuleService;
    @Autowired
    private HrApprovalService hrApprovalService;


    public HrCheckReportDetail get(String id) {
        return super.get(id);
    }

    public List<HrCheckReportDetail> findList(HrCheckReportDetail hrCheckReportDetail) {
        dataScopeFilter(hrCheckReportDetail);//加入数据权限过滤
        return super.findList(hrCheckReportDetail);
    }

    public Page<HrCheckReportDetail> findPage(Page<HrCheckReportDetail> page, HrCheckReportDetail hrCheckReportDetail) {
        dataScopeFilter(hrCheckReportDetail);//加入数据权限过滤
        return super.findPage(page, hrCheckReportDetail);
    }

    @Transactional(readOnly = false)
    public void save(HrCheckReportDetail hrCheckReportDetail) {
        super.save(hrCheckReportDetail);
    }

    @Transactional(readOnly = false)
    public void delete(HrCheckReportDetail hrCheckReportDetail) {
        super.delete(hrCheckReportDetail);
    }

    /**
     * 获取企业每日打卡数据明细
     *
     * @param accountId
     */
    @Transactional(readOnly = false, rollbackFor = {Exception.class})
    public void synchCorpWechatCheckDetail(String accountId, Date startDate, Date endDate) {

        try {
            if (startDate == null) {
                startDate = DateUtils.getBeginDayOfMonth();
            }
            if (endDate == null) {
                endDate = DateUtils.getEndDayOfMonth();
            }

            //用于记录当前企业的用户集合
            Map<String, User> userMap = new HashMap<String, User>();

            //1.获取打卡数据参数
            Integer opencheckindatatype = 3;//全部打卡类型
            Long starttime = DateUtils.date2TimeStamp(startDate);//zhou开始时间          获取打卡记录的开始时间。Unix时间戳
            Long endtime = DateUtils.date2TimeStamp(endDate);//本zhou结束时间        获取打卡记录的结束时间。Unix时间戳

            //需要获取打卡数据的用户需要获取打卡记录的用户列表
            List<String> useridlist = new ArrayList<>();

            //需要获取打卡数据的用户
            User conUser = new User();
            //conUser.setLoginFlag("1");
            conUser.setBindWx("1");
            conUser.getSqlMap().put("dsf", " AND a.account_id='" + accountId + "' ");
            List<User> userList = userDao.findList(conUser);
            for (int i = 0; i < userList.size(); i++) {
                User user = userList.get(i);
                userMap.put(user.getUserId(), user);
                useridlist.add(user.getUserId());
            }

            //1.获取accssToken
            AccessToken accessToken = null;

            SysConfig sysConfig = AccountUtils.getSysConfig(accountId);
            if (sysConfig != null && StringUtils.isNotBlank(sysConfig.getWxCorpid()) && StringUtils.isNotBlank(sysConfig.getCheckinSecret())) {
                accessToken = WxAccessTokenAPI.getAccessToken(sysConfig.getWxCorpid(), sysConfig.getCheckinSecret());
            }

            if (accessToken != null) {

                //3.调用企业微信接口获取打卡数据
                String returnData = WxCheckInAPI.getCheckInData(accessToken.getAccessToken(), opencheckindatatype, starttime, endtime, useridlist);
                WxCheckData wxCheckData = JSON.parseObject(returnData, WxCheckData.class);

                logger.info(returnData);

                //4.返回结果
                List<WxCheckData.CheckindataBean> checkindatas = wxCheckData.getCheckindata();
                for (WxCheckData.CheckindataBean checkindata : checkindatas) {
                    HrCheckReportDetail detail = new HrCheckReportDetail();
                    detail.setGroupname(checkindata.getGroupname());
                    detail.setUserid(checkindata.getUserid());
                    detail.setCheckinType(checkindata.getCheckin_type());
                    detail.setExceptionType(checkindata.getException_type());
                    Date checkinDate = DateUtils.timeStamp2Date(Long.parseLong(checkindata.getCheckin_time() + ""));
                    //日期
                    detail.setSdate(checkinDate);
                    //checkin_time	如果异常为打卡异常，那么打卡时间应该设置为 空
                    if (!StringUtils.equals(HrCheckReportDetail.EXCEPTIONTYPE_NOCHECK, checkindata.getException_type())) {
                        detail.setCheckinTime(checkindata.getCheckin_time());
                        //time格式
                        detail.setCheckinDate(checkinDate);
                    } else {
                        detail.setCheckinDate(null);
                        detail.setCheckinTime(null);
                    }
                    detail.setLocationTitle(checkindata.getLocation_title());
                    detail.setLocationDetail(checkindata.getLocation_detail());
                    detail.setWifiname(checkindata.getWifiname());
                    detail.setWifimac(checkindata.getWifimac());
                    if (checkindata.getMediaids() != null && checkindata.getMediaids().size() > 0) {
                        detail.setMediaids(checkindata.getMediaids().get(0));
                    }

                    if (StringUtils.isNotBlank(checkindata.getException_type())) {
                        detail.setCheckinStatus("-1");//有异常
                    } else {
                        detail.setCheckinStatus("0");//正常
                    }

                    //set用户相关信息
                    User currentUser = userMap.get(checkindata.getUserid());
                    detail.setUser(currentUser);
                    detail.setOffice(currentUser.getOffice());
                    detail.setAccountId(currentUser.getAccountId());

                    //查询是否已经入库
                    detail.setId(checkindata.getCheckin_time() + checkindata.getUserid());
                    int count = hrCheckReportDetailDao.getCount(detail);
                    if (count > 0) {
                        //判断是否已经存在
                        //dao.update(detail);
                    } else {
                        dao.insert(detail);
                    }
                }
            }
            //调用接口生成-日 月统计

        } catch (Exception e) {
            logger.error(e.getMessage());
            throw new ServiceException("", e);
        }
    }

    /**
     * 手动触发同步打卡数据
     *
     * @param accountId
     */
    @Transactional(readOnly = false, rollbackFor = {Exception.class})
    public void synchCorpWechatCheckAll(String accountId, Date startDate, Date endDate) {
        try {

            //获取打卡规则
            hrCheckRuleService.synchHrCheckRuleList(accountId);
            //1.获取打卡明细
            this.synchCorpWechatCheckDetail(accountId, startDate, endDate);


            //2.日打卡汇总统计
            hrCheckReportDayService.generateDayReport(startDate, endDate, accountId, null);

            //3.获取审批数据，更新对应的日打卡校准
            hrApprovalService.getCorpWechatApprovalData(accountId, startDate, endDate);

            //4.月打卡汇总统计
            hrCheckReportService.generateMonthReport(startDate, endDate, accountId, null);


        } catch (Exception e) {
            logger.error(e.getMessage());
            throw new ServiceException("0", e.getMessage());
        }

    }


}