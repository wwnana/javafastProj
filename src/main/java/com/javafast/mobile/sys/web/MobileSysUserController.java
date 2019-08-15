package com.javafast.mobile.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;

/**
 * 用户
 * @author
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/sys/sysUser")
public class MobileSysUserController extends BaseController {
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public User get(@RequestParam(required=false) String id) {
		User entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = userService.get(id);
		}
		if (entity == null){
			entity = new User();
		}
		return entity;
	}
	
	/**
	 *列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/sys/sysUserList";
	}
	
	/**
	 * 加载数据
	 * @param User
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<User> page = userService.findPage(new Page<User>(request, response), user); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查看
	 */
	@RequestMapping(value = "view")
	public String view(User user, Model model) {
		model.addAttribute("user", user);
		return "modules/sys/sysUserView";
	}
}
