package com.javafast.mobile.oa.web;

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
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.service.OaNotifyService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 通知通告Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/oa/oaNotify")
public class MobileNotifyController extends BaseController {

	@Autowired
	private OaNotifyService oaNotifyService;
	
	@ModelAttribute
	public OaNotify get(@RequestParam(required=false) String id) {
		OaNotify entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaNotifyService.get(id);
		}
		if (entity == null){
			entity = new OaNotify();
		}
		return entity;
	}
	
	@RequestMapping(value = {"list", ""})
	public String list(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaNotifyList";
	}
	
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OaNotify oaNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaNotify.setSelf(true);
		Page<OaNotify> page = oaNotifyService.find(new Page<OaNotify>(request, response), oaNotify);
		return JsonMapper.getInstance().toJson(page);
	}
	
	@RequestMapping(value = "view")
	public String view(OaNotify oaNotify, Model model) {
		oaNotifyService.updateReadFlag(oaNotify, UserUtils.getUser());
		oaNotify = oaNotifyService.getRecordList(oaNotify);
		model.addAttribute("oaNotify", oaNotify);
		return "modules/oa/oaNotifyView";
	}
}
