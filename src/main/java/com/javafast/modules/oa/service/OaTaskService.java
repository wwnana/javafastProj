package com.javafast.modules.oa.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.dao.OaTaskDao;
import com.javafast.modules.oa.entity.OaTaskRecord;
import com.javafast.modules.oa.dao.OaTaskRecordDao;
import com.javafast.modules.sys.entity.User;

/**
 * 任务Service
 * @author javafast
 * @version 2017-07-08
 */
@Service
@Transactional(readOnly = true)
public class OaTaskService extends CrudService<OaTaskDao, OaTask> {

	@Autowired
	private OaTaskRecordDao oaTaskRecordDao;
	
	public OaTask get(String id) {
		OaTask oaTask = super.get(id);
		oaTask.setOaTaskRecordList(oaTaskRecordDao.findList(new OaTaskRecord(oaTask)));
		return oaTask;
	}
	
	public List<OaTask> findList(OaTask oaTask) {
		
		dataScopeFilter(oaTask);//加入权限过滤
		return super.findList(oaTask);
	}
	
	public Page<OaTask> findPage(Page<OaTask> page, OaTask oaTask) {
		
		dataScopeFilter(oaTask);//加入权限过滤
		return super.findPage(page, oaTask);
	}
	
	@Transactional(readOnly = false)
	public void save(OaTask oaTask) {
		
		if("2".equals(oaTask.getStatus())){
			oaTask.setSchedule(100);
		}
		
		super.save(oaTask);
		
		//删除明细
		oaTaskRecordDao.delete(new OaTaskRecord(oaTask));
		
		//把负责人加入明细
		OaTaskRecord ownByRecord = new OaTaskRecord();
		ownByRecord.setUser(oaTask.getOwnBy());
		ownByRecord.setReadFlag("0");
		ownByRecord.setOaTask(oaTask);
		ownByRecord.preInsert();
		oaTaskRecordDao.insert(ownByRecord);
		
		//保存明细
		for (OaTaskRecord oaTaskRecord : oaTask.getOaTaskRecordList()){
//			if (oaTaskRecord.getId() == null){
//				continue;
//			}
			
			if(oaTask.getOwnBy().getId().equals(oaTaskRecord.getUser().getId())){
				continue;
			}
			
			if (StringUtils.isBlank(oaTaskRecord.getId())){
				oaTaskRecord.setOaTask(oaTask);
				oaTaskRecord.preInsert();
				oaTaskRecordDao.insert(oaTaskRecord);
			}
			
//			if (OaTaskRecord.DEL_FLAG_NORMAL.equals(oaTaskRecord.getDelFlag())){
//				if (StringUtils.isBlank(oaTaskRecord.getId())){
//					oaTaskRecord.setOaTask(oaTask);
//					oaTaskRecord.preInsert();
//					oaTaskRecordDao.insert(oaTaskRecord);
//				}else{
//					oaTaskRecord.preUpdate();
//					oaTaskRecordDao.update(oaTaskRecord);
//				}
//			}else{
//				oaTaskRecordDao.delete(oaTaskRecord);
//			}
		}
	}
	
	@Transactional(readOnly = false)
	public void update(OaTask oaTask) {
		super.save(oaTask);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaTask oaTask) {
		super.delete(oaTask);
		oaTaskRecordDao.delete(new OaTaskRecord(oaTask));
	}
	
	//更新任务抄送记录的阅读状态
	@Transactional(readOnly = false)
	public void updateReadFlag(OaTask oaTask) {
		
		OaTaskRecord oaTaskRecord = new OaTaskRecord(oaTask);
		
		oaTaskRecord.setUser(oaTaskRecord.getCurrentUser());
		oaTaskRecord.setReadDate(new Date());
		oaTaskRecord.setReadFlag("1");
		oaTaskRecordDao.update(oaTaskRecord);
	}
	
	/**
	 * 查询记录数
	 * @param oaTask
	 * @return
	 */
	public Long findCount(OaTask oaTask){
		return dao.findCount(oaTask);
	}
	
	/**
	 * 查询进度条比值%
	 * @param oaTask
	 * @return
	 */
	public int findSchedule(OaTask oaTask) {
		int proCount = dao.findProCount(oaTask);
		int proFinCount = dao.findProFinCount(oaTask);
		if(proFinCount==0 || proCount==0) {
			return 0;
		}
		return proFinCount*100/proCount;
	}
	
	public List<OaTask> findListFor(OaTask oaTask) {
		
		return super.findList(oaTask);
	}
}