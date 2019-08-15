package com.javafast.modules.crm.service;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import java.io.UnsupportedEncodingException;
import java.util.Date;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.entity.Office;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.dao.CrmClueDao;

/**
 * 销售线索Service
 * @author javafast
 * @version 2019-02-15
 */
@Service
@Transactional(readOnly = true)
public class CrmClueService extends CrudService<CrmClueDao, CrmClue> {

	public CrmClue get(String id) {
		return super.get(id);
	}
	
	public List<CrmClue> findList(CrmClue crmClue) {
		dataScopeFilterOwnBy(crmClue);//加入权限过滤
		return super.findList(crmClue);
	}
	
	public Page<CrmClue> findPage(Page<CrmClue> page, CrmClue crmClue) {
		dataScopeFilterOwnBy(crmClue);//加入权限过滤
		return super.findPage(page, crmClue);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmClue crmClue) {
		
		//判断是否为公海销售线索
		crmClue.setIsPool("1");//没有指定负责人，属于公海销售线索
		if(crmClue.getOwnBy()!=null && StringUtils.isNotBlank(crmClue.getOwnBy().getId())){
			crmClue.setIsPool("0");
		}
		super.save(crmClue);
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmClue crmClue) {
		super.delete(crmClue);
	}
	
	public List<CrmClue> findCrmClueList(CrmClue crmClue) {
		return super.findList(crmClue);
	}
}