package com.javafast.modules.qws.receive;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywxs.auth.api.WxSuiteAuthAPI;
import com.javafast.api.qywxs.auth.entity.PermanentInfo;
import com.javafast.common.config.Global;
import com.javafast.common.web.BaseController;
import com.javafast.modules.qws.utils.ProviderConstantUtils;
import com.javafast.modules.qws.utils.SuiteUtils;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.security.UsernamePasswordToken;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.UserService;

/**
 * 企业微信应用授权回调 从服务商网站发起
 * 把企业微信注册的URL放官网：http://crm.qikucrm.com/jf/wechat/auth/getAuthRegisterUrl
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/wechat/auth")
public class QywxAuthController extends BaseController {

	private static final Logger logger = LoggerFactory.getLogger(QywxAuthController.class);
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	/**
	 * 第三方服务商在自己的网站中放置“企业微信应用授权”的入口， 引导用户进入授权页
	 * @return
	 */
	@RequestMapping(value="getAuthRegisterUrl")
	public String getAuthRegisterUrl(){
		
		//授权页网址为
		String url = "";
		
		AccessToken accessToken = SuiteUtils.getSuiteAccessToken();
		if(accessToken != null){
			
			//获取预授权码
			String pre_auth_code = WxSuiteAuthAPI.getPreAuthCode(accessToken.getAccessToken());
			
			url = SuiteUtils.qy_reg_url.replace("SUITE_ID", ProviderConstantUtils.suiteId).replace("PRE_AUTH_CODE", pre_auth_code).replace("REDIRECT_URI", SuiteUtils.redirect_uri).replace("STATE", ProviderConstantUtils.state);
		}
		
		return "redirect:"+url;
	}
	
	/**
	 * 用户确认授权后，进入回调
	 * 用户确认授权后，会进入回调URI(即redirect_uri)，并在URI参数中带上临时授权码、过期时间以及state参数。第三方服务商据此获得临时授权码。回调地址为：
	 * redirect_uri?auth_code=xxx&expires_in=600&state=xx
	 * @param auth_code 临时授权码 临时授权码10分钟后会失效，第三方服务商需尽快使用临时授权码换取永久授权码及授权信息。
	 * @param expires_in
	 * @param state
	 * @return
	 */
	@RequestMapping(value="redirect")
	public String redirect(String auth_code, String expires_in, String state) {
		
		try {
			
			//校验，防止跨域攻击
			if(StringUtils.isBlank(state) || !ProviderConstantUtils.state.equals(state)){				
				return null;
			}
			
			logger.info("用户确认授权后，进入回调。auth_code："+auth_code +"，expires_in："+expires_in+"，state："+state);
			
			//使用临时授权码换取授权方的永久授权码，并换取授权信息、企业access_token，临时授权码一次有效。建议第三方以userid为主键，来建立自己的管理员账号
			if(StringUtils.isNotBlank(auth_code)){
				
				//获取企业永久授权信息
				PermanentInfo permanentInfo = SuiteUtils.createAuthCorp(auth_code);
				
				//授权成功
				if(permanentInfo != null){
					
					//用户登录JavaFast
					authLogin(permanentInfo.getAuthCorpInfo().getCorpid(), permanentInfo.getAuthUserInfo().getUserid());
					
					//进入首页
					return "redirect:"+Global.getAdminPath()+"/login/?repage";
				}
			}
		} catch (Exception e) {
            e.printStackTrace();
        }
		return null;
	}
	
	/**
	 * 授权登录javafast系统
	 * @param corpId 企业ID
	 * @param userId 用户ID
	 */
	public void authLogin(String corpId, String userId) {
		
		SysAccount sysAccount = sysAccountService.findUniqueByProperty("corpid", corpId);
		if(sysAccount != null){
			
			//当用户存在于多家企业的时候，根据企业ID和userId获取唯一
			User user = userService.findUserByWorkWechat(sysAccount.getId(), userId);
			
			if(user != null && StringUtils.isNotBlank(user.getLoginName())){
				
				Subject subject = SecurityUtils.getSubject();
				
				UsernamePasswordToken token = new UsernamePasswordToken();
				token.setLoginType("2");//企业微信授权登录
				token.setUsername(user.getLoginName());
				subject.login(token);
			}
		}
	}
}
