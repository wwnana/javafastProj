package com.javafast.modules.oa.service;

import java.util.Date;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.modules.oa.dao.OaNotifyDao;
import com.javafast.modules.oa.dao.OaNotifyRecordDao;
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.entity.OaNotifyRecord;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 通知通告Service
 */
@Service
@Transactional(readOnly = true)
public class OaNotifyService extends CrudService<OaNotifyDao, OaNotify> {

	@Autowired
	private OaNotifyRecordDao oaNotifyRecordDao;
	
	@Autowired
	UserDao userDao;

	public OaNotify get(String id) {
		OaNotify entity = dao.get(id);
		return entity;
	}
	
	/**
	 * 获取通知发送记录
	 * @param oaNotify
	 * @return
	 */
	public OaNotify getRecordList(OaNotify oaNotify) {
		oaNotify.setOaNotifyRecordList(oaNotifyRecordDao.findList(new OaNotifyRecord(oaNotify)));
		return oaNotify;
	}
	
	public Page<OaNotify> find(Page<OaNotify> page, OaNotify oaNotify) {
		dataScopeFilter(oaNotify);//加入权限过滤
		oaNotify.setPage(page);
		page.setList(dao.findList(oaNotify));
		return page;
	}
	
	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify) {
		return dao.findCount(oaNotify);
	}
	
	@Transactional(readOnly = false)
	public void save(OaNotify oaNotify) {
		
		//文本域转码
		if (oaNotify.getContent()!=null){
			oaNotify.setContent(StringEscapeUtils.unescapeHtml4(oaNotify.getContent()));
		}
		
		super.save(oaNotify);
		
		// 更新发送接受人记录
		oaNotifyRecordDao.deleteByOaNotifyId(oaNotify.getId());
		if (oaNotify.getOaNotifyRecordList().size() > 0){
			oaNotifyRecordDao.insertAll(oaNotify.getOaNotifyRecordList());
		}
	}
	
	@Transactional(readOnly = false)
	public void update(OaNotify oaNotify) {
		
		//文本域转码
		if (oaNotify.getContent()!=null){
			oaNotify.setContent(StringEscapeUtils.unescapeHtml4(oaNotify.getContent()));
		}
		
		super.save(oaNotify);
	}
	
	/**
	 * 更新阅读状态
	 */
	@Transactional(readOnly = false)
	public void updateReadFlag(OaNotify oaNotify, User currentUser) {
		OaNotifyRecord oaNotifyRecord = new OaNotifyRecord(oaNotify);
		oaNotifyRecord.setUser(currentUser);
		oaNotifyRecord.setReadDate(new Date());
		oaNotifyRecord.setReadFlag("1");
		oaNotifyRecordDao.update(oaNotifyRecord);
	}
	
	//获取手机网址
	private static final String mobileRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/mobile/oa/oaNotify/view";
		
	/**
	 * 企业微信通知提醒
	 * @param oaNotify
	 */
	@Transactional(readOnly = false)
	public void sendWxMsg(OaNotify oaNotify){
		
		for(int i=0;i<oaNotify.getOaNotifyRecordList().size();i++){
			
			OaNotifyRecord oaNotifyRecord = oaNotify.getOaNotifyRecordList().get(i);
						
			User user = userDao.get(oaNotifyRecord.getUser().getId());
			WorkWechatMsgUtils.sendMsg(user.getUserId(), "公告提醒："+oaNotify.getCreateBy().getName()+"发起了公告：<a href=\""+mobileRequestUrl+"?id="+oaNotify.getId()+"\">"+oaNotify.getTitle()+"</a> ，点击查看", UserUtils.getUser().getAccountId());
		}
	}
	
	/**
	 * 
	 * @param page
	 * @param oaNotify
	 * @return
	 */
	public Page<OaNotify> findPageByUser(Page<OaNotify> page, OaNotify oaNotify) {
		oaNotify.setPage(page);
		page.setList(dao.findListByUser(oaNotify));
		return page;
	}
	
	public OaNotify getById(String id){
		return dao.getById(id);
	}
}