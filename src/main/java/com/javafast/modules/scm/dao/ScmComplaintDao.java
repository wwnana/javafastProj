/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.scm.dao;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.scm.entity.ScmComplaint;

/**
 * 客户投诉DAO接口
 * @author javafast
 * @version 2017-08-18
 */
@MyBatisDao
public interface ScmComplaintDao extends CrudDao<ScmComplaint> {
	
}