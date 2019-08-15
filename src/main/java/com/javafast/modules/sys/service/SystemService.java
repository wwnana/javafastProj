package com.javafast.modules.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.system.api.WxDepartmentAPI;
import com.javafast.api.qywx.system.api.WxUserAPI;
import com.javafast.api.qywx.system.entity.WxDepartment;
import com.javafast.api.qywx.system.entity.WxUser;
import com.javafast.common.config.Global;
import com.javafast.modules.hr.dao.HrEmployeeDao;
import com.javafast.modules.hr.entity.HrEmployee;
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.qws.utils.WorkWechatUtils;
import com.javafast.modules.sys.dao.SysAccountDao;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 系统Service
 */
@Service
@Transactional(readOnly = true)
public class SystemService{

	@Autowired
	private UserDao userDao;
	
	@Autowired
	private HrEmployeeDao hrEmployeeDao;
	
	@Autowired
	private SysAccountDao sysAccountDao;
	
	@Autowired
	private OfficeService officeService;
	
	/**
	 * 获取授权信息
	 * @return
	 */
	public static boolean printKeyLoadMessage(){
		StringBuilder sb = new StringBuilder();
		sb.append("信息: "+Global.getConfig("productName")+" http://localhost:8080/javafast");
		System.out.println(sb.toString());
		return true;
	}
	
	/**
	 * 更新组织架构，部门和用户
	 * @param accountId
	 * @return
	 */
	@Transactional(readOnly = false)
	public boolean loadWechatDepart(String accountId){
		
		AccessToken accessToken = WorkWechatUtils.getAccessToken(accountId);
		if(accessToken != null){
			
			//更新组织机构
			List<WxDepartment> wxDepartList = WxDepartmentAPI.getAllDepartment(accessToken.getAccessToken(), null);
			
			Office topOffice = new Office();
			
			//部门
			for(int i=0;i<wxDepartList.size();i++){
				
				WxDepartment wxDepartment = wxDepartList.get(i);
				
				Office office = new Office();
				office.setCode(wxDepartment.getId()+"");
				office.setName(wxDepartment.getName());
				office.setSort(wxDepartment.getOrder());
				
				if("0".equals(wxDepartment.getParentid()) || i==0){
					office.setParent(new Office("0"));
				}else{
					office.setParent(topOffice);
				}
				
				Office conOffice = new Office();
				conOffice.setName(wxDepartment.getName());
				conOffice.getSqlMap().put("dsf", " AND a.account_id='"+accountId+"' ");
				List<Office> tempOfficeList = officeService.findListByName(conOffice);
				if(tempOfficeList != null && tempOfficeList.size()>0){
					
					//存在则更新
					office = tempOfficeList.get(0);
					
					office.setCode(wxDepartment.getId()+"");
					//office.setName(wxDepartment.getName());
					office.setSort(wxDepartment.getOrder());
					
					if("0".equals(wxDepartment.getParentid()) || i==0){
						office.setType("1");
					}else{
						office.setType("2");
					}
					
					officeService.save(office);
				}else{
					//新增
					office.setGrade("1");
					
					if("0".equals(wxDepartment.getParentid()) || i==0){
						office.setType("1");
					}else{
						office.setType("2");
					}
					
					if(wxDepartment.getOrder() == 0){
						office.setType("1");
					}
					
					office.setAccountId(accountId);
					officeService.save(office);
				}
				
				if("0".equals(wxDepartment.getParentid()) || i==0){
					topOffice = office;
				}
				
				System.out.println("微信部门："+wxDepartment.getName()+"，本地部门："+office.getName());
				
				//更新成员
				List<WxUser> wxUserList = WxUserAPI.getDetailUsersByDepartid(wxDepartment.getId(), "0", accessToken.getAccessToken());
				
				for(int j=0;j<wxUserList.size();j++){
					
					WxUser wxUser = wxUserList.get(j);
					
					User user = new User();
					user.setLoginName(wxUser.getUserid());
					user.setName(wxUser.getName());
					
					if(wxUser.getMobile() != null)
						user.setMobile(wxUser.getMobile());
					
					if(wxUser.getEmail() != null)
						user.setEmail(wxUser.getEmail());
					
					if(wxUser.getEnable() != null){
						user.setLoginFlag(wxUser.getEnable()+"");
					}else{
						user.setLoginFlag("1");
					}
					
					if(wxUser.getAvatar() != null)
						user.setPhoto(wxUser.getAvatar());
					else
						user.setPhoto("/static/images/user.jpg");
					user.setPhone(wxUser.getTelephone());
					user.setBindWx(wxUser.getStatus()+"");
					user.setCompany(topOffice);
					user.setOffice(office);
					user.setUserId(wxUser.getUserid());
					user.setQrCode(wxUser.getQr_code());

					User conUser = new User();
					conUser.setUserId(user.getLoginName());
					conUser.setAccountId(accountId);
					List<User> tempList = userDao.findListByUserId(conUser);
					if(tempList != null & tempList.size()>0){
						
						//存在则更新
						user = tempList.get(0);
						
						if(wxUser.getMobile() != null)
							user.setMobile(wxUser.getMobile());
						
						if(wxUser.getEmail() != null)
							user.setEmail(wxUser.getEmail());
						
						if(wxUser.getAvatar() != null)
							user.setPhoto(wxUser.getAvatar());
						else
							user.setPhoto("/static/images/user.jpg");
						
						if(wxUser.getTelephone() != null)
							user.setPhone(wxUser.getTelephone());
						
						if(user.getCompany() == null){
							user.setCompany(topOffice);
						}
						
						user.setBindWx(wxUser.getStatus()+"");
						user.setCompany(topOffice);
						user.setOffice(office);
						user.setUserId(wxUser.getUserid());
						
						userDao.update(user);
					}else{
						
						//新增
						user.setUserType("3");//普通用户
						String loginPass = String.valueOf((int) (Math.random() * 9000 + 1000));//初始密码，生成随机4位验证码
						user.setPassword(UserService.entryptPassword(loginPass));//密码
						user.preInsert();
						user.setAccountId(accountId);
						userDao.insert(user);
						
						//授权普通用户角色
						List<Role> roleList = Lists.newArrayList();
						Role role = new Role("member");//企业普通用户角色
						roleList.add(role);
						user.setRoleList(roleList);
						userDao.insertUserRole(user);
						
						HrEmployee hrEmployee = new HrEmployee();
						hrEmployee.setName(user.getName());
						hrEmployee.setMobile(user.getMobile());
						hrEmployee.setEmail(user.getEmail());
						hrEmployee.setUser(user);
						hrEmployee.setStatus("0");
						hrEmployee.preInsert();
						hrEmployee.setHrResume(new HrResume(user.getId()));
						hrEmployee.setId(user.getId());	
						hrEmployee.setAccountId(user.getAccountId());
						hrEmployeeDao.insert(hrEmployee);
					}
					
					System.out.println("用户："+user.getName());
				}
			}
			
			//清理缓存
			UserUtils.removeCache(UserUtils.CACHE_USER_LIST);
			UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
			UserUtils.removeCache(UserUtils.CACHE_OFFICE_ALL_LIST);
			
			return true;
		}
		
		return false;
	}
	
	/**
	 * 冻结用户
	 * @param accountId
	 * @param userId
	 */
	@Transactional(readOnly = false)
	public void delUser(String accountId, String userId){
		
		User conUser = new User();
		conUser.setAccountId(accountId);
		conUser.setUserId(userId);
		List<User> userList = userDao.findListByUserId(conUser);
		if(userList != null && userList.size() == 1){
			User user = userList.get(0);
			
			//更新用户登录状态
			user.setLoginFlag(Global.NO);//冻结
			userDao.updateLoginFlag(user);
		}
	}
}
