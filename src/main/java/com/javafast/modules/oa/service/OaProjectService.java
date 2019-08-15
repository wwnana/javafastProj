package com.javafast.modules.oa.service;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.dao.OaProjectDao;
import com.javafast.modules.oa.entity.OaProjectRecord;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.dao.OaProjectRecordDao;

/**
 * 项目Service
 * @author javafast
 * @version 2018-05-18
 */
@Service
@Transactional(readOnly = true)
public class OaProjectService extends CrudService<OaProjectDao, OaProject> {

	@Autowired
	private OaProjectRecordDao oaProjectRecordDao;
	
	public OaProject get(String id) {
		OaProject oaProject = super.get(id);
		oaProject.setOaProjectRecordList(oaProjectRecordDao.findList(new OaProjectRecord(oaProject)));
		return oaProject;
	}
	
	public List<OaProject> findList(OaProject oaProject) {
		dataScopeFilter(oaProject);//加入权限过滤
		return super.findList(oaProject);
	}
	
	public Page<OaProject> findPage(Page<OaProject> page, OaProject oaProject) {
		dataScopeFilter(oaProject);//加入权限过滤
		return super.findPage(page, oaProject);
	}
	
	@Transactional(readOnly = false)
	public void save(OaProject oaProject) {
		
		//文本域转码
		if (oaProject.getContent()!=null){
			oaProject.setContent(StringEscapeUtils.unescapeHtml4(oaProject.getContent()));
		}
		
		super.save(oaProject);
		
		oaProjectRecordDao.delete(new OaProjectRecord(oaProject));
		
		//把负责人加入明细
		OaProjectRecord ownByRecord = new OaProjectRecord();
		ownByRecord.setUser(oaProject.getOwnBy());
		ownByRecord.setReadFlag("0");
		ownByRecord.setOaProject(oaProject);
		ownByRecord.preInsert();
		oaProjectRecordDao.insert(ownByRecord);
		
		for (OaProjectRecord oaProjectRecord : oaProject.getOaProjectRecordList()){
			
			if(oaProject.getOwnBy().getId().equals(oaProjectRecord.getUser().getId())){
				continue;
			}
			
			oaProjectRecord.setOaProject(oaProject);
			oaProjectRecord.preInsert();
			oaProjectRecordDao.insert(oaProjectRecord);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaProject oaProject) {
		super.delete(oaProject);
		oaProjectRecordDao.delete(new OaProjectRecord(oaProject));
	}
	
	//更新任务抄送记录的阅读状态
	@Transactional(readOnly = false)
	public void updateReadFlag(OaProject oaProject) {
		
		OaProjectRecord oaProjectRecord = new OaProjectRecord(oaProject);
		
		oaProjectRecord.setUser(oaProjectRecord.getCurrentUser());
		oaProjectRecord.setReadDate(new Date());
		oaProjectRecord.setReadFlag("1");
		oaProjectRecordDao.update(oaProjectRecord);
	}
	
	/**
	 * 查询记录数
	 * @param oaProject
	 * @return
	 */
	public Long findCount(OaProject oaProject){
		return dao.findCount(oaProject);
	}
}