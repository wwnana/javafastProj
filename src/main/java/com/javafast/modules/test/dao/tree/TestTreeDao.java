package com.javafast.modules.test.dao.tree;

import com.javafast.common.persistence.TreeDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.tree.TestTree;

/**
 * 树结构(商品分类)DAO接口
 * @author javafast
 * @version 2018-07-30
 */
@MyBatisDao
public interface TestTreeDao extends TreeDao<TestTree> {
	
}