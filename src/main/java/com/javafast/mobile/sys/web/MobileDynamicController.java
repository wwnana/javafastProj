package com.javafast.mobile.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
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
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;

/**
 * 动态
 * @author
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/sys/sysDynamic")
public class MobileDynamicController extends BaseController {
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public SysDynamic get(@RequestParam(required=false) String id) {
		SysDynamic entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysDynamicService.get(id);
		}
		if (entity == null){
			entity = new SysDynamic();
		}
		return entity;
	}
	
	/**
	 *动态列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/sys/sysDynamicList";
	}
	
	/**
	 * 加载数据
	 * @param sysDynamic
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(SysDynamic sysDynamic, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysDynamic> page = sysDynamicService.findPage(new Page<SysDynamic>(request, response), sysDynamic); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查看
	 */
	@RequestMapping(value = "view")
	public String view(SysDynamic sysDynamic, Model model) {
		model.addAttribute("sysDynamic", sysDynamic);
		return "modules/sys/sysDynamicView";
	}
}
