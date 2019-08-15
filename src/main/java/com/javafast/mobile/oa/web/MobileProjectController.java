package com.javafast.mobile.oa.web;

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
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.service.OaProjectService;

/**
 * 
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/oa/oaProject")
public class MobileProjectController extends BaseController {

	@Autowired
	private OaProjectService oaProjectService;
	
	@ModelAttribute
	public OaProject get(@RequestParam(required=false) String id) {
		OaProject entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaProjectService.get(id);
		}
		if (entity == null){
			entity = new OaProject();
		}
		return entity;
	}
	
	/**
	 * 项目列表页面
	 */
	@RequiresPermissions("oa:oaProject:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaProject oaProject, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaProjectList";
	}
	
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OaProject oaProject, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProject> page = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		return JsonMapper.getInstance().toJson(page);
	}

	/**
	 * 查看项目页面
	 */
	@RequiresPermissions(value="oa:oaProject:view")
	@RequestMapping(value = "view")
	public String view(OaProject oaProject, Model model) {
		model.addAttribute("oaProject", oaProject);
		return "modules/oa/oaProjectView";
	}
}
