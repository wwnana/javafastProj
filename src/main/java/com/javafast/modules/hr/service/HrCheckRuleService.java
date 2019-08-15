package com.javafast.modules.hr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.service.ServiceException;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.hr.api.WxCheckData;
import com.javafast.modules.hr.api.WxCheckInAPI;
import com.javafast.modules.hr.api.WxRuleInfo;
import com.javafast.modules.hr.dao.HrCheckUserDao;
import com.javafast.modules.hr.dto.HrCheckRuleDTO;
import com.javafast.modules.hr.entity.HrCheckReport;
import com.javafast.modules.hr.entity.HrCheckUser;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.AccountUtils;
import com.javafast.modules.sys.utils.UserUtils;
import org.codehaus.groovy.tools.shell.CommandException;
import org.hibernate.validator.constraints.Length;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrCheckRule;
import com.javafast.modules.hr.dao.HrCheckRuleDao;

/**
 * 打卡规则表Service
 *
 * @author javafast
 * @version 2018-07-08
 */
@Service
@Transactional(readOnly = true)
public class HrCheckRuleService extends CrudService<HrCheckRuleDao, HrCheckRule> {

	@Autowired
    UserDao userDao;
	
    @Autowired
    private HrCheckRuleDao hrCheckRuleDao;
    @Autowired
    private HrCheckUserService hrCheckUserService;

    public HrCheckRule get(String id) {
        return super.get(id);
    }

    public List<HrCheckRule> findList(HrCheckRule hrCheckRule) {
        dataScopeFilter(hrCheckRule);//加入数据权限过滤
        return super.findList(hrCheckRule);
    }

    public Page<HrCheckRule> findPage(Page<HrCheckRule> page, HrCheckRule hrCheckRule) {
        dataScopeFilter(hrCheckRule);//加入数据权限过滤
        return super.findPage(page, hrCheckRule);
    }

    @Transactional(readOnly = false)
    public void save(HrCheckRule hrCheckRule) {
        super.save(hrCheckRule);
    }

    @Transactional(readOnly = false)
    public void delete(HrCheckRule hrCheckRule) {
        super.delete(hrCheckRule);
    }


    /**
     * 同步获得企业用户对应的规则信息
     *
     * @param hrCheckRule
     */
    @Transactional(readOnly = false, rollbackFor = {Exception.class})
    public void synchHrCheckRuleList(String accountId) {
        try {
            //参数从hrCheckRule获取，以下参数需要动态
            //获取accssToken
        	AccessToken accessToken = null;
            
            SysConfig sysConfig = AccountUtils.getSysConfig(accountId);
    		if(sysConfig != null && StringUtils.isNotBlank(sysConfig.getWxCorpid()) && StringUtils.isNotBlank(sysConfig.getCheckinSecret())){
    			accessToken = WxAccessTokenAPI.getAccessToken(sysConfig.getWxCorpid(), sysConfig.getCheckinSecret());
    		}
    		
    		 //用于记录当前企业的用户集合
            Map<String, User> userMap = new HashMap<String, User>();
    		
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
            
            //获取规则信息
            String returnString = WxCheckInAPI.getCheckInOption(accessToken.getAccessToken(), WxCheckInAPI.getTodayZeroUnixTime(), useridlist);
            logger.info(returnString);
            WxRuleInfo wxRuleInfo = JSON.parseObject(returnString, WxRuleInfo.class);
            if (wxRuleInfo.getErrcode() == 0) {
                //存规则与用户列表，腾讯传过来的规则会重复，所以根据groupId过滤
                Map<String, List<HrCheckUser>> userGroup = new HashMap<>();
                Map<String, HrCheckRule> ruleMap = new HashMap<>();
                List<WxRuleInfo.InfoBean> ruleInfo = wxRuleInfo.getInfo();
                for (WxRuleInfo.InfoBean infoBean : ruleInfo) {
                    String loginName = infoBean.getUserid();
                    //获取微信打卡规则信息
                    WxRuleInfo.InfoBean.GroupBean group = infoBean.getGroup();
                    Integer groupId = group.getGroupid();
                    List<HrCheckUser> listUser = null;
                    //已经存在的规则过滤
                    if (userGroup.containsKey(groupId.toString())) {
                        listUser = userGroup.get(groupId.toString());
                        HrCheckUser hrCheckUser = new HrCheckUser();
                        hrCheckUser.setCheckRuleId(groupId.toString());
                        hrCheckUser.setUserid(loginName);
                        listUser.add(hrCheckUser);
                        continue;
                    } else {
                        //新的规则，
                        listUser = new ArrayList<>();
                        HrCheckUser hrCheckUser = new HrCheckUser();
                        hrCheckUser.setCheckRuleId(groupId.toString());
                        hrCheckUser.setUserid(loginName);
                        listUser.add(hrCheckUser);
                    }
                    //存规则对应的用户列表
                    userGroup.put(groupId.toString(), listUser);
                    String groupName = group.getGroupname();
                    HrCheckRule rule = new HrCheckRule();
                    rule.setGroupId(group.getGroupid().toString());
                    rule.setGroupname(groupName);
                    rule.setNeedPhoto(group.isNeed_photo());
                    rule.setAllowCheckinOffworkday(group.isAllow_checkin_offworkday());
                    rule.setAllowApplyOffworkday(group.isAllow_apply_offworkday());
                    rule.setSyncHolidays(group.isSync_holidays());
                    List<WxRuleInfo.InfoBean.GroupBean.CheckindateBean> checkindate = group.getCheckindate();
                    for (WxRuleInfo.InfoBean.GroupBean.CheckindateBean checkindateBean : checkindate) {
                        rule.setWorkdays(JSON.toJSONString(checkindateBean.getWorkdays()));
                        rule.setLimitAheadtime(checkindateBean.getLimit_aheadtime());
                        rule.setFlexTime(checkindateBean.getFlex_time());
                        rule.setCheckintime(JSON.toJSONString(checkindateBean.getCheckintime()));
                        rule.setNoneedOffwork(checkindateBean.isNoneed_offwork());
                    }
                    rule.setLocInfos(JSON.toJSONString(group.getLoc_infos()));
                    rule.setSpeOffdays(JSON.toJSONString(group.getSpe_offdays()));
                    rule.setGroupType(group.getGrouptype().toString());
                    rule.setSpeWorkdays(JSON.toJSONString(group.getSpe_workdays()));
                    rule.setWifimacInfos(JSON.toJSONString(group.getWifimac_infos()));
                    rule.setNoteCanUseLocalPic(group.isNote_can_use_local_pic());
                    //存规则对应的明细信息
                    ruleMap.put(groupId.toString(), rule);

                }

                for (Map.Entry<String, List<HrCheckUser>> stringListEntry : userGroup.entrySet()) {
                    hrCheckUserService.save(stringListEntry.getValue());
                }
                
                //迭代打卡规则列表
                for (Map.Entry<String, HrCheckRule> stringHrCheckRuleEntry : ruleMap.entrySet()) {
                   
                	//打卡规则
                	HrCheckRule hrCheckRule = stringHrCheckRuleEntry.getValue();
                	String id = hrCheckRule.getGroupId() + accountId;
                	hrCheckRule.setId(id);
                	hrCheckRule.setAccountId(accountId);
                	int count=hrCheckRuleDao.getCount(hrCheckRule);
                	//判断是否已经存在
                	if(count==0){
                		dao.insert(hrCheckRule);
                	}else{
                		dao.update(hrCheckRule);
                	}
                	
                	//super.save(stringHrCheckRuleEntry.getValue());
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            throw new ServiceException("同步错误", e);
        }
    }

    public HrCheckRuleDTO detail(String id) {
        HrCheckRule rule = super.get(id);
        HrCheckRuleDTO dto = new HrCheckRuleDTO();
        ruleToDto(rule, dto);
        return dto;
    }

    private void ruleToDto(HrCheckRule rule,HrCheckRuleDTO dto){
        if (rule == null) {
            return ;
        }
        dto.setUserList(null);
        dto.setGroupid(Integer.valueOf(rule.getGroupId()));
        dto.setGroupname(rule.getGroupname());
        dto.setNeedPhoto(rule.getNeedPhoto());
        dto.setAllowApplyOffworkday(rule.getAllowApplyOffworkday());
        dto.setAllowCheckinOffworkday(rule.getAllowCheckinOffworkday());
        String checkTime = rule.getCheckintime();
        dto.setCheckintime(JSON.parseArray(checkTime, HrCheckRuleDTO.CheckintimeBean.class));
        dto.setWorkdays(JSON.parseArray(rule.getWorkdays(), Integer.class));
        dto.setLimitAheadtime(rule.getLimitAheadtime());
        dto.setGrouptype(rule.getGroupType());
        dto.setFlexTime(rule.getFlexTime());
        dto.setNoneedOffwork(rule.getNoneedOffwork());
        dto.setLocInfos(JSON.parseArray(rule.getLocInfos(), HrCheckRuleDTO.LocInfo.class));
        dto.setSpecOffDays(JSON.parseArray(rule.getSpeOffdays(), HrCheckRuleDTO.SpecDay.class));
        dto.setSpecWorkDays(JSON.parseArray(rule.getSpeWorkdays(), HrCheckRuleDTO.SpecDay.class));
        dto.setSyncHolidays(rule.getSyncHolidays());
        dto.setAllowCheckinOffworkday(rule.getAllowCheckinOffworkday());
        dto.setAllowApplyOffworkday(rule.getAllowApplyOffworkday());
        dto.setNoteCanUseLocalPic(rule.getNoteCanUseLocalPic());
        dto.setWifimacInfos(JSON.parseArray(rule.getWifimacInfos(), HrCheckRuleDTO.WifimacInfo.class));
    }

    public HrCheckRuleDTO getCheckRuleDetailByName(HrCheckRule checkRule) {
        if (StringUtils.isBlank(checkRule.getGroupname())) {
            //规则
            throw new ServiceException("0", "不能为空");
        }
        checkRule.setAccountId(UserUtils.getUser().getAccountId());
        HrCheckRule rule = hrCheckRuleDao.getCheckRuleDetailByName(checkRule);
        HrCheckRuleDTO dto = new HrCheckRuleDTO();
        ruleToDto(rule, dto);
        return dto;
    }
}