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
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaTaskService;

@Controller
@RequestMapping(value = "${adminPath}/mobile/oa/oaTask")
public class MobileTaskController extends BaseController {

	
	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public OaTask get(@RequestParam(required=false) String id) {
		OaTask entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaTaskService.get(id);
		}
		if (entity == null){
			entity = new OaTask();
		}
		return entity;
	}
	
	/**
	 * 任务列表页面
	 */
	@RequiresPermissions("oa:oaTask:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaTask oaTask, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaTaskList";
	}
	
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OaTask oaTask, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaTask> page = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查看
	 */
	@RequiresPermissions(value="oa:oaTask:view")
	@RequestMapping(value = "view")
	public String view(OaTask oaTask, Model model) {

		//更新阅读状态
		if (StringUtils.isNotBlank(oaTask.getId())){
			oaTaskService.updateReadFlag(oaTask);
		}
				
		model.addAttribute("oaTask", oaTask);
		return "modules/oa/oaTaskView";
	}
}
