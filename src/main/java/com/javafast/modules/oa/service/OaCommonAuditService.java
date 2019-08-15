package com.javafast.modules.oa.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonFlow;
import com.javafast.modules.oa.entity.OaCommonFlowDetail;
import com.javafast.modules.oa.entity.OaTaskRecord;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.oa.dao.OaCommonAuditDao;
import com.javafast.modules.oa.dao.OaCommonFlowDetailDao;
import com.javafast.modules.oa.entity.OaCommonAuditRecord;
import com.javafast.modules.oa.dao.OaCommonAuditRecordDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 审批流程Service
 */
@Service
@Transactional(readOnly = true)
public class OaCommonAuditService extends CrudService<OaCommonAuditDao, OaCommonAudit> {

	@Autowired
	private OaCommonAuditRecordDao oaCommonAuditRecordDao;
	
	@Autowired
	UserDao userDao;
	
	@Autowired
	private OaCommonFlowService oaCommonFlowService;
	
	public OaCommonAudit get(String id) {
		OaCommonAudit oaCommonAudit = super.get(id);
		oaCommonAudit.setOaCommonAuditRecordList(oaCommonAuditRecordDao.findList(new OaCommonAuditRecord(oaCommonAudit)));
		return oaCommonAudit;
	}
	
	public List<OaCommonAudit> findList(OaCommonAudit oaCommonAudit) {
		dataScopeFilter(oaCommonAudit);//加入数据权限过滤
		return super.findList(oaCommonAudit);
	}
	
	public Page<OaCommonAudit> findPage(Page<OaCommonAudit> page, OaCommonAudit oaCommonAudit) {
		dataScopeFilter(oaCommonAudit);//加入数据权限过滤
		return super.findPage(page, oaCommonAudit);
	}
	
	/**
	 * 提交审批
	 * @param oaCommonAudit
	 * @param requestUrl
	 */
	@Transactional(readOnly = false)
	public void save(OaCommonAudit oaCommonAudit, String requestUrl) {
		
		//创建审批
		oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
		oaCommonAudit.setType("0");//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		String oaCommonAuditId = crateCommonAudit(oaCommonAudit);//审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
	}
	
	//获取PC网址
	private static final String pcRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/oa/oaCommonAudit/view";
	
	//获取手机网址
	private static final String mobileRequestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/mobile/oa/oaCommonAudit/view";
		
	/**
	 * 通知下一审批人
	 * @param oaCommonAudit
	 */
	@Transactional(readOnly = false)
	public void sendMsgToAuditUser(OaCommonAudit oaCommonAudit){
		
		//站内信，通知下一审批人
		String title = "审批提醒："+UserUtils.getUser().getName()+"发起了申请，请查看!";
		String content = "审批提醒："+UserUtils.getUser().getName()+"发起了申请：<a href=\""+pcRequestUrl+"?id="+oaCommonAudit.getId()+"\">"+oaCommonAudit.getTitle()+"</a> ，点击查看！";
		System.out.println(content);
		MailUtils.sendMail(title, content, oaCommonAudit.getCurrentBy().getId());
		
		//手机短信通知 (前提：开通短信提醒功能)
		SmsUtils.addSms(Contants.OBJECT_OA_TYPE_AUDIT, oaCommonAudit.getCurrentBy().getId());
		
		//微信提醒用户
		User user = userDao.get(oaCommonAudit.getCurrentBy().getId());
		WorkWechatMsgUtils.sendMsg(user.getUserId(), "审批提醒："+oaCommonAudit.getCreateBy().getName()+"发起了申请：<a href=\""+mobileRequestUrl+"?id="+oaCommonAudit.getId()+"\">"+oaCommonAudit.getTitle()+"</a> ，点击查看", UserUtils.getUser().getAccountId());
	}
	
	/**
	 * 通知查阅用户
	 * @param oaCommonAudit
	 */
	@Transactional(readOnly = false)
	public void sendMsgToReadUser(OaCommonAudit oaCommonAudit){
		
		for(int i=0; i<oaCommonAudit.getOaCommonAuditRecordList().size(); i++){			
			OaCommonAuditRecord oaCommonAuditRecord = oaCommonAudit.getOaCommonAuditRecordList().get(i);
			
			if("1".equals(oaCommonAuditRecord.getDealType())){
			
				//微信提醒用户
				User user = userDao.get(oaCommonAuditRecord.getUser().getId());
				WorkWechatMsgUtils.sendMsg(user.getUserId(), "查阅提醒："+oaCommonAudit.getCreateBy().getName()+"发起了申请：<a href=\""+mobileRequestUrl+"?id="+oaCommonAudit.getId()+"\">"+oaCommonAudit.getTitle()+"</a> ，点击查看", UserUtils.getUser().getAccountId());
			}
		}
	}
	
	/**
	 * 创建审批
	 * @param oaCommonAudit
	 * @param requestUrl
	 * @return
	 */
	@Transactional(readOnly = false)
	public String crateCommonAudit(OaCommonAudit oaCommonAudit){
		
		//审批主体		
		oaCommonAudit.setStatus("1");		
		oaCommonAudit.preInsert();
		User currentUser = null;
		Boolean hasSelfFlag = false;////流程执行是否含有本人
		
		//配置好的流程
		if(StringUtils.isNotBlank(oaCommonAudit.getOaCommonFlowId())){
			System.out.println("==========流程ID========"+oaCommonAudit.getOaCommonFlowId());
			//流程配置
			OaCommonFlow oaCommonFlow = oaCommonFlowService.get(oaCommonAudit.getOaCommonFlowId());
			for (OaCommonFlowDetail oaCommonFlowDetail : oaCommonFlow.getOaCommonFlowDetailList()){
				
				//获取第一级审批人
				if("0".equals(oaCommonFlowDetail.getDealType()) && currentUser == null){
					currentUser = oaCommonFlowDetail.getUser();
				}
				
				//流程执行含有本人
				if(oaCommonFlowDetail.getUser().getId().equals(oaCommonAudit.getCreateBy().getId())){
					hasSelfFlag = true;
				}
				//审批明细
				OaCommonAuditRecord oaCommonAuditRecord = new OaCommonAuditRecord();
				
				oaCommonAuditRecord.setCommonAudit(oaCommonAudit);
				oaCommonAuditRecord.setDealType(oaCommonFlowDetail.getDealType());
				oaCommonAuditRecord.setUser(oaCommonFlowDetail.getUser());
				oaCommonAuditRecord.setAuditOrder(oaCommonFlowDetail.getSort());
				oaCommonAuditRecord.setReadFlag("0");
				oaCommonAuditRecord.preInsert();
				oaCommonAuditRecordDao.insert(oaCommonAuditRecord);
			}
		}else{
			//自定义的流程
			for(int i=0; i<oaCommonAudit.getOaCommonAuditRecordList().size(); i++){
				
				OaCommonAuditRecord oaCommonAuditRecord = oaCommonAudit.getOaCommonAuditRecordList().get(i);
				
				//获取第一级审批人
				if("0".equals(oaCommonAuditRecord.getDealType()) && currentUser == null){
					currentUser = oaCommonAuditRecord.getUser();
				}
				
				//流程执行含有本人
				if(oaCommonAuditRecord.getUser().getId().equals(oaCommonAudit.getCreateBy().getId())){
					hasSelfFlag = true;
				}	
				
				oaCommonAuditRecord.setCommonAudit(oaCommonAudit);
				oaCommonAuditRecord.setReadFlag("0");
				oaCommonAuditRecord.setAuditOrder(i+1);
				oaCommonAuditRecord.preInsert();
				oaCommonAuditRecordDao.insert(oaCommonAuditRecord);
			}
		}
		
		//流程执行不含有本人
		if(hasSelfFlag ==  false){
			
			//把申请人加入明细
			OaCommonAuditRecord createByRecord = new OaCommonAuditRecord();
			createByRecord.setCommonAudit(oaCommonAudit);
			createByRecord.setDealType("2");//申请人
			createByRecord.setUser(oaCommonAudit.getCreateBy());
			createByRecord.setAuditOrder(0);
			createByRecord.setReadFlag("0");
			createByRecord.preInsert();
			oaCommonAuditRecordDao.insert(createByRecord);
		}		
		
		//设置当前审批人
		oaCommonAudit.setCurrentBy(currentUser);
		dao.insert(oaCommonAudit);
		
		return oaCommonAudit.getId();
	}
	
	/**
	 * 审批
	 * @param id 审批ID
	 * @param auditStatus
	 * @param auditNote
	 */
	@Transactional(readOnly = false)
	public void audit(String id, String auditStatus, String auditNote, User auditUser) {
		
		OaCommonAudit oaCommonAudit = this.get(id);
		
		OaCommonAuditRecord oaCommonAuditRecord = new OaCommonAuditRecord();
		oaCommonAuditRecord.setCommonAudit(oaCommonAudit);
		oaCommonAuditRecord.setDealType("0");
		//查询待我审批的记录
		List<OaCommonAuditRecord> recordList = oaCommonAuditRecordDao.findNoAuditList(oaCommonAuditRecord);
		if(recordList != null && recordList.size()>0){
			
			//更新审批记录
			OaCommonAuditRecord commonAuditRecord = recordList.get(0);
			
			//找到审批人为当前用户的记录
			if(commonAuditRecord.getUser().getId().equals(auditUser.getId())){
				
				commonAuditRecord.setAuditDate(new Date());
				commonAuditRecord.setAuditNotes(auditNote);
				commonAuditRecord.setAuditStatus(auditStatus);
				
				oaCommonAuditRecordDao.update(commonAuditRecord);
			}
		}
		
		//同意
		if("2".equals(auditStatus)){
			
			//如果还有审批流程，则修改下一审批人
			if(recordList != null && recordList.size()>1){
				
				OaCommonAuditRecord commonAuditRecord = recordList.get(1);
				
				oaCommonAudit.setCurrentBy(commonAuditRecord.getUser());
			}else{
				oaCommonAudit.setStatus("2");
			}
		}else{
			//拒绝，流程结束			
			oaCommonAudit.setStatus("3");
		}
		
		super.save(oaCommonAudit);
	}
	
	/**
	 * 更新阅读状态
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void updateReadFlag(String id, User currentUser) {
		
		OaCommonAudit oaCommonAudit = this.get(id);
		
		//更新审批记录
		OaCommonAuditRecord oaCommonAuditRecord = new OaCommonAuditRecord();
		oaCommonAuditRecord.setCommonAudit(oaCommonAudit);
		oaCommonAuditRecord.setUser(currentUser);
		List<OaCommonAuditRecord> recordList = oaCommonAuditRecordDao.findList(oaCommonAuditRecord);
		for(OaCommonAuditRecord commonAuditRecord : recordList){
			
			commonAuditRecord.setReadDate(new Date());
			commonAuditRecord.setReadFlag("1");
				
			oaCommonAuditRecordDao.update(commonAuditRecord);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommonAudit oaCommonAudit) {
		super.delete(oaCommonAudit);
		oaCommonAuditRecordDao.delete(new OaCommonAuditRecord(oaCommonAudit));
	}
	
	@Transactional(readOnly = false)
	public void addCommonAuditRecord(OaCommonAuditRecord oaCommonAuditRecord){
		
		
		oaCommonAuditRecord.preInsert();
		oaCommonAuditRecordDao.insert(oaCommonAuditRecord);
	}
}