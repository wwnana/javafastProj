package com.javafast.modules.hr.service;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.AccountUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.qywx.audit.api.WxApprovalAPI;
import com.javafast.api.qywx.audit.entity.WxApproval;
import com.javafast.api.qywx.audit.entity.WxApproval.DataBean;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.hr.entity.HrApproval;
import com.javafast.modules.hr.dao.HrApprovalDao;

/**
 * 审批记录Service
 *
 * @author javafast
 * @version 2018-07-16
 */
@Service
@Transactional(readOnly = true)
public class HrApprovalService extends CrudService<HrApprovalDao, HrApproval> {

    @Autowired
    UserDao userDao;

    @Autowired
    HrCheckReportDayService hrCheckReportDayService;

    public HrApproval get(String id) {
        return super.get(id);
    }

    public List<HrApproval> findList(HrApproval hrApproval) {
        dataScopeFilter(hrApproval);//加入数据权限过滤
        return super.findList(hrApproval);
    }

    public Page<HrApproval> findPage(Page<HrApproval> page, HrApproval hrApproval) {
        dataScopeFilter(hrApproval);//加入数据权限过滤
        return super.findPage(page, hrApproval);
    }

    @Transactional(readOnly = false)
    public void save(HrApproval hrApproval) {
        super.save(hrApproval);
    }

    @Transactional(readOnly = false)
    public void delete(HrApproval hrApproval) {
        super.delete(hrApproval);
    }

    /**
     * 获取企业微信审批数据
     *
     * @param accountId
     */
    @Transactional(readOnly = false)
    public void getCorpWechatApprovalData(String accountId, Date startDate, Date endDate) {

        //1.获取当月审批数据
        Long starttime = DateUtils.date2TimeStamp(DateUtils.getBeginDayOfYesterday());// 获取审批记录的开始时间。Unix时间戳
        if (startDate != null) {
            starttime = DateUtils.date2TimeStamp(startDate);
        }
        Long endtime = DateUtils.date2TimeStamp(new Date());// 获取审批记录的结束时间。Unix时间戳
        if(endDate!=null){
            endtime =DateUtils.date2TimeStamp(endDate);
        }

        SysConfig sysConfig = AccountUtils.getSysConfig(accountId);
        if (sysConfig != null && StringUtils.isNotBlank(sysConfig.getWxCorpid()) && StringUtils.isNotBlank(sysConfig.getApprovalSecret())) {

            //通过审批应用的Secret获取accssToken
            AccessToken accessToken = WxAccessTokenAPI.getAccessToken(sysConfig.getWxCorpid(), sysConfig.getApprovalSecret());
            if (accessToken != null) {

                WxApproval wxApproval = WxApprovalAPI.getApprovalData(accessToken.getAccessToken(), starttime, endtime);

                //2.解析审批数据
                if (wxApproval != null) {
                    for (DataBean dataBean : wxApproval.getData()) {

                        HrApproval hrApproval = new HrApproval();
                        hrApproval.setName(dataBean.getSpname());
                        hrApproval.setApplyName(dataBean.getApply_name());
                        hrApproval.setSpStatus(dataBean.getSp_status());
                        hrApproval.setSpNum(dataBean.getSp_num() + "");
                        hrApproval.setApplyTime(DateUtils.timeStamp2Date(Long.parseLong(dataBean.getApply_time() + "")));

                        //获取对应的本地用户
                        User user = null;
                        User conUser = new User();
                        conUser.getSqlMap().put("dsf", " AND a.user_id ='" + dataBean.getApply_user_id() + "' AND a.account_id='" + accountId + "' ");
                        List<User> userList = userDao.findList(conUser);
                        if (userList != null && userList.size() == 1) {
                            user = userList.get(0);
                            hrApproval.setUser(user);
                            hrApproval.setOffice(user.getOffice());
                        }

                        //审批人
                        String approvalName = "";
                        if (dataBean.getApply_name() != null) {
                            for (String name : dataBean.getApproval_name()) {
                                approvalName += name + ",";
                            }
                        }
                        hrApproval.setApprovalName(approvalName);

                        //抄送人
                        String notifyName = "";
                        if (dataBean.getNotify_name() != null) {
                            for (String name : dataBean.getNotify_name()) {
                                notifyName += name + ",";
                            }
                        }
                        hrApproval.setNotifyName(notifyName);
                        
                        // 审批类型   1请假、2报销、3费用、4出差、5采购、6加班、7外出、8用章、9付款、10用车、11绩效、20打卡补卡                        
                        if("请假".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("1");
                            if (dataBean.getLeave() != null) {
                                hrApproval.setLeaveTimeunit(dataBean.getLeave().getTimeunit());
                                hrApproval.setLeaveType(dataBean.getLeave().getLeave_type());
                                hrApproval.setLeaveStartTime(DateUtils.timeStamp2Date(Long.parseLong(dataBean.getLeave().getStart_time() + "")));
                                hrApproval.setLeaveEndTime(DateUtils.timeStamp2Date(Long.parseLong(dataBean.getLeave().getEnd_time() + "")));
                                hrApproval.setLeaveDuration(dataBean.getLeave().getDuration());
                                hrApproval.setLeaveReason(dataBean.getLeave().getReason());
                            }
                        }
                        
                        if("报销".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("2");
                            if (dataBean.getExpense() != null) {
                               
                                hrApproval.setExpenseType(dataBean.getExpense().getExpense_type());
                                hrApproval.setExpenseReason(dataBean.getExpense().getReason());
                            }
                        }
                        
                        if("出差".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("4");	
                        }
                        
                        if("加班".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("6");	
                        }
                        
                        if("打卡补卡".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("20");	
                        }
                        
                        if("外出".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("7");	
                        }
                        
                        if("费用".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("3");	
                        }
                        
                        if("采购".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("5");	
                        }
                        
                        if("用章".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("8");	
                        }
                        
                        if("用车".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("10");	
                        }
                        
                        if("绩效".equals(dataBean.getSpname())){
                        	hrApproval.setApprovalType("11");	
                        }

                        //审批模板信息
                        if (dataBean.getComm() != null) {
                            String applyData = dataBean.getComm().getApply_data();
                            hrApproval.setApplyData(applyData);

                            //继续解析
							JSONObject applyDataObject = JSON.parseObject(applyData);

                            //时长
							if(applyDataObject.containsKey("duration")){
								JSONObject durationObject = applyDataObject.getJSONObject("duration");
								int duration= durationObject.getInteger("setvalue");//单位：秒
								int durationDay= durationObject.getInteger("durationDay");//单位：天
								int durationHour= durationObject.getInteger("durationHour");//单位：小时 不一定有值
								hrApproval.setDuration(duration);
							}
							if(applyDataObject.containsKey("begin_time")){
								//开始时间
								JSONObject beginTimeObject = applyDataObject.getJSONObject("begin_time");								
								String value = beginTimeObject.getString("value");
								Date date = new Date(Long.parseLong(value));
								hrApproval.setBeginTime(date);
							}
							
							if(applyDataObject.containsKey("end_time")){
								//结束时间
								JSONObject endTimeObject = applyDataObject.getJSONObject("end_time");								
								String value = endTimeObject.getString("value");
								Date date = new Date(Long.parseLong(value));
								hrApproval.setEndTime(date);
							}
							
                            //打卡补卡
							if(applyDataObject.containsKey("applyBK")){
								hrApproval.setApprovalType("20");// 审批类型   1请假、2报销、3费用、4出差、5采购、6加班、7外出、8用章、9付款、10用车、11绩效、20打卡补卡 
								
								//补卡时间
								JSONObject checkinTimeObject = applyDataObject.getJSONObject("checkin-time");								
								String value = checkinTimeObject.getString("value");
								Date date = new Date(Long.parseLong(value));
								hrApproval.setBkCheckinTime(date);
							}
                        }

                        //3.保存入库
                        hrApproval.setId(dataBean.getSp_num() + "");
                        hrApproval.setAccountId(accountId);

                        //检查本地是否已经拉取过该记录
                        HrApproval tempHrApproval = dao.get(hrApproval.getId());
                        if (tempHrApproval != null) {
                            //更新
                            dao.update(hrApproval);
                        } else {
                            //新增
                            hrApproval.setAccountId(accountId);
                            dao.insert(hrApproval);
                        }

                        //4.审批同步到打卡记录
                        if (hrApproval.getSpStatus() == 2) {//审批状态2 已通过

                            //哪些审批模版支持数据同步到打卡记录？目前仅官方提供的【请假】、【出差】、【外出】、【加班】、【打卡补卡】支持
                            if ("1".equals(hrApproval.getApprovalType()) || "4".equals(hrApproval.getApprovalType()) || "6".equals(hrApproval.getApprovalType()) || "7".equals(hrApproval.getApprovalType()) || "20".equals(hrApproval.getApprovalType())) {

                                //审批模版支持数据同步到打卡记录
                                hrCheckReportDayService.updateDayReportByApproval(hrApproval);
                            }
                        }
                    }
                }
            }
        }
    }
}