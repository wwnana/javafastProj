package com.javafast.modules.oa.service;

import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaTopic;
import com.javafast.modules.oa.dao.OaTopicDao;
import com.javafast.modules.oa.entity.OaTopicRecord;
import com.javafast.modules.oa.dao.OaTopicRecordDao;

/**
 * 话题Service
 * @author javafast
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class OaTopicService extends CrudService<OaTopicDao, OaTopic> {

	@Autowired
	private OaTopicRecordDao oaTopicRecordDao;
	
	public OaTopic get(String id) {
		OaTopic oaTopic = super.get(id);
		oaTopic.setOaTopicRecordList(oaTopicRecordDao.findList(new OaTopicRecord(oaTopic)));
		return oaTopic;
	}
	
	public List<OaTopic> findList(OaTopic oaTopic) {
		dataScopeFilter(oaTopic);//加入权限过滤
		return super.findList(oaTopic);
	}
	
	public Page<OaTopic> findPage(Page<OaTopic> page, OaTopic oaTopic) {
		dataScopeFilter(oaTopic);//加入权限过滤
		return super.findPage(page, oaTopic);
	}
	
	@Transactional(readOnly = false)
	public void save(OaTopic oaTopic) {
		//文本域转码
		if (oaTopic.getContent()!=null){
			oaTopic.setContent(StringEscapeUtils.unescapeHtml4(oaTopic.getContent()));
		}
		
		super.save(oaTopic);
//		for (OaTopicRecord oaTopicRecord : oaTopic.getOaTopicRecordList()){
//			if (oaTopicRecord.getId() == null){
//				continue;
//			}
//			if (OaTopicRecord.DEL_FLAG_NORMAL.equals(oaTopicRecord.getDelFlag())){
//				if (StringUtils.isBlank(oaTopicRecord.getId())){
//					oaTopicRecord.setOaTopic(oaTopic);
//					oaTopicRecord.preInsert();
//					oaTopicRecordDao.insert(oaTopicRecord);
//				}else{
//					oaTopicRecord.preUpdate();
//					oaTopicRecordDao.update(oaTopicRecord);
//				}
//			}else{
//				oaTopicRecordDao.delete(oaTopicRecord);
//			}
//		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaTopic oaTopic) {
		super.delete(oaTopic);
		oaTopicRecordDao.delete(new OaTopicRecord(oaTopic));
	}
	
	@Transactional(readOnly = false)
	public void saveOaTopicRecord(OaTopicRecord oaTopicRecord){
		oaTopicRecord.preInsert();
		oaTopicRecordDao.insert(oaTopicRecord);
	}
	
	@Transactional(readOnly = false)
	public void deleteOaTopicRecord(OaTopicRecord oaTopicRecord) {
		oaTopicRecordDao.delete(oaTopicRecord);
	}
	
	@Transactional(readOnly = false)
	public void thumbOaTopicRecord(OaTopicRecord oaTopicRecord){
		
		oaTopicRecord = oaTopicRecordDao.get(oaTopicRecord.getId());
		if(oaTopicRecord.getThumbs() == null){
			oaTopicRecord.setThumbs(0);
		}
		oaTopicRecord.setThumbs(oaTopicRecord.getThumbs() + 1);
		oaTopicRecordDao.update(oaTopicRecord);
	}
}