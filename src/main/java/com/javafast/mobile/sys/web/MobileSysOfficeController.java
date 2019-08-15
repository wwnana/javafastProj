package com.javafast.mobile.sys.web;

import java.util.ArrayList;
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

import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.OfficeService;
import com.javafast.modules.sys.service.UserService;

/**
 * 用户
 * @author
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/sys/sysOffice")
public class MobileSysOfficeController extends BaseController {
	
	@Autowired
	private OfficeService officeService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public Office get(@RequestParam(required=false) String id) {
		Office entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = officeService.get(id);
		}
		if (entity == null){
			entity = new Office();
		}
		return entity;
	}
	
	/**
	 *列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(Office office, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		List<Office> list = new ArrayList<Office>();
		List<Office> officeList = null;
		if(office.getParent() != null) {
			
			officeList = officeService.findOfficeList(office);
		}else{
			officeList = officeService.findList(false);
		}		
		for(int i=0; i<officeList.size(); i++){
			Office sysOffice = officeList.get(i);
			List<User> userList = userService.findUserByOfficeId(sysOffice.getId());
			sysOffice.setUserList(userList);
			sysOffice.setUserNum(userList.size());
			list.add(sysOffice);
		}
			
		model.addAttribute("list", list);
		
		//查本部门下的用户
		if(office.getParent() != null) {
			
			List<User> userList = userService.findUserByOfficeId(office.getParent().getId());
			model.addAttribute("userList", userList);
		}
		model.addAttribute("office", office);
		
		return "modules/sys/sysOfficeList";
	}
	
	/**
	 * 查看
	 */
	@RequestMapping(value = "view")
	public String view(Office office, Model model) {
		model.addAttribute("office", office);
		return "modules/sys/sysOfficeView";
	}
}
