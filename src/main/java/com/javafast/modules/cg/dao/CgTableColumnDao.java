/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.cg.dao;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.cg.entity.CgTableColumn;

/**
 * 表单设计DAO接口
 * @author javafast
 * @version 2018-04-21
 */
@MyBatisDao
public interface CgTableColumnDao extends CrudDao<CgTableColumn> {
	
}