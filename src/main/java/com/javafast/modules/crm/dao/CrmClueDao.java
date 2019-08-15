package com.javafast.modules.crm.dao;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.crm.entity.CrmClue;

/**
 * 销售线索DAO接口
 * @author javafast
 * @version 2019-02-15
 */
@MyBatisDao
public interface CrmClueDao extends CrudDao<CrmClue> {
	
}