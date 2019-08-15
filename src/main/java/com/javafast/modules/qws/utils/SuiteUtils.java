package com.javafast.modules.qws.utils;

import java.util.List;

import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywxs.auth.api.WxSuiteAuthAPI;
import com.javafast.api.qywxs.auth.entity.AuthCorpInfo;
import com.javafast.api.qywxs.auth.entity.AuthInfo;
import com.javafast.api.qywxs.auth.entity.AuthUserInfo;
import com.javafast.api.qywxs.auth.entity.PermanentInfo;
import com.javafast.api.qywxs.core.api.WxSuiteAccessTokenAPI;
import com.javafast.common.config.Global;
import com.javafast.common.utils.CacheUtils;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.main.utils.InitDataUtils;
import com.javafast.modules.qws.dao.QwsSuiteNoticeDao;
import com.javafast.modules.qws.entity.QwsSuiteNotice;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SystemService;
import com.javafast.modules.sys.service.UserService;

/**
 * 第三方应用凭证工具类  （第三方）
 * @author syh
 *
 */
public class SuiteUtils {

	private static QwsSuiteNoticeDao qwsSuiteNoticeDao = SpringContextHolder.getBean(QwsSuiteNoticeDao.class);
	private static SysAccountService sysAccountService = SpringContextHolder.getBean(SysAccountService.class);
	private static SystemService systemService = SpringContextHolder.getBean(SystemService.class);
	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
	
	//企业微信应用授权页网址
	public final static String qy_reg_url = "https://open.work.weixin.qq.com/3rdapp/install?suite_id=SUITE_ID&pre_auth_code=PRE_AUTH_CODE&redirect_uri=REDIRECT_URI&state=STATE";  
			
	//授权完成后的回调网址
	public static final String redirect_uri = Global.getConfig("qywx.service.redirect_uri");
	
	// 第三方应用凭证（suite_access_token） 缓存名称
	public static final String CACHE_SUITE_ACCESS_TOKEN = "suite_access_token";
	
	//企业微信后台推送的ticket
	public static final String CACHE_SUITE_TICKET = "suite_ticket";

	/**
	 * 获取第三方应用凭证（suite_access_token）缓存优先
	 * @return
	 */
	public static AccessToken getSuiteAccessToken() {

		//1.优先从缓存中读取
		AccessToken accessToken = (AccessToken) CacheUtils.get(CACHE_SUITE_ACCESS_TOKEN);
		if (accessToken != null) {
			//判断缓存中的accessToken是否过期
			if (((DateUtils.getCurrentTimestamp() - accessToken.getTimestamp()) / 1000) < accessToken.getExpiresIn()){
				return accessToken;
			}
		}
		
		//2.从企业微信接口获取第三方应用凭证（suite_access_token）
		String suiteTicket = getSuiteTicket();
		accessToken = WxSuiteAccessTokenAPI.getAccessToken(ProviderConstantUtils.suiteId, ProviderConstantUtils.secret, suiteTicket);
		if (accessToken != null) {

			//3.加入缓存
			CacheUtils.put(CACHE_SUITE_ACCESS_TOKEN, accessToken);
		}

		return accessToken;
	}
	
	/**
	 * 获取企业微信后台推送的ticket 缓存优先
	 * @return
	 */
	public static String getSuiteTicket() {
		
		//1.优先从缓存中读取
		String suiteTicket = (String) CacheUtils.get(CACHE_SUITE_TICKET);
		
		if(suiteTicket != null){
			return suiteTicket;
		}
		
		//2.从数据库获取
		List<QwsSuiteNotice> list = qwsSuiteNoticeDao.findListForSuiteTicket();
		if(list != null && list.size() > 0){
			QwsSuiteNotice qwsSuiteNotice = list.get(0);
			suiteTicket = qwsSuiteNotice.getSuiteTicket();
			//3.加入缓存
			CacheUtils.put(CACHE_SUITE_TICKET, suiteTicket);
		}
		
		return suiteTicket;
	}
	
	/**
	 * 设置ticket到缓存
	 * @param suiteTicket
	 */
	public static void setSuiteTicket(String suiteTicket) {		
		CacheUtils.put(CACHE_SUITE_TICKET, suiteTicket);
	}
	
	/**
	 * 获取企业永久授权信息
	 * @param auth_code 临时授权码
	 */
	public static PermanentInfo createAuthCorp(String auth_code){
		
		PermanentInfo permanentInfo = null;
		
		//1.获取第三方应用凭证（suite_access_token）
		AccessToken accessToken = getSuiteAccessToken();
		if(accessToken != null){
			
			//2.调用微信接口，通过临时授权码获取企业永久授权信息
			permanentInfo = WxSuiteAuthAPI.getPermanentCode(accessToken.getAccessToken(), auth_code);
			
			//3.获取授权信息
			if(permanentInfo != null){
				
				AuthCorpInfo authCorpInfo = permanentInfo.getAuthCorpInfo();//授权方企业信息
				AuthInfo authInfo = permanentInfo.getAuthInfo();//授权的应用信息
				AuthUserInfo authUserInfo = permanentInfo.getAuthUserInfo();//授权管理员的信息
				
				String permanentCode = permanentInfo.getPermanent_code();//企业永久授权码
				String corpid = authCorpInfo.getCorpid();//企业微信id 
				String companyName = authCorpInfo.getCorp_full_name();//企业主体名称
				String systemName = authCorpInfo.getCorp_name();//企业名称
				Integer agentid = authInfo.getAgentid();//授权方应用id
				String userId = authUserInfo.getUserid();//用户名
				String loginPass = String.valueOf((int) (Math.random() * 9000 + 1000));//初始密码，生成随机4位验证码
				
				//4.检测企业之前是否有注册过
				SysAccount existSysAccount = sysAccountService.findUniqueByProperty("corpid", corpid);
				if(existSysAccount != null){
					
					System.out.println("企业之前添加过应用，激活企业"+systemName);
					
					//激活企业
					existSysAccount.setPermanentCode(permanentCode);
					existSysAccount.setUserid(authUserInfo.getUserid());
					existSysAccount.setCorpid(authCorpInfo.getCorpid());
					existSysAccount.setCorpName(authCorpInfo.getCorp_name());
					existSysAccount.setCorpType(authCorpInfo.getCorp_type());
					existSysAccount.setCorpWxqrcode(authCorpInfo.getCorp_wxqrcode());
					existSysAccount.setCorpScale(authCorpInfo.getCorp_scale());
					existSysAccount.setCorpIndustry(authCorpInfo.getCorp_industry());
					existSysAccount.setAgentid(agentid);
					
					//开户必要信息
					existSysAccount.setName(companyName);//企业名称
					if(StringUtils.isBlank(companyName)){
						existSysAccount.setName(systemName);
					}
					existSysAccount.setSystemName(systemName);//系统名称
					
					existSysAccount.setStatus("0");	//激活				
					sysAccountService.save(existSysAccount);
				}else{
					
					System.out.println("企业添加应用，进入开户SysAccount"+systemName);
					
					//5.创建企业信息
					SysAccount sysAccount = new SysAccount();
					
					sysAccount.setId(corpid);
					sysAccount.setPermanentCode(permanentCode);
					sysAccount.setUserid(authUserInfo.getUserid());
					sysAccount.setCorpid(authCorpInfo.getCorpid());
					sysAccount.setCorpName(authCorpInfo.getCorp_name());
					sysAccount.setCorpType(authCorpInfo.getCorp_type());
					sysAccount.setCorpWxqrcode(authCorpInfo.getCorp_wxqrcode());
					sysAccount.setCorpScale(authCorpInfo.getCorp_scale());
					sysAccount.setCorpIndustry(authCorpInfo.getCorp_industry());
					sysAccount.setAgentid(agentid);
					
					//开户必要信息
					sysAccount.setName(companyName);//企业名称
					if(StringUtils.isBlank(companyName)){
						sysAccount.setName(systemName);
					}
					sysAccount.setSystemName(systemName);//系统名称
					//sysAccount.setMobile(mobile);
					sysAccount.setMaxUserNum(200);
					sysAccount.setNowUserNum(1);
					
					//管理员信息
					User adminUser = new User();
					adminUser.setName(authUserInfo.getName());
					adminUser.setLoginName(userId);//账号
					adminUser.setPassword(UserService.entryptPassword(loginPass));//密码
					//adminUser.setMobile(mobile);//手机
					adminUser.setUserType("1");
					adminUser.setPhoto(authUserInfo.getAvatar());
					adminUser.setEmail(authUserInfo.getEmail());
					adminUser.setNo("1");
					adminUser.setUserId(userId);
					adminUser.setBindWx("1");
					
					//检测用户名是否被占用
					User tempUser = userDao.getByLoginName(new User(null, userId));
					if(tempUser != null){
						adminUser.setLoginName(userId + 2);//账号
					}
					
					//6.企业开户
					sysAccountService.createSysAccount(sysAccount, adminUser);			
					System.out.println("企业开户执行完成，企业ID："+sysAccount.getId()+", 管理员ID："+adminUser.getId());
					
					//7.初始化企业数据
					InitDataUtils.initData(sysAccount, adminUser);
					System.out.println("初始化企业数据完成");
				}
			}
		}
		
		return permanentInfo;
	}
	
	/**
	 * 取消授权
	 * @param authCorpId 授权方的corpid
	 * @return
	 */
	public static void cancelAuthCorp(String authCorpId){
		
		//1.检测之前是否有开户
		SysAccount tempSysAccount = sysAccountService.findUniqueByProperty("corpid", authCorpId);
		if(tempSysAccount != null){
			
			//2.冻结企业
			tempSysAccount.setStatus("1");					
			sysAccountService.save(tempSysAccount);
			
			System.out.println("取消授权成功"+tempSysAccount.getName());
		}
	}
	
	/**
	 * 通过永久授权码换取企业微信的授权信息
	 * @param accountId 
	 * @return
	 */
	public static PermanentInfo getPermanentInfo(String accountId){
		
		//1.获取企业信息
		SysAccount sysAccount = sysAccountService.get(accountId);
		if(sysAccount == null || StringUtils.isBlank(sysAccount.getCorpid()) || StringUtils.isBlank(sysAccount.getPermanentCode())){
			return null;
		}
		
		PermanentInfo permanentInfo = null;
		AccessToken accessToken = getSuiteAccessToken();
		if(accessToken != null){
			
			//2.调用微信接口，通过永久授权码换取企业微信的授权信息
			permanentInfo = WxSuiteAuthAPI.getPermanentInfo(accessToken.getAccessToken(), sysAccount.getCorpid(), sysAccount.getPermanentCode());
			if(permanentInfo != null){
				
				AuthCorpInfo authCorpInfo = permanentInfo.getAuthCorpInfo();//授权方企业信息
				AuthInfo authInfo = permanentInfo.getAuthInfo();//授权的应用信息
				AuthUserInfo authUserInfo = permanentInfo.getAuthUserInfo();//授权管理员的信息
				
				String permanentCode = permanentInfo.getPermanent_code();//企业永久授权码
				String corpid = authCorpInfo.getCorpid();//企业微信id 
				String companyName = authCorpInfo.getCorp_full_name();//企业主体名称
				String systemName = authCorpInfo.getCorp_name();//企业名称
				Integer agentid = authInfo.getAgentid();//授权方应用id
				String userId = authUserInfo.getUserid();//用户名
				
				//3.更新企业信息
				sysAccount.setAgentid(agentid);
				sysAccountService.save(sysAccount);
			}
		}
		return permanentInfo;
	}

	/**
	 * 获取企业通讯录
	 * @param corpid
	 * @return
	 */
	public static void loadWechatDepart(String corpid){
		//TODO 这里是不是存在也要更新呢？
		//检测之前是否有开户
		SysAccount sysAccount = sysAccountService.findUniqueByProperty("corpid", corpid);
		if(sysAccount != null){
			
			systemService.loadWechatDepart(sysAccount.getId());
		}
	}
	
	/**
	 * 删除用户
	 * @param corpid
	 * @param userId
	 */
	public static void delUser(String corpid, String userId){
		
		//检测之前是否有开户
		SysAccount sysAccount = sysAccountService.findUniqueByProperty("corpid", corpid);
		if(sysAccount != null){
			
			//冻结用户
			systemService.delUser(sysAccount.getId(), userId);
		}
	}
	
	/**
	 * 删除部门
	 * @param corpid
	 * @param departId
	 */
	public static void delDepart(String corpid, String departId){
		
		
	}
}
