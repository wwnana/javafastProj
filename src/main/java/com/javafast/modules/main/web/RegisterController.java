package com.javafast.modules.main.web;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.google.common.collect.Lists;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.json.AjaxJson;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.main.utils.InitDataUtils;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SysSmsService;
import com.javafast.modules.sys.service.UserService;

/**
 * 注册Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/register")
public class RegisterController extends BaseController {

	@Autowired
	private SysAccountService sysAccountService;
	
	@Autowired
	private SysSmsService sysSmsService;
	
	@Autowired
	private UserDao userDao;
	
	/**
	 * 登陆、注册、密码找回页
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"index",""})
	public String register(User user, Model model) {
		return "modules/main/register";
	}
	
	/**
	 * 用户协议
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "agree")
	public String agree(User user, Model model) {
		return "modules/main/agree";
	}
	
	/**
	 * 获取企业编号
	 * @return
	 */
	public String getCompanyNo(){
		
		String companyNo = String.valueOf((int) (Math.random() * 9000 + 1000));//企业编号自动生成					
		//校验企业编号是否已被注册
		if(sysAccountService.get(companyNo) != null){
			companyNo = this.getCompanyNo();
		}
		return companyNo;
	}
	
	/**
	 * 注册
	 * @param request
	 * @param response
	 * @param mobileLogin 登录名
	 * @param randomCode 验证码
	 * @param roleName 角色名称
	 * @param user 用户
	 * @param model 手机
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "registerUser")
	public String registerUser(HttpServletRequest request,HttpServletResponse response, boolean mobileLogin, String mobile, String randomCode, String loginPass, String companyName, Model model, RedirectAttributes redirectAttributes) {
			
		try{
			
			String companyNo = getCompanyNo();
			
			//非空校验
			if(StringUtils.isBlank(companyName) || StringUtils.isBlank(companyNo) || StringUtils.isBlank(mobile) || StringUtils.isBlank(loginPass)){
				addMessage(model, "信息填写不正确!");
				return register(new User(), model);
			}
			
			//验证短信内容
			if(!randomCode.equals(request.getSession().getServletContext().getAttribute(mobile))){
				// 如果是手机登录，则返回JSON字符串
				if (mobileLogin){
					AjaxJson j = new AjaxJson();
					j.setSuccess(false);
					j.setErrorCode("3");
					j.setMsg("手机验证码不正确!");
			        return renderString(response, j.getJsonStr());
				}else{
					addMessage(model, "手机验证码不正确!");
					return register(new User(), model);
				}
			}
			
			//验证手机号是否已经注册		
			if(userDao.findUniqueByProperty("mobile", mobile) != null){
				// 如果是手机登录，则返回JSON字符串
				if (mobileLogin){
					AjaxJson j = new AjaxJson();
					j.setSuccess(false);
					j.setErrorCode("1");
					j.setMsg("手机号已经被使用！");
			        return renderString(response, j.getJsonStr());
				}else{
					addMessage(model, "手机号已经被使用!");
					return register(new User(), model);
				}
			}
			
			//验证用户是否已经注册		
			if(userDao.findUniqueByProperty("login_name", mobile) != null){
				// 如果是手机登录，则返回JSON字符串
				if (mobileLogin){
					AjaxJson j = new AjaxJson();
					j.setSuccess(false);
					j.setErrorCode("2");
					j.setMsg("用户名已经被注册！");
			        return renderString(response, j.getJsonStr());
				}else{
					addMessage(model, "用户名已经被注册!");
					return register(new User(), model);
				}
			}
			
			//企业信息
			SysAccount sysAccount = new SysAccount();
			sysAccount.setId(companyNo);//企业编号			
			sysAccount.setName(companyName);//企业名称
			sysAccount.setSystemName(companyName);//系统名称
			sysAccount.setMobile(mobile);//注册手机
			sysAccount.setMaxUserNum(200);
			sysAccount.setNowUserNum(1);			
			
			//管理员信息
			User adminUser = new User();
			adminUser.setName("管理员");
			adminUser.setNo("1");
			adminUser.setLoginName(mobile);//账号
			adminUser.setPassword(UserService.entryptPassword(loginPass));//密码
			adminUser.setMobile(mobile);//手机
			adminUser.setPhoto("/static/images/user.jpg");
			
			//企业开户
			sysAccountService.createSysAccount(sysAccount, adminUser);			
			System.out.println("企业开户执行完成，企业ID："+sysAccount.getId()+", 管理员ID："+adminUser.getId());
			
			//初始化企业数据
			InitDataUtils.initData(sysAccount, adminUser);
			System.out.println("初始化企业数据完成");
			
			//清除session中存储的验证码
			request.getSession().getServletContext().removeAttribute(mobile);
			
			//短信通知
			if(SmsUtils.sendRegMsgSms(mobile, companyNo, mobile, loginPass)){
				
				SysSms sysSms = new SysSms();
				sysSms.setSmsType("1"); //短信类型 0注册验证码， 1注册成功通知， 3密码找回验证码，4，密码重置成功通知
				sysSms.setMobile(mobile);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("恭喜您注册成功！您的个人登录账号："+mobile+"，登录密码："+loginPass+"，请妥善保管。");
				sysSmsService.save(sysSms);
			}
			
			// 如果是手机登录，则返回JSON字符串
			if (mobileLogin){
				AjaxJson j = new AjaxJson();
				j.setSuccess(true);
				j.setMsg("注册用户'" + mobile + "'成功");
				j.setMsg("恭喜您注册成功！您的个人登录账号："+mobile+"，登录密码："+loginPass+"，请妥善保管。");
		        return renderString(response, j);
			}
			
			addMessage(redirectAttributes, "恭喜您注册成功！<br>您的个人登录账号："+mobile+"，登录密码："+loginPass+"，请妥善保管。");
			return "redirect:" + adminPath + "/login";
		}catch(Exception e){
			e.printStackTrace();
			request.setAttribute("msg", "注册失败");
			return "redirect:" + adminPath + "/sys/register";
		}
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
	@RequestMapping(value = "getRegisterCode")
	@ResponseBody
	public AjaxJson getRegisterCode(HttpServletRequest request,HttpServletResponse response, String mobile, Model model, RedirectAttributes redirectAttributes) {
				
		AjaxJson j = new AjaxJson();
		
		//验证手机号是否已经注册
		if(userDao.findUniqueByProperty("mobile", mobile) != null){
			
			j.setSuccess(false);
			j.setErrorCode("1");
			j.setMsg("手机号已经被使用！");
	        return j;
		}
				
		try {
			
			//生成随机4位验证码
			String randomCode = String.valueOf((int) (Math.random() * 9000 + 1000));
			
			boolean flag = SmsUtils.sendVerifCodeSms(mobile, randomCode);
			if(flag){
				
				j.setSuccess(true);
				j.setErrorCode("-1");
				j.setMsg("短信发送成功!");
				
				//把验证码存入session
				request.getSession().getServletContext().setAttribute(mobile, randomCode);
				
				System.out.println("验证码："+mobile+","+randomCode);
				
				//记录验证码
				SysSms sysSms = new SysSms();
				sysSms.setSmsType("0"); //短信类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 ， 4：密码重置成功通知，    6:验证码登陆验证码
				sysSms.setMobile(mobile);
				sysSms.setCode(randomCode);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("您的手机验证码为："+randomCode+"，5分钟内有效");
				sysSmsService.save(sysSms);
			}else{
				
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
	
	
	/**
	 * web端ajax验证手机验证码是否正确
	 */
	@ResponseBody
	@RequestMapping(value = "validateMobileCode")
	public boolean validateMobileCode(HttpServletRequest request,
			String mobile, String randomCode) {
		if (randomCode.equals(request.getSession().getServletContext().getAttribute(mobile))) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 忘记密码，通过手机号找回
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "forgetPwd")
	public String forgetPwd(Model model) {
		return "modules/main/forgetPwd";
	}
}
