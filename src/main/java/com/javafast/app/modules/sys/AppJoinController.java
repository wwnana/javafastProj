package com.javafast.app.modules.sys;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSONObject;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.security.Digests;
import com.javafast.common.utils.Encodes;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
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
 * 邀请同事加入
 * @author shi
 * @version 2016-10-21
 */
@Controller
public class AppJoinController extends BaseController {

	@Autowired
	private UserService userService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	
	@RequestMapping(value = "${adminPath}/sys/register/join")
	public String join(String accountId, String userId, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		User user = userService.get(userId);
		SysAccount sysAccount = sysAccountService.get(accountId);
		model.addAttribute("sysAccount", sysAccount);
		model.addAttribute("user", user);
		return "modules/main/userJoin";
	}
	
	@RequestMapping(value = "${adminPath}/sys/register/doJoin", method = RequestMethod.POST)
	public String doJoin(String accountId, String userId, String mobile, String name, String randomCode, HttpServletRequest request,HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
			
		try{
			
			
			//非空校验
			if(StringUtils.isBlank(mobile) || StringUtils.isBlank(name)){
				addMessage(redirectAttributes, "信息缺失");
				return join(accountId, userId, request,response,model);
			}
			if(!randomCode.equals(request.getSession().getServletContext().getAttribute(mobile))){
				
				addMessage(redirectAttributes, "验证码不正确");
				return join(accountId, userId, request,response,model);
			}
			
			
			
			
			addMessage(redirectAttributes, "您的申请已提交，待管理员审核！");
			model.addAttribute("result", "1");
			model.addAttribute("msg", "申请成功");
			return "redirect:" + adminPath + "/sys/register/userJoin";
		}catch(Exception e){
			e.printStackTrace();
			request.setAttribute("msg", "加入失败");
			return "redirect:" + adminPath + "/sys/register/userJoin";
		}
	}
}