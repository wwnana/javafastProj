package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmService;

/**
 * 服务工单DAO接口
 * @author javafast
 * @version 2019-03-28
 */
@MyBatisDao
public interface CrmServiceDao extends CrudDao<CrmService> {
	
}