package com.javafast.modules.oa.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.oa.dao.OaWorkLogDao;
import com.javafast.modules.oa.entity.OaWorkLogRecord;
import com.javafast.modules.oa.entity.OaWorkLogRule;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.oa.dao.OaWorkLogRecordDao;
import com.javafast.modules.oa.dao.OaWorkLogRuleDao;

/**
 * 工作报告Service
 * @author javafast
 * @version 2018-05-03
 */
@Service
@Transactional(readOnly = true)
public class OaWorkLogService extends CrudService<OaWorkLogDao, OaWorkLog> {

	@Autowired
	private OaWorkLogRecordDao oaWorkLogRecordDao;
	
	@Autowired
	OaWorkLogRuleDao oaWorkLogRuleDao;
	
	public OaWorkLog get(String id) {
		OaWorkLog oaWorkLog = super.get(id);
		oaWorkLog.setOaWorkLogRecordList(oaWorkLogRecordDao.findList(new OaWorkLogRecord(oaWorkLog)));
		return oaWorkLog;
	}
	
	public List<OaWorkLog> findList(OaWorkLog oaWorkLog) {
		dataScopeFilter(oaWorkLog);//加入权限过滤
		return super.findList(oaWorkLog);
	}
	
	public Page<OaWorkLog> findPage(Page<OaWorkLog> page, OaWorkLog oaWorkLog) {
		dataScopeFilter(oaWorkLog);//加入权限过滤
		return super.findPage(page, oaWorkLog);
	}
	
	@Transactional(readOnly = false)
	public void save(OaWorkLog oaWorkLog) {
		super.save(oaWorkLog);
		
		//删除查阅人列表
		oaWorkLogRecordDao.delete(new OaWorkLogRecord(oaWorkLog));	
		
		//添加查阅人
		Map<String, String> hashMap = new HashMap<String, String>();		
		for (OaWorkLogRecord oaWorkLogRecord : oaWorkLog.getOaWorkLogRecordList()){
			oaWorkLogRecord.setOaWorkLog(oaWorkLog);
			oaWorkLogRecord.preInsert();
			oaWorkLogRecordDao.insert(oaWorkLogRecord);
			
			hashMap.put(oaWorkLogRecord.getUser().getId(), oaWorkLogRecord.getUser().getId());
		}
		
		//添加固定汇报对象
		OaWorkLogRule conOaWorkLogRule = new OaWorkLogRule();
		dataScopeFilter(conOaWorkLogRule);//加入权限过滤
		List<OaWorkLogRule> oaWorkLogRuleList = oaWorkLogRuleDao.findList(conOaWorkLogRule);
		for(int i=0; i<oaWorkLogRuleList.size(); i++){
			OaWorkLogRule oaWorkLogRule = oaWorkLogRuleList.get(i);
			
			if(!hashMap.containsKey(oaWorkLogRule.getUser().getId())){
				
				OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
				oaWorkLogRecord.setUser(oaWorkLogRule.getUser());
				oaWorkLogRecord.setOaWorkLog(oaWorkLog);
				oaWorkLogRecord.preInsert();
				oaWorkLogRecordDao.insert(oaWorkLogRecord);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaWorkLog oaWorkLog) {
		super.delete(oaWorkLog);
		oaWorkLogRecordDao.delete(new OaWorkLogRecord(oaWorkLog));
	}
	
	/**
	 * 更新查阅信息
	 * @param oaWorkLog
	 */
	@Transactional(readOnly = false)
	public void updateReadInfo(OaWorkLog oaWorkLog, User currentUser){
		
		OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
		oaWorkLogRecord.setOaWorkLog(oaWorkLog);
		oaWorkLogRecord.setUser(currentUser);
		oaWorkLogRecord.setReadFlag("1");
		oaWorkLogRecord.setReadDate(new Date());
		
		List<OaWorkLogRecord> oaWorkLogRecordList = oaWorkLogRecordDao.findList(oaWorkLogRecord);
		if(oaWorkLogRecordList == null || oaWorkLogRecordList.size() == 0){
			
			oaWorkLogRecord.preInsert();
			oaWorkLogRecordDao.insert(oaWorkLogRecord);
		}
	}
	
	/**
	 * 更新查阅评论
	 * @param oaWorkLog
	 */
	@Transactional(readOnly = false)
	public void updateReadNote(OaWorkLog oaWorkLog, String auditNotes){
		
		OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
		oaWorkLogRecord.setOaWorkLog(oaWorkLog);
		oaWorkLogRecord.setUser(UserUtils.getUser());
		oaWorkLogRecord.setReadFlag("1");
		oaWorkLogRecord.setReadDate(new Date());
		
		List<OaWorkLogRecord> oaWorkLogRecordList = oaWorkLogRecordDao.findList(oaWorkLogRecord);
		if(oaWorkLogRecordList != null && oaWorkLogRecordList.size() > 0){
			
			oaWorkLogRecord = oaWorkLogRecordList.get(0);
			oaWorkLogRecord.setAuditNotes(auditNotes);
			oaWorkLogRecord.preUpdate();
			oaWorkLogRecordDao.update(oaWorkLogRecord);
		}else{
			
			oaWorkLogRecord = oaWorkLogRecordList.get(0);
			oaWorkLogRecord.setAuditNotes(auditNotes);
			oaWorkLogRecord.preInsert();
			oaWorkLogRecordDao.insert(oaWorkLogRecord);
		}
	}
	
	@Transactional(readOnly = false)
	public void add(OaWorkLog oaWorkLog) {
		
		
		super.save(oaWorkLog);
	}
}