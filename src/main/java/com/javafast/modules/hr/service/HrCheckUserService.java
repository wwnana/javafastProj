package com.javafast.modules.hr.service;

import com.alibaba.fastjson.JSON;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.service.ServiceException;
import com.javafast.modules.hr.api.WxCheckInAPI;
import com.javafast.modules.hr.api.WxRuleInfo;
import com.javafast.modules.hr.dao.HrCheckRuleDao;
import com.javafast.modules.hr.dao.HrCheckUserDao;
import com.javafast.modules.hr.entity.HrCheckRule;
import com.javafast.modules.hr.entity.HrCheckUser;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 打卡规则用户表Service
 *
 * @author javafast
 * @version 2018-07-08
 */
@Service
@Transactional(readOnly = true)
public class HrCheckUserService extends CrudService<HrCheckUserDao, HrCheckUser> {

    @Autowired
    private HrCheckUserDao hrCheckUserDao;

    public HrCheckUser get(String id) {
        return super.get(id);
    }

    @Transactional(readOnly = false)
    public void save(HrCheckUser hrCheckUser) {
        super.save(hrCheckUser);
    }
    @Transactional(readOnly = false)
    public void save(List<HrCheckUser> hrCheckUsers) {
        for (HrCheckUser hrCheckUser : hrCheckUsers) {
            super.save(hrCheckUser);
        }
    }



}