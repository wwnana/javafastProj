package com.javafast.modules.crm.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.crm.dao.CrmClueDao;
import com.javafast.modules.crm.dao.CrmContactRecordDao;
import com.javafast.modules.crm.dao.CrmContacterDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;

/**
 * 客户Service
 */
@Service
@Transactional(readOnly = true)
public class CrmCustomerService extends CrudService<CrmCustomerDao, CrmCustomer> {
	
	@Autowired
	CrmContacterDao crmContacterDao;
	
	@Autowired
	CrmContactRecordDao crmContactRecordDao;
	
	@Autowired
	UserDao userDao;
	
	@Autowired
	CrmClueDao crmClueDao;
	
	public CrmCustomer get(String id) {
		
		CrmCustomer crmCustomer = super.get(id);
		return crmCustomer;
	}
	
	public List<CrmCustomer> findList(CrmCustomer crmCustomer) {
		
		//默认查询非公海客户
		if(StringUtils.isBlank(crmCustomer.getIsPool())){
			crmCustomer.setIsPool("0");
		}
		dataScopeFilterOwnBy(crmCustomer);//加入权限过滤
		return super.findList(crmCustomer);
	}
	
	public Page<CrmCustomer> findPage(Page<CrmCustomer> page, CrmCustomer crmCustomer) {
		
		//默认查询非公海客户
		if(StringUtils.isBlank(crmCustomer.getIsPool())){
			crmCustomer.setIsPool("0");
			dataScopeFilterOwnBy(crmCustomer);//加入权限过滤
		}
		
		//公海客户，只过滤accountId
		if("1".equals(crmCustomer.getIsPool())){
			dataScopeFilter(crmCustomer);//加入权限过滤
		}
		
		return super.findPage(page, crmCustomer);
	}
	
	//查询公海客户
	public Page<CrmCustomer> findPoolPage(Page<CrmCustomer> page, CrmCustomer crmCustomer) {
		
		//查询公海客户
		crmCustomer.setIsPool("1");
		dataScopeFilter(crmCustomer);//加入权限过滤
		return super.findPage(page, crmCustomer);
	}
	
	/**
	 * 导出excel文件 查询数据
	 * @param page
	 * @param crmCustomer
	 * @return
	 */
	public Page<CrmCustomer> findPageForExport(Page<CrmCustomer> page, CrmCustomer crmCustomer) {
		//默认查询非公海客户
		if(StringUtils.isBlank(crmCustomer.getIsPool())){
			crmCustomer.setIsPool("0");
		}
		dataScopeFilterOwnBy(crmCustomer);//加入权限过滤
		crmCustomer.setPage(page);
		page.setList(dao.findListForExport(crmCustomer));
		return page;
	}
	
	public Page<CrmCustomer> findAllPage(Page<CrmCustomer> page, CrmCustomer crmCustomer) {
		dataScopeFilter(crmCustomer);//加入权限过滤
		crmCustomer.setPage(page);
		page.setList(dao.findAllList(crmCustomer));
		return page;
	}
	
	@Transactional(readOnly = false)
	public void save(CrmCustomer crmCustomer) {
		
		//判断是否为公海客户
		crmCustomer.setIsPool("1");//没有指定负责人，属于公海客户
		if(crmCustomer.getOwnBy()!=null && StringUtils.isNotBlank(crmCustomer.getOwnBy().getId())){
			crmCustomer.setIsPool("0");
		}
		
		boolean isNew = crmCustomer.getIsNewRecord();
		
		if (isNew){
			crmCustomer.preInsert();
			//查询是否是销售线索转换的,如果是则保持同一个ID，方便查询跟进记录
			if(StringUtils.isNotBlank(crmCustomer.getCrmClueId())) {
				crmCustomer.setId(crmCustomer.getCrmClueId());
			}			
			dao.insert(crmCustomer);
		}else{
			crmCustomer.preUpdate();
			dao.update(crmCustomer);
		}
		
		//联系人信息保存
		if(isNew){
			
			//保存首要联系人
			if(crmCustomer.getCrmContacter() != null && StringUtils.isNotBlank(crmCustomer.getCrmContacter().getName())){
				
				CrmContacter crmContacter = crmCustomer.getCrmContacter();
				crmContacter.setCustomer(crmCustomer);
				crmContacter.setOwnBy(crmCustomer.getOwnBy());
				crmContacter.setIsDefault("1");
				crmContacter.preInsert();
				crmContacterDao.insert(crmContacter);
			}
			
			//查询是否是销售线索转换的,如果是 修改销售线索状态
			if(StringUtils.isNotBlank(crmCustomer.getCrmClueId())) {
				CrmClue crmClue = crmClueDao.get(crmCustomer.getCrmClueId());
				crmClue.setCrmCustomer(crmCustomer);
				crmClue.preUpdate();
				crmClueDao.update(crmClue);
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CLUE, Contants.ACTION_TYPE_CHANGE, crmClue.getId(), crmClue.getName(), null);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(CrmCustomer crmCustomer) {
		super.delete(crmCustomer);
		//删除对应的联系人
	}
	
	/**
	 * 查询记录数
	 * @param crmCustomer
	 * @return
	 */
	public Long findCount(CrmCustomer crmCustomer){
		return dao.findCount(crmCustomer);
	}
	
	/**
	 * 查询回收站客户
	 * @param page
	 * @param crmCustomer
	 * @return
	 */
	public Page<CrmCustomer> findDelPage(Page<CrmCustomer> page, CrmCustomer crmCustomer) {
		dataScopeFilter(crmCustomer);//加入权限过滤
		crmCustomer.setPage(page);
		page.setList(dao.findDelList(crmCustomer));
		return page;
	}
	
	/**
	 * 还原客户
	 * @param crmCustomer
	 */
	@Transactional(readOnly = false)
	public void replay(CrmCustomer crmCustomer) {
		dao.replay(crmCustomer);
		//还原联系人
	}
	
	/**
	 * 更新负责人
	 * @param crmCustomer
	 */
	@Transactional(readOnly = false)
	public void updateOwnBy(CrmCustomer crmCustomer) {
		
		crmCustomer.setIsPool("0");//非公海
		crmCustomer.preUpdate();
		dao.updateOwnBy(crmCustomer);
		
		//更新联系人负责人和负责人部门信息
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		crmContacter.setOwnBy(crmCustomer.getOwnBy());
		crmContacter.setOfficeId(crmCustomer.getOfficeId());
		crmContacter.preUpdate();
		crmContacterDao.updateOwnBy(crmContacter);
	}
	
	/**
	 * 放入公海
	 * @param crmCustomer
	 */
	@Transactional(readOnly = false)
	public void throwToPool(CrmCustomer crmCustomer) {

		//客户放入公海
		dao.throwToPool(crmCustomer);
		
		//联系人放入公海
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		crmContacterDao.throwToPool(crmContacter);
	}
	
	@Transactional(readOnly = false)
	public void add(CrmCustomer crmCustomer) {
		super.save(crmCustomer);
	}
	
	public List<CrmCustomer> findAllList(CrmCustomer crmCustomer) {
		//默认查询非公海客户
		if(StringUtils.isBlank(crmCustomer.getIsPool())){
			crmCustomer.setIsPool("0");
		}
		dataScopeFilterOwnBy(crmCustomer);//加入权限过滤
		return super.findList(crmCustomer);
	}
	
	/**
	 * 根据名称获取客户列表
	 * @param accountId
	 * @param name
	 * @param id 原ID，修改时候有值
	 * @return
	 */
	public List<CrmCustomer> findListByCustomerName(String accountId, String name, String id){
		return dao.findListByCustomerName(accountId, name, id);		
	}
	
	/**
	 * 查询客户概况统计
	 * @param id
	 * @return
	 */
	public CrmCustomer getGeneralCountByCustomer(String id) {
		return dao.getGeneralCountByCustomer(id);
	}
	
	/**
	 *  查询超N天未联系的客户
	 * @param accountId
	 * @param dayNum
	 * @return
	 */
	public List<CrmCustomer> findOverdueList(String accountId, Integer dayNum) {
		return dao.findOverdueList(accountId, dayNum);
	}
}