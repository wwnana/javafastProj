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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonBorrow;
import com.javafast.modules.oa.entity.OaCommonExpense;
import com.javafast.modules.oa.entity.OaCommonExtra;
import com.javafast.modules.oa.entity.OaCommonLeave;
import com.javafast.modules.oa.entity.OaCommonTravel;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonBorrowService;
import com.javafast.modules.oa.service.OaCommonExpenseService;
import com.javafast.modules.oa.service.OaCommonExtraService;
import com.javafast.modules.oa.service.OaCommonFlowService;
import com.javafast.modules.oa.service.OaCommonLeaveService;
import com.javafast.modules.oa.service.OaCommonTravelService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/oa/oaCommonAudit")
public class MobileCommonAuditController extends BaseController {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@Autowired
	private OaCommonFlowService oaCommonFlowService;
	
	@Autowired
	private OaCommonBorrowService oaCommonBorrowService;
	
	@Autowired
	private OaCommonExpenseService oaCommonExpenseService;
	
	@Autowired
	private OaCommonLeaveService oaCommonLeaveService;
	
	@Autowired
	private OaCommonTravelService oaCommonTravelService;
	
	@Autowired
	private OaCommonExtraService oaCommonExtraService;
	
	@ModelAttribute
	public OaCommonAudit get(@RequestParam(required=false) String id) {
		OaCommonAudit entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonAuditService.get(id);
		}
		if (entity == null){
			entity = new OaCommonAudit();
		}
		return entity;
	}
	
	/**
	 * 审批流程列表页面
	 */
	@RequestMapping(value = "list")
	public String list(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/oa/oaCommonAuditList";
	}
	
	/**
	 * 
	 * @param oaCommonAudit
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaCommonAudit.setSelf(true);
		Page<OaCommonAudit> page = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response), oaCommonAudit); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param oaCommonAudit
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(OaCommonAudit oaCommonAudit, Model model) {		
		model.addAttribute("oaCommonAudit", oaCommonAudit);
		return "modules/oa/oaCommonAuditSearch";
	}
	
	/**
	 * 查看审批流程页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonAudit oaCommonAudit, Model model) {
		
		//标记已读
		oaCommonAuditService.updateReadFlag(oaCommonAudit.getId(), UserUtils.getUser());
		
		oaCommonAudit = oaCommonAuditService.get(oaCommonAudit.getId());//从数据库取出记录的值		
		model.addAttribute("oaCommonAudit", oaCommonAudit);
		
		// 审批类型   审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单
		if("1".equals(oaCommonAudit.getType())){
			OaCommonLeave oaCommonLeave = oaCommonLeaveService.get(oaCommonAudit.getId());
			model.addAttribute("oaCommonLeave", oaCommonLeave);
		}
		if("2".equals(oaCommonAudit.getType())){
			OaCommonExpense oaCommonExpense = oaCommonExpenseService.get(oaCommonAudit.getId());
			model.addAttribute("oaCommonExpense", oaCommonExpense);
		}
		if("3".equals(oaCommonAudit.getType())){
			OaCommonTravel oaCommonTravel = oaCommonTravelService.get(oaCommonAudit.getId());
			model.addAttribute("oaCommonTravel", oaCommonTravel);
		}
		if("4".equals(oaCommonAudit.getType())){
			OaCommonBorrow oaCommonBorrow = oaCommonBorrowService.get(oaCommonAudit.getId());
			model.addAttribute("oaCommonBorrow", oaCommonBorrow);
		}
		if("5".equals(oaCommonAudit.getType())){
			OaCommonExtra oaCommonExtra = oaCommonExtraService.get(oaCommonAudit.getId());
			model.addAttribute("oaCommonExtra", oaCommonExtra);
		}
		
		return "modules/oa/oaCommonAuditView";
	}

	/**
	 * 提交审批流程
	 */
	@RequestMapping(value = "save")
	public String save(OaCommonAudit oaCommonAudit, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, oaCommonAudit)){
			return view(oaCommonAudit, model);
		}
		
		try{
		
			if(!oaCommonAudit.getIsNewRecord()){//编辑表单提交				
				OaCommonAudit t = oaCommonAuditService.get(oaCommonAudit.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonAudit, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonAuditService.save(t);//提交
			}else{
				
				//新增表单提交
				oaCommonAudit.setOffice(UserUtils.getUser().getOffice());
				oaCommonAuditService.save(oaCommonAudit, request.getContextPath()+Global.getAdminPath());//提交
			}
			
			addMessage(redirectAttributes, "提交审批流程成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交审批流程失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/mobile/oa/oaCommonAudit/list?repage";
		}
	}
	
	/**
	 * 审批
	 */
	@RequestMapping(value = "audit")
	public String audit(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaCommonAudit)){
			return view(oaCommonAudit, model);
		}
		
		try{
			
			String auditStatus = request.getParameter("auditStatus");
			String auditNote = request.getParameter("auditNote");
			System.out.println(auditStatus);
			oaCommonAuditService.audit(oaCommonAudit.getId(), auditStatus, auditNote, UserUtils.getUser());//审批
			
			//站内信，通知下一审批人
			String title = UserUtils.getUser().getName()+"发起的申请，请查看!";
			String content = UserUtils.getUser().getName()+"发起的申请：<a href=\""+request.getContextPath()+Global.getAdminPath()+"/oa/oaCommonAudit/view?id="+oaCommonAudit.getId()+"\">"+oaCommonAudit.getTitle()+"</a> ，请审批！";
			System.out.println(content);
			MailUtils.sendMail(title, content, oaCommonAudit.getCurrentBy().getId());
			
			addMessage(redirectAttributes, "审批流程提交成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审批流程提交失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/mobile/oa/oaCommonAudit/list?repage";
		}
	}
}
