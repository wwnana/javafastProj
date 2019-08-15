package com.javafast.modules.test.dao.one;

import org.hibernate.validator.constraints.Length;
import com.javafast.modules.test.entity.tree.TestTree;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.one.TestOne;

/**
 * 商品信息(单表)DAO接口
 * @author javafast
 * @version 2018-07-30
 */
@MyBatisDao
public interface TestOneDao extends CrudDao<TestOne> {
	
}