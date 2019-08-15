/**
 * Copyright &copy; 2016-2020 <a href="http://www.javafast.cn">JavaFast</a> All rights reserved.
 */
package com.javafast.modules.kms.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.service.TreeService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.kms.entity.KmsCategory;
import com.javafast.modules.kms.dao.KmsCategoryDao;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 知识分类Service
 * @author javafast
 * @version 2017-08-03
 */
@Service
@Transactional(readOnly = true)
public class KmsCategoryService extends TreeService<KmsCategoryDao, KmsCategory> {

	public KmsCategory get(String id) {
		return super.get(id);
	}
	
	public List<KmsCategory> findList(KmsCategory kmsCategory) {
		
		dataScopeFilter(kmsCategory);//加入数据权限过滤
				
		if (StringUtils.isNotBlank(kmsCategory.getParentIds())){
			kmsCategory.setParentIds(","+kmsCategory.getParentIds()+",");
		}
		return super.findList(kmsCategory);
	}
	
	@Transactional(readOnly = false)
	public void save(KmsCategory kmsCategory) {
		super.save(kmsCategory);
	}
	
	@Transactional(readOnly = false)
	public void delete(KmsCategory kmsCategory) {
		super.delete(kmsCategory);
	}
	
}