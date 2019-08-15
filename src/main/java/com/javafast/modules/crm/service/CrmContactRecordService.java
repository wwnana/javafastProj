package com.javafast.modules.crm.service;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.crm.dao.CrmContactRecordDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;

/**
 * 跟进记录Service
 */
@Service
@Transactional(readOnly = true)
public class CrmContactRecordService extends CrudService<CrmContactRecordDao, CrmContactRecord> {

	@Autowired
	UserDao userDao;
	
	@Autowired
	CrmCustomerDao crmCustomerDao;
	
	public CrmContactRecord get(String id) {
		return super.get(id);
	}
	
	public List<CrmContactRecord> findListByTargetId(CrmContactRecord crmContactRecord) {
		return super.findList(crmContactRecord);
	}
	
	public List<CrmContactRecord> findList(CrmContactRecord crmContactRecord) {
		dataScopeFilterOwnBy(crmContactRecord);//加入权限过滤
		return super.findList(crmContactRecord);
	}
	
	public Page<CrmContactRecord> findPage(Page<CrmContactRecord> page, CrmContactRecord crmContactRecord) {
		dataScopeFilterOwnBy(crmContactRecord);//加入权限过滤
		return super.findPage(page, crmContactRecord);
	}
	
	@Transactional(readOnly = false)
	public void save(CrmContactRecord crmContactRecord) {
		crmContactRecord.setOwnBy(UserUtils.getUser());
		super.save(crmContactRecord);
		
		//如果是客户的话，更新客户更进时间
		if(crmContactRecord.getTargetType().equals(Contants.OBJECT_CRM_TYPE_CUSTOMER)) {
			//更新客户状态
			CrmCustomer crmCustomer = crmCustomerDao.get(crmContactRecord.getTargetId());
			if(crmCustomer != null) {
				crmCustomer.preUpdate();
				crmCustomerDao.updateStatus(crmCustomer);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmContactRecord crmContactRecord) {
		super.delete(crmContactRecord);
	}
	
	/**
	 * 查询记录数
	 * @param crmContactRecord
	 * @return
	 */
	public Long findCount(CrmContactRecord crmContactRecord){
		return dao.findCount(crmContactRecord);
	}
	
	/**
	 * 查询客户的所有跟进记录
	 * @param crmContactRecord
	 * @return
	 */
	public List<CrmContactRecord> findListByCustomer(CrmContactRecord crmContactRecord) {
		//dataScopeFilter(crmContactRecord);//加入数据权限过滤
		return super.findList(crmContactRecord);
	}
	
	//获取手机网址
	private static final String mobileRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/mobile/crm/crmContactRecord/view";
	
	/**
	 * 获取所有当日需联系的客户，发送企业微信消息提醒
	 */
//	@Transactional(readOnly = false)
//	public void remindNeedContactRecord(){
//		CrmContactRecord crmContactRecord = new CrmContactRecord();
//		crmContactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CUSTOMER);
//		crmContactRecord.setBeginContactDate(DateUtils.getDayBegin());
//		crmContactRecord.setEndContactDate(DateUtils.getDayEnd());
//		List<CrmContactRecord> crmContactRecordList = dao.findList(crmContactRecord);
//		for(int i=0;i<crmContactRecordList.size();i++){
//			
//			CrmContactRecord contactRecord = crmContactRecordList.get(i);
//			
//			User user = userDao.get(contactRecord.getCreateBy());
//			if(StringUtils.isNotBlank(user.getUserId())){
//				
//				String content = "客户跟进提醒：<a href=\""+mobileRequestUrl+"?id="+contactRecord.getId()+"\">"+contactRecord.getTargetName()+"</a> 需今日跟进，点击查看";
//				System.out.println(content);
//				WorkWechatMsgUtils.sendMsg(user.getUserId(), content, user.getAccountId());
//			}			
//		}
//	}
	
	public List<CrmContactRecord> findAllList() {
		return super.findList(new CrmContactRecord());
	}
	
	@Transactional(readOnly = false)
	public void update(CrmContactRecord crmContactRecord) {
		dao.update(crmContactRecord);
	}
}