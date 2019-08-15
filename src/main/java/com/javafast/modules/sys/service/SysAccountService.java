package com.javafast.modules.sys.service;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.google.common.collect.Lists;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.message.api.WxMessageAPI;
import com.javafast.api.qywx.message.entity.MessageText;
import com.javafast.api.qywx.message.entity.MessageTextData;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.IdUtils;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.qws.utils.WorkWechatUtils;
import com.javafast.modules.sys.dao.OfficeDao;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;

/**
 * 企业帐户Service
 */
@Service
@Transactional(readOnly = true)
public class SysAccountService extends CrudService<SysAccountDao, SysAccount> {

	@Autowired
	OfficeDao officeDao;
	
	@Autowired
	UserDao userDao;
	
	
	public SysAccount get(String id) {
		return super.get(id);
	}
	
	public List<SysAccount> findList(SysAccount sysAccount) {
		if(!UserUtils.getUser().isAdmin()){
			return null;
		}
		return super.findList(sysAccount);
	}
	
	public Page<SysAccount> findPage(Page<SysAccount> page, SysAccount sysAccount) {
		if(!UserUtils.getUser().isAdmin()){
			return null;
		}
		return super.findPage(page, sysAccount);
	}
	
	@Transactional(readOnly = false)
	public void save(SysAccount sysAccount) {
		super.save(sysAccount);
		//清除指定企业缓存
		UserUtils.clearCacheAccount(sysAccount);
	}
	
	@Transactional(readOnly = false)
	public void delete(SysAccount sysAccount) {
		super.delete(sysAccount);
	}
	
	@Transactional(readOnly = false)
	public void insert(SysAccount sysAccount) {		
		dao.insert(sysAccount);
	}
	
	/**
	 * 修改状态
	 * @param sysAccount
	 */
	@Transactional(readOnly = false)
	public void updateStatus(SysAccount sysAccount) {
		dao.updateStatus(sysAccount);
	}
	
	/**
	 * 更新所有企业信息
	 */
	@Transactional(readOnly = false)
	public void updateAccount(SysAccount sysAccount){		
		dao.updateUserNum(sysAccount);	
	}
	
	/**
	 * 更新企业当前用户数
	 * @param sysAccount
	 */
	@Transactional(readOnly = false)
	public void updateUserNum(SysAccount sysAccount){
		dao.updateUserNum(sysAccount);
	}
	
	/**
	 * 对于超过10天未登录的企业，提醒
	 */
	@Transactional(readOnly = false)
	public void sendAdvertMsg(){
		
		SysAccount conSysAccount = new SysAccount();
		conSysAccount.setStatus("0");
		List<SysAccount> accountList = dao.findList(conSysAccount);
		
		for(SysAccount sysAccount : accountList){
			
			String content = "欢迎关注企酷CRM应用，在这里我们辅助您关怀客户，掌控商机，高效工作，快速提升业绩。PC版功能更加强大哦。";
			
			AccessToken accessToken = WorkWechatUtils.getAccessToken(sysAccount.getId());
			if(accessToken != null){
				
				//通知审批人
				MessageText text = new MessageText();
				text.setTouser("@all");
				text.setMsgtype("text");
				text.setAgentid(accessToken.getWxAgentid());
				MessageTextData textData = new MessageTextData();
				textData.setContent(content);
				text.setText(textData);
				
				WxMessageAPI.sendTextMessage(text, accessToken.getAccessToken());
			}
		}
	}
	
	/**
	 * 创建企业账户 - 企业开户流程
	 * @param sysAccount 企业信息主体
	 * @param adminUser 管理员信息
	 */
	@Transactional(readOnly = false)
	public void createSysAccount(SysAccount sysAccount, User adminUser){
		
		String userId = IdUtils.getId();//随机用户ID
		adminUser.setId(userId);
		
		//初始化企业信息
		sysAccount.setStatus("0");//可用
		sysAccount.setDelFlag("0");//数据正常
		sysAccount.setSmsStatus("0");//默认不开通短信
		sysAccount.setPayStatus("0");//初始未支付
		sysAccount.setAdminUserId(userId);
		sysAccount.setCreateDate(new Date());
		sysAccount.setCreateBy(adminUser);
		dao.insert(sysAccount);
				
		//初始化顶级部门
		Office company = new Office();		
		company.setAccountId(sysAccount.getId());//企业编号
		company.setName(sysAccount.getName());
		company.setCode("0");
		company.setSort(0);
		company.setType("1");
		company.setGrade("1");
		company.setCreateBy(new User(userId));
		company.setCreateDate(new Date());
		company.setParent(new Office("0"));
		company.setParentIds("0,");
		company.preInsert();
		officeDao.insert(company);
		
		//初始化管理员用户
		adminUser.setAccountId(sysAccount.getId());//企业编号
		adminUser.setId(userId);//用户ID
		adminUser.setCompany(company);//归属公司
		adminUser.setOffice(company);//归属部门
		adminUser.setDataScope("1");//数据权限，1所有
		adminUser.setLoginFlag("1");	//可登录	
		adminUser.setCreateDate(new Date());
		adminUser.setCreateBy(adminUser);
		userDao.insert(adminUser);
		
		//授权企业管理员角色
		List<Role> roleList = Lists.newArrayList();
		Role role = new Role("admin");//企业管理员角色
		roleList.add(role);
		adminUser.setRoleList(roleList);
		userDao.insertUserRole(adminUser);
	}
	
	/**
	 * 获取企业编号
	 * @return
	 */
	public String getCompanyNo(){		
		String companyNo = String.valueOf((int) (Math.random() * 9000 + 1000));//企业编号自动生成					
		//校验企业编号是否已被注册
		if(get(companyNo) != null){
			companyNo = this.getCompanyNo();
		}
		return companyNo;
	}
}