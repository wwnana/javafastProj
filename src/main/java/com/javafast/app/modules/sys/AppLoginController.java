package com.javafast.app.modules.sys;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.security.Digests;
import com.javafast.common.utils.Encodes;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.main.utils.InitDataUtils;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SysSmsService;
import com.javafast.modules.sys.service.SystemService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;

/**
 * APP接口 登录、注册
 * @author shi
 * @version 2016-10-21
 */
@Controller
public class AppLoginController {

	@Autowired
	private UserService userService;
	
	@Autowired
	private SysSmsService sysSmsService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	/**
	 * 登陆
	 * @param loginName
	 * @param loginPwd
	 * @param machCode 机器码
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/login", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject login(String loginName, String loginPwd, String machCode) {
		

		JSONObject json =new JSONObject();
		json.put("code", "0");
		json.put("msg", "登录失败");
		
		try {
			
			if(StringUtils.isBlank(loginName) || StringUtils.isBlank(loginPwd)){
				json.put("msg", "缺少必要参数");
				return json;
			}
			
			User user = userService.getUserByLoginName(loginName);
			if(user == null){
				json.put("msg", "账号不存在");
				return json;
			}
			
			//校验账号密码是否正确
			String password = entryptPassword(loginPwd, user.getPassword());
			if(!password.equals(user.getPassword())){
				json.put("msg", "账号或密码错误");
				return json;
			}
			
			if("0".equals(user.getLoginFlag())){
				json.put("msg", "您的账号已冻结");
				return json;
			}
			
			if(user != null){
				
				//创建token
				String token = userService.createToken(user, machCode);
				user.setToken(token);
				
				json.put("userId", user.getId());
				json.put("loginName", user.getLoginName());
				json.put("token", user.getToken());
				json.put("userName", user.getName());
				json.put("mobile", user.getMobile());
				json.put("userType", user.getUserType());
				json.put("accountId", user.getAccountId());
				json.put("companyName", user.getCompany().getName());
				json.put("officeName", user.getOffice().getName());
				
				
				if(StringUtils.isNotBlank(user.getPhoto())){
					if(user.getPhoto().contains("http")){
						json.put("photo", user.getPhoto());
					}else{
						json.put("photo", Contants.SITE_URL + user.getPhoto());
					}
				}else{
					json.put("photo", Contants.SITE_URL + Contants.TEMP_USER_IMG);
				}
				
				json.put("code", "1");
				json.put("msg", "登录成功");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 验证码登陆
	 * @param mobile 手机号码
	 * @param verifyCode 验证码
	 * @param machCode 机器码
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/verifyLogin", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject verifyLogin(String mobile, String verifyCode, String machCode) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		json.put("msg", "登录失败");
		
		try {
			
			if(StringUtils.isBlank(mobile) || StringUtils.isBlank(verifyCode)){
				json.put("msg", "缺少必要参数");
				return json;
			}
						
			User user = userService.getByMobile(mobile);
			if(user == null){
				
				json.put("msg", "您的账号不存在，请核对后再输入");
				return json;
			}
			
			//校验短信验证码是否正确	 类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 ， 4：重置支付密码验证码，    6:验证码登陆验证码
			if(!sysSmsService.checkVerifyCode("6", mobile, verifyCode)){
				json.put("msg", "短信验证码不正确");
				return json;
			}	
			
			if("0".equals(user.getLoginFlag())){
				json.put("msg", "您的账号已冻结");
				return json;
			}
			
			//重新获取用户信息（可获取公司、部门等）
			user = userService.get(user.getId());
			
			if(user != null){
				
				//创建token
				String token = userService.createToken(user, machCode);
				user.setToken(token);
				
				json.put("userId", user.getId());
				json.put("loginName", user.getLoginName());
				json.put("token", user.getToken());
				json.put("mobile", user.getMobile());
				json.put("userName", user.getName());
				json.put("userType", user.getUserType());
				json.put("accountId", user.getAccountId());
				json.put("companyName", user.getCompany().getName());
				json.put("officeName", user.getOffice().getName());
				
				if(StringUtils.isNotBlank(user.getPhoto())){
					if(user.getPhoto().contains("http")){
						json.put("photo", user.getPhoto());
					}else{
						json.put("photo", Contants.SITE_URL + user.getPhoto());
					}
				}else{
					json.put("photo", Contants.SITE_URL + Contants.TEMP_USER_IMG);
				}
				
				json.put("code", "1");
				json.put("msg", "登录成功");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}	
	
	/**
	 * 注册
	 * @param mobile
	 * @param password
	 * @param verifyCode
	 * @param company
	 * @param machCode
	 * @param request
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/reg", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject reg(String mobile, String password, String verifyCode, String name, String company, String machCode, HttpServletRequest request) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			//非空校验
			if(StringUtils.isBlank(mobile) || StringUtils.isBlank(password) || StringUtils.isBlank(verifyCode)){
				json.put("msg", "缺少参数");
				return json;
			}
			
			//校验短信验证码是否正确	 类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 ， 4：重置支付密码验证码，    6:验证码登陆验证码
			if(!sysSmsService.checkVerifyCode("0", mobile, verifyCode)){
				json.put("msg", "短信验证码不正确");
				return json;
			}	
				
			User tempUser = userService.getByMobile(mobile);
			if(tempUser != null){
				
				json.put("msg", "手机号码已经被注册");
				return json;
			}
			
			if(StringUtils.isBlank(name)){
				name = "管理员";
			}
					
			
			//企业信息
			String companyNo = getCompanyNo();//获取企业编号	
			SysAccount sysAccount = new SysAccount();
			sysAccount.setId(companyNo);		
			sysAccount.setName(company);//企业名称
			sysAccount.setSystemName(company);//系统名称
			sysAccount.setMobile(mobile);//注册手机
			sysAccount.setMaxUserNum(200);
			sysAccount.setNowUserNum(1);			
			
			//管理员信息
			User adminUser = new User();
			adminUser.setName(name);
			adminUser.setNo("1");
			adminUser.setLoginName(mobile);//账号
			adminUser.setPassword(UserService.entryptPassword(password));//密码
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
			if(SmsUtils.sendRegMsgSms(mobile, companyNo, mobile, password)){
				
				SysSms sysSms = new SysSms();
				sysSms.setSmsType("1"); //短信类型 0注册验证码， 1注册成功通知， 3密码找回验证码，4，密码重置成功通知
				sysSms.setMobile(mobile);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("恭喜您注册成功！您的个人登录账号："+mobile+"，登录密码："+password+"，请妥善保管。");
				sysSmsService.save(sysSms);
			}
			
			json.put("msg", "注册成功");
			json.put("code", "1");			
		} catch (Exception e) {
			json.put("msg", "注册失败");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 密码重置
	 * @param mobile
	 * @param newPassword 新密码
	 * @param verifyCode 短信验证码
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/resetLoginPwd", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject resetLoginPwd(String mobile, String newPassword, String verifyCode, HttpServletRequest req) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			//非空校验
			if(StringUtils.isBlank(mobile) || StringUtils.isBlank(newPassword) || StringUtils.isBlank(verifyCode)){
				json.put("msg", "缺少参数");
				return json;
			}
			
			//校验短信验证码是否正确	
			if(!sysSmsService.checkVerifyCode("3", mobile, verifyCode)){
				json.put("msg", "短信验证码不正确");
				return json;
			}			
						
			User user = userService.getByMobile(mobile);
			if(user == null){
				
				json.put("msg", "您的账号不存在，请核对后再输入");
				return json;
			}
				
			userService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
			
			SmsUtils.sendResetPwdSms(mobile, user.getAccountId(), user.getLoginName(), newPassword);
			
			json.put("code", "1");
		} catch (Exception e) {
			json.put("msg", "重置密码失败");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
		
	/**
	 * 解码
	 * @param inputPasswrod
	 * @param userPassword
	 * @return
	 */
	public String entryptPassword(String inputPasswrod, String userPassword) {
		String plain = Encodes.unescapeHtml(inputPasswrod);
		//byte[] salt = Digests.generateSalt(SALT_SIZE);
		byte[] salt = Encodes.decodeHex(userPassword.substring(0,16));
		byte[] hashPassword = Digests.sha1(plain.getBytes(), salt, 1024);
		return Encodes.encodeHex(salt)+Encodes.encodeHex(hashPassword);
	}
	
	/**
	 * 检测账号是否存在
	 * @param mobile
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/checkUserExit", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject checkUserExit(String mobile) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			User tempUser = userService.get(mobile);
			if(tempUser == null){
				
				json.put("msg", "账号不存在");
				return json;
			}else{
				
				json.put("code", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 发送短信验证码
	 * @param mobile
	 * @param smsType //短信类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 ， 4：密码重置成功通知，    6:验证码登陆验证码
	 * @param machCode
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/opp/sendVerifCodeSms", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject sendVerifCodeSms(String mobile, String smsType, String machCode) {
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			User user = userService.getByMobile(mobile);
			
			//用户注册 ，需要验证手机号是否已经注册
			if("0".equals(smsType)){
				if(user != null){
					json.put("msg", "你的手机号码已注册，请直接登录");
					return json;
				}
			}
			
			//验证码登陆、密码找回，需要验证手机号是否已经注册
			if("3".equals(smsType) || "6".equals(smsType)){
				if(user == null){
					json.put("msg", "您的手机号码未注册，请您注册后再登录");
					return json;
				}
			}
			
			//生成随机4位验证码
			String randomCode = String.valueOf((int) (Math.random() * 9000 + 1000));
			
			boolean flag = SmsUtils.sendVerifCodeSms(mobile, randomCode);
			if(flag){
				
				//记录验证码到数据库
				SysSms sysSms = new SysSms();
				sysSms.setSmsType(smsType); //短信类型      0:注册验证码，1：注册结果通知，  3：密码找回验证码 ， 4：密码重置成功通知，    6:验证码登陆验证码
				sysSms.setMobile(mobile);
				sysSms.setCode(randomCode);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("您的手机验证码为："+randomCode+"，5分钟内有效");
				sysSmsService.save(sysSms);
				
				json.put("msg", "短信发送成功");
			}
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 版本检查
	 * @param appVersion
	 * @param dataType
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/oop/getVersion", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getVersion(String appVersion, String dataType) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			if("4".equals(dataType)){
				
				json.put("msg", "已经是最新版");
				
				//如有更新
				//json.put("code", "1");
			}			
		} catch (Exception e) {
			json.put("code", "0");
			e.printStackTrace();
		} finally {
			return json;
		}
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
	 * 用户协议
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "${adminPath}/sys/register/agree", method = RequestMethod.POST)
	public String contact() {
		return "modules/main/agree";
	}
}