/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.kms.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.kms.entity.KmsArticle;
import com.javafast.modules.kms.entity.KmsArticleData;
import com.javafast.modules.kms.entity.KmsComment;
import com.javafast.modules.kms.dao.KmsArticleDao;
import com.javafast.modules.kms.dao.KmsArticleDataDao;
import com.javafast.modules.kms.dao.KmsCommentDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 文章Service
 * @author javafast
 * @version 2017-08-03
 */
@Service
@Transactional(readOnly = true)
public class KmsArticleService extends CrudService<KmsArticleDao, KmsArticle> {

	@Autowired
	KmsArticleDataDao kmsArticleDataDao;
	
	@Autowired
	KmsCommentDao kmsCommentDao;
	
	public KmsArticle get(String id) {
		KmsArticle kmsArticle = super.get(id);
		kmsArticle.setArticleData(kmsArticleDataDao.get(id));
		KmsComment kmsComment = new KmsComment();
		kmsComment.setArticleId(id);
		kmsArticle.setCommentList(kmsCommentDao.findList(kmsComment));
		return kmsArticle;
	}
	
	public List<KmsArticle> findList(KmsArticle kmsArticle) {
		dataScopeFilter(kmsArticle);//加入数据权限过滤
		return super.findList(kmsArticle);
	}
	
	public Page<KmsArticle> findPage(Page<KmsArticle> page, KmsArticle kmsArticle) {
		dataScopeFilter(kmsArticle);//加入数据权限过滤
		return super.findPage(page, kmsArticle);
	}
	
	@Transactional(readOnly = false)
	public void save(KmsArticle kmsArticle) {
		
		boolean isNew = kmsArticle.getIsNewRecord();
		
		super.save(kmsArticle);
		
		KmsArticleData kmsArticleData = kmsArticle.getArticleData();
		
		//文本域转码
		if (StringUtils.isNotBlank(kmsArticleData.getContent())){
			kmsArticleData.setContent(StringEscapeUtils.unescapeHtml4(kmsArticleData.getContent()));
		}		
		
		if(isNew){
			kmsArticleData.setId(kmsArticle.getId());
			kmsArticleDataDao.insert(kmsArticleData);
		}else{
			kmsArticleDataDao.update(kmsArticleData);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(KmsArticle kmsArticle) {
		super.delete(kmsArticle);
	}
	
	@Transactional(readOnly = false)
	public void audit(KmsArticle kmsArticle) {
		kmsArticle.setStatus("1");
		super.save(kmsArticle);
	}
	
	@Transactional(readOnly = false)
	public void unAudit(KmsArticle kmsArticle) {
		kmsArticle.setStatus("0");
		super.save(kmsArticle);
	}
}