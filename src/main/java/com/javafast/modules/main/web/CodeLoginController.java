package com.javafast.modules.main.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.json.AjaxJson;
import com.javafast.common.utils.CookieUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.security.UsernamePasswordToken;
import com.javafast.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.javafast.modules.sys.service.SysSmsService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 手机短信验证码登录Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/codeLogin")
public class CodeLoginController extends BaseController {

	@Autowired
	private UserService userService;

	@Autowired
	private SysSmsService sysSmsService;

	/**
	 * 微信登录
	 * @param telphoneNum
	 * @return
	 */
	@RequestMapping(value = "wxLogin")
	public String wxLogin(String telphoneNum) {

		Principal principal = UserUtils.getPrincipal();
		// 如果已经登录，则跳转到管理首页
		if (principal != null) {
			return "redirect:" + adminPath;
		}
		
		return "modules/main/login-wx";
	}
	
	@RequestMapping(value = "wxReg")
	public String wxReg(String telphoneNum) {

		return "modules/main/login-wxreg";
	}

	/**
	 * 手机短信验证码登录页面
	 * 
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "index", "" })
	public String register(User user, Model model) {
		
		Principal principal = UserUtils.getPrincipal();
		// 如果已经登录，则跳转到管理首页
		if (principal != null) {
			return "redirect:" + adminPath;
		}
		
		return "modules/main/login-code";
	}

	/**
	 * 登录处理
	 * 
	 * @param request
	 * @param model
	 * @param mobile
	 *            手机号
	 * @param randomCode
	 *            用户输入的短信验证码
	 * @return
	 */
	@RequestMapping(value = "doLogin", method = RequestMethod.POST)
	public String login(HttpServletRequest request, Model model, String mobile, String randomCode) {

		Principal principal = UserUtils.getPrincipal();
		// 如果已经登录，则跳转到管理首页
		if (principal != null) {
			return "redirect:" + adminPath;
		}

		// 校验手机短信验证码是否正确
		if (randomCode.equals(request.getSession().getServletContext().getAttribute(mobile))) {

			try {

				User user = userService.getByMobile(mobile);
				if (user != null) {
					
					user = userService.get(user.getId());

					// 手机短信验证码正确
					Subject subject = SecurityUtils.getSubject();
					UsernamePasswordToken token = new UsernamePasswordToken();
					token.setLoginType("1");// 验证码登录
					token.setUsername(user.getLoginName());
					token.setRememberMe(true);

					// 登录
					subject.login(token);

					return "redirect:" + adminPath;
				}
			} catch (Exception e) {
				e.printStackTrace();
				addMessage(model, "授权出错!");
				return "modules/main/login-code";
			}
		}

		// 手机短信验证码不正确，提示用户
		addMessage(model, "手机验证码不正确!");
		return "modules/main/login-code";
	}

	/**
	 * 获取验证码
	 * @param request
	 * @param response
	 * @param mobile
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "getLoginCode")
	@ResponseBody
	public AjaxJson getLoginCode(HttpServletRequest request, HttpServletResponse response, String mobile, Model model,
			RedirectAttributes redirectAttributes) {

		AjaxJson j = new AjaxJson();

		// 验证手机号是否已经注册
		User user = userService.getByMobile(mobile);
		if (user == null) {

			j.setSuccess(false);
			j.setErrorCode("1");
			j.setMsg("手机号未注册！");
			return j;
		}

		try {

			// 生成随机4位验证码
			String randomCode = String.valueOf((int) (Math.random() * 9000 + 1000));

			boolean flag = SmsUtils.sendVerifCodeSms(mobile, randomCode);
			if (flag) {

				j.setSuccess(true);
				j.setErrorCode("-1");
				j.setMsg("短信发送成功!");

				// 把验证码存入session
				request.getSession().getServletContext().setAttribute(mobile, randomCode);

				System.out.println("登录验证码：" + mobile + "," + randomCode);

				// 记录验证码
				SysSms sysSms = new SysSms();
				sysSms.setSmsType("6"); // 短信类型 0注册验证码， 1注册成功通知，
										// 3密码找回验证码，4，密码重置成功通知 ,6验证码登录
				sysSms.setMobile(mobile);
				sysSms.setCode(randomCode);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("您的手机验证码为：" + randomCode + "，5分钟内有效");
				sysSmsService.save(sysSms);
			} else {

				j.setSuccess(false);
				j.setErrorCode("2");
				j.setMsg("短信发送失败，请联系管理员。");
			}
		} catch (Exception e) {
			j.setSuccess(false);
			j.setErrorCode("3");
			j.setMsg("因未知原因导致短信发送失败，请联系管理员。");
		}
		return j;
	}
}
