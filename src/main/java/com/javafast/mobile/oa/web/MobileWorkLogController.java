package com.javafast.mobile.oa.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.oa.entity.OaWorkLogRecord;
import com.javafast.modules.oa.service.OaWorkLogService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/mobile/oa/oaWorkLog")
public class MobileWorkLogController extends BaseController {

	@Autowired
	private OaWorkLogService oaWorkLogService;
	
	@ModelAttribute
	public OaWorkLog get(@RequestParam(required=false) String id) {
		OaWorkLog entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaWorkLogService.get(id);
		}
		if (entity == null){
			entity = new OaWorkLog();
		}
		return entity;
	}
	
	/**
	 * 查询自己提交的
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaWorkLogList2";
	}
	
	/**
	 * 工作报告列表查询 查询自己提交的
	 * @param oaWorkLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaWorkLog.setCreateBy(UserUtils.getUser());
		Page<OaWorkLog> page = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response), oaWorkLog); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询自己有权限查看的
	 */
	@RequestMapping(value = "self")
	public String self(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaWorkLogList";
	}
	
	/**
	 * 工作报告列表查询 查询自己有权限查看的
	 * @param oaWorkLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "selfData")
	public String selfData(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaWorkLog.setSelf(true);
		Page<OaWorkLog> page = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response), oaWorkLog); 
		return JsonMapper.getInstance().toJson(page);
	}

	/**
	 * 查询页面
	 * @param oaWorkLog
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(OaWorkLog oaWorkLog, Model model) {
		model.addAttribute("oaWorkLog", oaWorkLog);
		return "modules/oa/oaWorkLogSearch";
	}
	
	
	/**
	 * 编辑工作报告表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaWorkLog oaWorkLog, Model model) {
		
		if(oaWorkLog.getIsNewRecord()){
			oaWorkLog.setTitle(DateUtils.getDate()+" 工作汇报");
			oaWorkLog.setWorkLogType("1");
		}
		model.addAttribute("oaWorkLog", oaWorkLog);
		return "modules/oa/oaWorkLogForm";
	}
	
	/**
	 * 查看工作报告页面
	 */
	@RequestMapping(value = "view")
	public String view(OaWorkLog oaWorkLog, Model model) {
		
		if (StringUtils.isNotBlank(oaWorkLog.getId())){
			
			if(!UserUtils.getUser().getId().equals(oaWorkLog.getCreateBy().getId())){
				//更新查阅信息
				oaWorkLogService.updateReadInfo(oaWorkLog, UserUtils.getUser());
				
				//锁定，不能再修改
				oaWorkLog.setStatus("1");
				oaWorkLogService.save(oaWorkLog);//保存
			}
		}
		oaWorkLog = oaWorkLogService.get(oaWorkLog.getId());
		model.addAttribute("oaWorkLog", oaWorkLog);
		return "modules/oa/oaWorkLogView";
	}

	/**
	 * 保存工作报告
	 */
	@RequestMapping(value = "save")
	public String save(OaWorkLog oaWorkLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaWorkLog)){
			return form(oaWorkLog, model);
		}
		
		try{
			
			List<OaWorkLogRecord> oaWorkLogRecordList = Lists.newArrayList();
			if(oaWorkLog.getAuditBy() != null && StringUtils.isNotBlank(oaWorkLog.getAuditBy().getId())){
				OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
				oaWorkLogRecord.setUser(new User(oaWorkLog.getAuditBy().getId()));
				oaWorkLogRecordList.add(oaWorkLogRecord);
			}
			oaWorkLog.setOaWorkLogRecordList(oaWorkLogRecordList);
		
			if(!oaWorkLog.getIsNewRecord()){//编辑表单保存				
				OaWorkLog t = oaWorkLogService.get(oaWorkLog.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaWorkLog, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaWorkLogService.save(t);//保存
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_WORKLOG, Contants.ACTION_TYPE_UPDATE, oaWorkLog.getId(), oaWorkLog.getTitle(), null);
			}else{
				
				//新增表单保存
				oaWorkLog.setStatus("0");
				oaWorkLogService.save(oaWorkLog);//保存
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_WORKLOG, Contants.ACTION_TYPE_ADD, oaWorkLog.getId(), oaWorkLog.getTitle(), null);
			}
			
			addMessage(redirectAttributes, "保存工作报告成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存工作报告失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/mobile/oa/oaWorkLog/?repage";
		}
	}
}
