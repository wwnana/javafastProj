package com.javafast.modules.hr.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.hibernate.validator.constraints.Length;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.hr.entity.HrTemplate;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.hr.dao.HrTemplateDao;

/**
 * 模板Service
 * @author javafast
 * @version 2018-07-03
 */
@Service
@Transactional(readOnly = true)
public class HrTemplateService extends CrudService<HrTemplateDao, HrTemplate> {

	public HrTemplate get(String id) {
		return super.get(id);
	}
	
	public List<HrTemplate> findList(HrTemplate hrTemplate) {
		hrTemplate.getSqlMap().put("dsf", " AND (a.account_id='"+UserUtils.getUser().getAccountId()+"' OR a.account_id='0')");
		return super.findList(hrTemplate);
	}
	
	public Page<HrTemplate> findPage(Page<HrTemplate> page, HrTemplate hrTemplate) {
		hrTemplate.getSqlMap().put("dsf", " AND (a.account_id='"+UserUtils.getUser().getAccountId()+"' OR a.account_id='0')");
		return super.findPage(page, hrTemplate);
	}
	
	@Transactional(readOnly = false)
	public void save(HrTemplate hrTemplate) {
		//文本域转码
		if (hrTemplate.getContent()!=null){
			hrTemplate.setContent(StringEscapeUtils.unescapeHtml4(hrTemplate.getContent()));
		}
		super.save(hrTemplate);
	}
	
	@Transactional(readOnly = false)
	public void delete(HrTemplate hrTemplate) {
		super.delete(hrTemplate);
	}
	
}