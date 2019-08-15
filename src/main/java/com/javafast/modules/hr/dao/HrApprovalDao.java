package com.javafast.modules.hr.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.hr.entity.HrApproval;

/**
 * 审批记录DAO接口
 * @author javafast
 * @version 2018-07-16
 */
@MyBatisDao
public interface HrApprovalDao extends CrudDao<HrApproval> {
	
}