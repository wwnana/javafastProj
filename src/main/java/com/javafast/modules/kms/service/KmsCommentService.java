package com.javafast.modules.kms.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.kms.entity.KmsComment;
import com.javafast.modules.kms.dao.KmsCommentDao;

/**
 * 文章评论Service
 * @author javafast
 * @version 2018-05-14
 */
@Service
@Transactional(readOnly = true)
public class KmsCommentService extends CrudService<KmsCommentDao, KmsComment> {

	public KmsComment get(String id) {
		return super.get(id);
	}
	
	public List<KmsComment> findList(KmsComment kmsComment) {
		return super.findList(kmsComment);
	}
	
	public Page<KmsComment> findPage(Page<KmsComment> page, KmsComment kmsComment) {
		return super.findPage(page, kmsComment);
	}
	
	@Transactional(readOnly = false)
	public void save(KmsComment kmsComment) {
		super.save(kmsComment);
	}
	
	@Transactional(readOnly = false)
	public void delete(KmsComment kmsComment) {
		super.delete(kmsComment);
	}
	
}