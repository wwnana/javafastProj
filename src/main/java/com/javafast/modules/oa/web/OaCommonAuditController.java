package com.javafast.modules.oa.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.hibernate.validator.constraints.Length;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.entity.Office;

import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonBorrow;
import com.javafast.modules.oa.entity.OaCommonExpense;
import com.javafast.modules.oa.entity.OaCommonExtra;
import com.javafast.modules.oa.entity.OaCommonFlow;
import com.javafast.modules.oa.entity.OaCommonLeave;
import com.javafast.modules.oa.entity.OaCommonTravel;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonBorrowService;
import com.javafast.modules.oa.service.OaCommonExpenseService;
import com.javafast.modules.oa.service.OaCommonExtraService;
import com.javafast.modules.oa.service.OaCommonFlowService;
import com.javafast.modules.oa.service.OaCommonLeaveService;
import com.javafast.modules.oa.service.OaCommonTravelService;

/**
 * 审批流程Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonAudit")
public class OaCommonAuditController extends BaseController {

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
	
	//新建流程>流程列表
	@RequestMapping(value = "add")
	public String flowList(OaCommonFlow oaCommonFlow, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		oaCommonFlow.setStatus("0");
		Page<OaCommonFlow> page = oaCommonFlowService.findPage(new Page<OaCommonFlow>(request, response), oaCommonFlow); 
		model.addAttribute("page", page);
		
		return "modules/oa/flowList";
	}
	
	/**
	 * 审批流程列表页面
	 */
	@RequestMapping(value = "index")
	public String index(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		return "modules/oa/oaCommonAuditIndex";
	}
	
	/**
	 * 审批流程列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaCommonAudit.setSelf(true);
		Page<OaCommonAudit> page = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response), oaCommonAudit); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonAuditList";
	}

	/**
	 * 编辑审批流程表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaCommonAudit oaCommonAudit, Model model) {
		
		if(StringUtils.isNotBlank(oaCommonAudit.getOaCommonFlowId())){
			OaCommonFlow oaCommonFlow = oaCommonFlowService.get(oaCommonAudit.getOaCommonFlowId());
			model.addAttribute("oaCommonFlow", oaCommonFlow);
		}
		
		model.addAttribute("oaCommonAudit", oaCommonAudit);
		return "modules/oa/oaCommonAuditForm";
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
			return form(oaCommonAudit, model);
		}
		
		try{
		
			if(!oaCommonAudit.getIsNewRecord()){//编辑表单提交				
				OaCommonAudit t = oaCommonAuditService.get(oaCommonAudit.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonAudit, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonAuditService.save(t);//提交
			}else{
				
				//新增表单提交
				oaCommonAuditService.save(oaCommonAudit, request.getContextPath()+Global.getAdminPath());//提交
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			
			addMessage(redirectAttributes, "提交审批流程成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交审批流程失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/view?id="+oaCommonAudit.getId();
		}
	}
	
	/**
	 * 删除审批流程
	 */
	@RequestMapping(value = "delete")
	public String delete(OaCommonAudit oaCommonAudit, RedirectAttributes redirectAttributes) {
		oaCommonAuditService.delete(oaCommonAudit);
		addMessage(redirectAttributes, "删除审批流程成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/list?repage";
	}
	
	/**
	 * 批量删除审批流程
	 */
	@RequiresPermissions("oa:oaCommonAudit:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonAuditService.delete(oaCommonAuditService.get(id));
		}
		addMessage(redirectAttributes, "删除审批流程成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/list?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonAudit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "审批流程"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonAudit> page = oaCommonAuditService.findPage(new Page<OaCommonAudit>(request, response, -1), oaCommonAudit);
    		new ExportExcel("审批流程", OaCommonAudit.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出审批流程记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/list?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaCommonAudit> list = ei.getDataList(OaCommonAudit.class);
			for (OaCommonAudit oaCommonAudit : list){
				try{
					oaCommonAuditService.save(oaCommonAudit);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条审批流程记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条审批流程记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入审批流程失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/list?repage";
    }
	
	/**
	 * 下载导入审批流程数据模板
	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "审批流程数据导入模板.xlsx";
    		List<OaCommonAudit> list = Lists.newArrayList(); 
    		new ExportExcel("审批流程数据", OaCommonAudit.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/list?repage";
    }
	
	/**
	 * 审批流程列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonAudit, request, response, model);
        return "modules/oa/oaCommonAuditSelectList";
	}
	
	/**
	 * 审批
	 */
	@RequestMapping(value = "audit")
	public String audit(OaCommonAudit oaCommonAudit, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaCommonAudit)){
			return form(oaCommonAudit, model);
		}
		
		try{
			
			String auditStatus = request.getParameter("auditStatus");
			String auditNote = request.getParameter("auditNote");
			System.out.println(auditStatus);
			oaCommonAuditService.audit(oaCommonAudit.getId(), auditStatus, auditNote, UserUtils.getUser());//审批
			
			if("1".equals(oaCommonAudit.getStatus())){
				
				//通知下一审批人
				oaCommonAudit = oaCommonAuditService.get(oaCommonAudit.getId());
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);			
			}
			
			addMessage(redirectAttributes, "审批流程提交成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审批流程提交失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/view?id="+oaCommonAudit.getId();
		}
	}
}