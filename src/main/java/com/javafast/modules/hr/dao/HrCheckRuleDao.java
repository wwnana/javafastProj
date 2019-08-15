package com.javafast.modules.hr.dao;

import com.javafast.modules.hr.entity.HrCheckReport;
import org.hibernate.validator.constraints.Length;

import java.util.List;

import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrCheckRule;

/**
 * 打卡规则表DAO接口
 *
 * @author javafast
 * @version 2018-07-08
 */
@MyBatisDao
public interface HrCheckRuleDao extends CrudDao<HrCheckRule> {

    public HrCheckRule getCheckRuleDetailByName(HrCheckRule hrCheckRule);


    public int getCount(HrCheckRule hrCheckRule);
}