package com.javafast.app.modules.sys;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.security.Digests;
import com.javafast.common.utils.Encodes;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.OfficeService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;

/**
 * APP接口 用户相关
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/sys/sysUser")
public class AppUserController {

	@Autowired
	private UserService userService;
	
	@Autowired
	private OfficeService officeService;
	
	/**
	 * 根据用户ID获取用户信息
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getUserInfo(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			User entity = userService.getUserByDb(id);
			
			if(StringUtils.isNotBlank(entity.getPhoto())){
				if(!entity.getPhoto().contains("http")){
					entity.setPhoto(Contants.SITE_URL + entity.getPhoto());
				}
			}
			
			json.put("entity", entity);
			
			json.put("companyName", entity.getCompany().getName());
			json.put("officeName", entity.getOffice().getName());
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 更新用户信息
	 * @param name
	 * @param sex
	 * @param job
	 * @param email
	 * @param phone
	 * @param remarks
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "updateUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject updateUserInfo(String name, String sex, String job, String email, String phone, String remarks, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(name)){
				json.put("msg", "缺少参数name");
				return json;
			}
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			User user = userService.getUserByDb(userId);
			user.setName(name);
			user.setEmail(email);
			user.setPhone(phone);
			user.setSex(sex);
			user.setJob(job);
			user.setRemarks(remarks);
			user.setUpdateBy(user);
			userService.updateUserInfo(user);
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 更新用户头像
	 * @param id 用户id
	 * @param photo
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "updateUserPhoto", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject updateUserPhoto(String id, String photoUrl) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			User user = userService.getUserByDb(id);
			
			if(StringUtils.isNotBlank(photoUrl)){
				user.setPhoto(photoUrl);
			}
			userService.updateUserInfo(user);
			
			json.put("photoUrl", photoUrl);
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 修改密码
	 * @param userId
	 * @param oldPassword
	 * @param newPassword
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "updateLoginPwd", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject updateLoginPwd(String userId, String oldPassword, String newPassword) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {
			
			//非空校验
			if(StringUtils.isBlank(oldPassword) || StringUtils.isBlank(newPassword)){
				json.put("msg", "缺少参数");
				return json;
			}
					
			User user = userService.get(userId);
			if(user == null){
				
				json.put("msg", "账号不存在");
				return json;
			}
			
			String loginPwd = entryptPassword(oldPassword, user.getPassword());
			if(!loginPwd.equals(user.getPassword())){
				
				json.put("msg", "原密码不正确");
				return json;
			}
				
			userService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
			
			SmsUtils.sendResetPwdSms(user.getMobile(), user.getAccountId(), user.getLoginName(), newPassword);	
			
			json.put("code", "1");
		} catch (Exception e) {
			json.put("msg", "重置密码失败");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 查询组织架构
	 * @param accountId
	 * @param parentId
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getOfficeList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getOfficeList(String accountId, String officeId, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		Office conOffice = new Office();
		conOffice.setIsApi(true);
		conOffice.setAccountId(accountId);
		
		if(StringUtils.isBlank(officeId)){
			officeId = "0";			
		}
		conOffice.setParent(new Office(officeId));
		List<Office> officeList = officeService.findList(conOffice);
		json.put("officeList", officeList);
		
		List<User> userList = userService.findUserByOfficeId(officeId);
		json.put("userList", userList);
		
		json.put("code", "1");
		return json;
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
}
