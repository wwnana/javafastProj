package com.javafast.modules.kms.dao;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.kms.entity.KmsComment;

/**
 * 知识评论DAO接口
 * @author javafast
 * @version 2018-05-14
 */
@MyBatisDao
public interface KmsCommentDao extends CrudDao<KmsComment> {
	
}