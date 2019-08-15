package com.javafast.modules.qws.receive;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.servlet.http.HttpServletRequest;
import com.javafast.api.qywxs.oauth.api.SuiteOauthUserAPI;
import com.javafast.api.qywxs.oauth.entity.OauthUserDetail;
import com.javafast.api.qywxs.oauth.entity.OauthUserInfo;
import com.javafast.modules.qws.utils.SuiteUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywxs.core.api.WxProviderAccessTokenAPI;
import com.javafast.api.qywxs.sso.api.SuiteUserAPI;
import com.javafast.api.qywxs.sso.entity.LoginUserInfo;
import com.javafast.common.web.BaseController;
import com.javafast.modules.qws.utils.ProviderConstantUtils;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.security.UsernamePasswordToken;
import com.javafast.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 企业微信授权登录
 * 
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/wechat/login")
public class QywxLoginController extends BaseController {

	private static final Logger logger = LoggerFactory.getLogger(QywxLoginController.class);

	@Autowired
	private UserService userService;

	@Autowired
	private SysAccountService sysAccountService;

	/**
	 * 引导用户进入登录授权页 把企业微信登录的URL放官网：http://crm.qikucrm.com/jf/wechat/login/qrcode
	 * @param userType 支持登录的类型。admin代表管理员登录（使用微信扫码）,member代表成员登录（使用企业微信扫码），默认为admin
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "qrcode")
	public String qrcode(String userType) throws UnsupportedEncodingException {

		//1.如果已经登录，则跳转到管理首页
		Principal principal = UserUtils.getPrincipal();		
		if (principal != null) {
			return "redirect:" + adminPath;
		}

		//2.进入企业微信登录授权
		String redirect_uri = URLEncoder.encode(ProviderConstantUtils.qrcode_login_redirect_url, "GBK");

		String url = "https://open.work.weixin.qq.com/wwopen/sso/3rd_qrConnect?appid=" + ProviderConstantUtils.corpId
				+ "&redirect_uri=" + redirect_uri + "&state=" + ProviderConstantUtils.state + "&usertype=" + userType;

		System.out.println(url);
		return "redirect:" + url;
	}

	/**
	 * 授权后回调URI，得到授权码和过期时间
	 * 
	 * @return
	 */
	@RequestMapping(value = "redirect")
	public String redirect(HttpServletRequest request) {

		System.out.println("====企业微信自动登录=====");

		// 1.如果已经登录，则跳转到管理首页
		Principal principal = UserUtils.getPrincipal();
		if (principal != null) {
			return "redirect:" + adminPath;
		}

		try {

			// 授权码
			String authCode = request.getParameter("auth_code");
			if(StringUtils.isNotBlank(authCode)){
				
				System.out.println("授权码：" + authCode);

				// 获取服务商provider_access_token
				AccessToken providerAccessToken = WxProviderAccessTokenAPI.getAccessToken(ProviderConstantUtils.corpId,
						ProviderConstantUtils.providerSecret);

				// 利用授权码获取登录用户信息
				LoginUserInfo loginUserInfo = SuiteUserAPI.getLoginInfo(providerAccessToken.getAccessToken(), authCode);

				if (loginUserInfo != null) {

					// 用户登录JavaFast
					System.out.println("=========微信授权登录回调，企业ID：" + loginUserInfo.getCorpInfo().getCorpid());
					authLogin(loginUserInfo.getCorpInfo().getCorpid(), loginUserInfo.getUserInfo().getUserid());

					// 跳转到应用主页
					return "redirect:" + adminPath;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 跳转到应用主页
		return "redirect:" + adminPath;
	}

	/**
	 * 企业微信应用内登录 
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "app")
	public String app(HttpServletRequest request) {

		// 1.如果已经登录，则跳转到管理首页
		Principal principal = UserUtils.getPrincipal();
		if (principal != null) {
			return "redirect:" + adminPath;
		}

		// 2.获取第三方套件ID
		String appid = request.getParameter("appid");
		logger.info("企业微信应用内登录,appid:" + appid);

		try {

			//3.网页授权登录第三方
			//构造第三方oauth2链接
			//appid 第三方应用id（即ww或wx开头的suite_id）。注意与企业的网页授权登录不同
			//redirect_uri授权后重定向的回调链接地址，请使用urlencode对链接进行处理 ，注意域名需要设置为第三方应用的可信域名
			//response_type返回类型，此时固定为：code
			//scope应用授权作用域。
			//snsapi_base：静默授权，可获取成员的基础信息（UserId与DeviceId）；
			//snsapi_userinfo：静默授权，可获取成员的详细信息，但不包含手机、邮箱；
			//snsapi_privateinfo：手动授权，可获取成员的详细信息，包含手机、邮箱。
			//agentid 企业应用的id。当scope是snsapi_userinfo或snsapi_privateinfo时，该参数必填注意redirect_uri的域名必须与该应用的可信域名一致。
			
			String redirect_uri = URLEncoder.encode(ProviderConstantUtils.mobile_login_redirect_url, "GBK");
			String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appid + "&redirect_uri="
					+ redirect_uri + "&response_type=code&scope=snsapi_userinfo&state=" + appid + "#wechat_redirect";
			return "redirect:" + url;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * 企业微信应用内登录回调
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "appredirect")
	public String mobileredirect(HttpServletRequest request) {

		System.out.println("企业微信应用内登录回调 ");
		// 1.如果已经登录，则跳转到管理首页
		Principal principal = UserUtils.getPrincipal();
		if (principal != null) {
			System.out.println("用户已经登录过了 ");
			return "redirect:" + adminPath;
		}

		try {

			// 2.第三方根据code获取企业成员信息
			String code = request.getParameter("code");//通过成员授权获取到的code，最大为512字节。每次成员授权带上的code将不一样，code只能使用一次，5分钟未被使用自动过期。
			String sate = request.getParameter("state");
			System.out.println("企业微信应用内登录回调，code:" + code);

			AccessToken accessToken = SuiteUtils.getSuiteAccessToken();
			// 3.利用授权码获取登录用户信息
			OauthUserInfo authUserInfo = SuiteOauthUserAPI.getOauthUserInfo(accessToken.getAccessToken(), code);
			if (authUserInfo != null) {

				// 4.获取用户详情
				updateUserDeTail(accessToken.getAccessToken(), authUserInfo.getUser_ticket());

				// 5.用户登录JavaFast
				System.out.println("=========企业微信应用内登录回调，企业ID：" + authUserInfo.getCorpId() + ",企业userId:"
						+ authUserInfo.getUserId());
				authLogin(authUserInfo.getCorpId(), authUserInfo.getUserId());

				// 跳转到应用主页
				return "redirect:" + adminPath;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 跳转到应用主页
		return "redirect:" + adminPath;
	}

	/**
	 * 授权登录javafast系统
	 * 
	 * @param corpId
	 *            企业ID
	 * @param userId
	 *            用户ID
	 */
	public void authLogin(String corpId, String userId) {

		SysAccount sysAccount = sysAccountService.findUniqueByProperty("corpid", corpId);
		if (sysAccount != null) {

			// 当用户存在于多家企业的时候，根据企业ID和userId获取唯一
			User user = userService.findUserByWorkWechat(sysAccount.getId(), userId);

			if (user != null && StringUtils.isNotBlank(user.getLoginName())) {

				Subject subject = SecurityUtils.getSubject();

				UsernamePasswordToken token = new UsernamePasswordToken();
				token.setLoginType("2");// 企业微信授权登录
				token.setUsername(user.getLoginName());
				subject.login(token);
			}
		}
	}

	/**
	 * 更新用户详情
	 * 
	 * @param suiteAccessToken
	 * @param userTicket
	 */
	public void updateUserDeTail(String suiteAccessToken, String userTicket) {

		System.out.println("userTicket="+userTicket);
		
		if(StringUtils.isNotBlank(userTicket)){
			// 获取用户详情
			OauthUserDetail oauthUserDetail = SuiteOauthUserAPI.getUserDetail(suiteAccessToken, userTicket);
			if (oauthUserDetail != null && StringUtils.isNotBlank(oauthUserDetail.getMobile())) {

				System.out.println("企业微信应用内登录回调获取用户详情name:"+oauthUserDetail.getName()+"，mobile:" + oauthUserDetail.getMobile());

				SysAccount sysAccount = sysAccountService.findUniqueByProperty("corpid", oauthUserDetail.getCorpid());
				if (sysAccount != null) {

					// 当用户存在于多家企业的时候，根据企业ID和userId获取唯一
					User user = userService.findUserByWorkWechat(sysAccount.getId(), oauthUserDetail.getUserid());

					if (user != null) {

						String defaultAvatar = "https://rescdn.qqmail.com/node/wwmng/wwmng/style/images/independent/DefaultAvatar$73ba92b5.png";
						
						if(StringUtils.isBlank(user.getMobile()) || StringUtils.isBlank(user.getPhoto()) || "/static/images/user.jpg".equals(user.getPhoto()) || defaultAvatar.equals(user.getPhoto())){
							
							System.out.println("更新用户详情");
							
							if (StringUtils.isNotBlank(oauthUserDetail.getMobile()))
								user.setMobile(oauthUserDetail.getMobile());
							if (StringUtils.isNotBlank(oauthUserDetail.getAvatar()))
								user.setPhoto(oauthUserDetail.getAvatar());
							if (StringUtils.isNotBlank(oauthUserDetail.getEmail()))
								user.setEmail(oauthUserDetail.getEmail());
							user.setQrCode(oauthUserDetail.getQr_code());

							userService.updateUserInfo(user);
						}
					}
				}
			}
		}		
	}
}
