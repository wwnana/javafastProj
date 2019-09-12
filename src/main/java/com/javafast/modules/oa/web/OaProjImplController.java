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

import com.google.common.collect.Lists;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.common.web.BaseController;
import com.javafast.modules.oa.entity.OaProjImpl;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaProjImplService;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 项目实施流程表Controller
 * @author javafast
 * @version 2019-08-20
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaProjImpl")
public class OaProjImplController extends BaseController {

	@Autowired
	private OaProjImplService oaProjImplService;
	@Autowired
	private OaProjectService oaProjectService;
	@Autowired
	private OaTaskService oaTaskService;
	
	@ModelAttribute
	public OaProjImpl get(@RequestParam(required=false) String id) {
		OaProjImpl entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaProjImplService.get(id);
		}
		if (entity == null){
			entity = new OaProjImpl();
		}
		return entity;
	}
	
	/**
	 * 项目实施流程表列表页面
	 */
	@RequiresPermissions("oa:oaProjImpl:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaProjImpl oaProjImpl, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProjImpl> page = oaProjImplService.findPage(new Page<OaProjImpl>(request, response), oaProjImpl); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjImplList";
	}

	/**
	 * 编辑项目实施流程表表单页面
	 */
	@RequiresPermissions(value={"oa:oaProjImpl:view","oa:oaProjImpl:add","oa:oaProjImpl:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaProjImpl oaProjImpl, Model model,RedirectAttributes redirectAttributes) {
		//添加任务前判断项目状态是否处于进行中
		OaProject oaProj = oaProjectService.get(oaProjImpl.getAct().getProjectId());
		if(oaProj!=null && !"1".equals(oaProj.getStatus())) {
			addMessage(redirectAttributes, "当前项目状态未在进行中");
			return "redirect:"+Global.getAdminPath()+"/oa/oaProject/view?id="+oaProjImpl.getAct().getProjectId();
		}
		User currUser = UserUtils.getUser();
		String view="oaProjImplStart";
		//if (StringUtils.isBlank(oaProjImpl.getId())){

			//设置任务的状态为开始
			List<OaTask> oaTaskList = oaTaskService.findTaskByStatus(oaProjImpl.getAct().getProjectId(),"0");
			if(oaTaskList != null && oaTaskList.size()>0) {
				for(OaTask oaTask : oaTaskList) {
					//DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_START, oaTask.getId(), oaTask.getName(), null);
					oaTask.setStatus("1");
					oaTaskService.save(oaTask);
				}
			}
		//}
		
		if (StringUtils.isNotBlank(oaProjImpl.getId())){
			
			// 环节编号
			String taskDefKey = oaProjImpl.getAct().getTaskDefKey();
			// 查看工单
			if(oaProjImpl.getAct().isFinishTask()){
				view = "oaProjImplView";
			}else if("apply_end".equals(taskDefKey)) {
				view = "oaProjImplFinish";
			}
			// 成员提交表单环节
			else if(taskDefKey.contains("form0")||taskDefKey.contains("form2")||taskDefKey.contains("form1")
					||taskDefKey.contains("form5")||taskDefKey.contains("form4")
					||taskDefKey.contains("form6")||"form30".equals(taskDefKey)
					||"form70".equals(taskDefKey)||"form90".equals(taskDefKey)) {
				view = "oaProjImplForm";
			//项目负责人决策
			}else if("judge30".equals(taskDefKey)) {
				view = "oaProjImplJudge";
			}else if(taskDefKey.contains("comm8")) {
				view = "oaProjImplComm";
			}
			//审核环节
			else if(taskDefKey.contains("audit0")||taskDefKey.contains("audit2")
					||taskDefKey.equals("audit40")||taskDefKey.equals("audit60")
					||taskDefKey.equals("audit70")||taskDefKey.contains("audit1")) {
				view = "oaProjImplAudit";
				String status = "form"+taskDefKey.substring(5);
				String procInsId = oaProjImpl.getAct().getProcInsId();
				OaProjImpl oaProjImpl1 = oaProjImplService.findLastTask(procInsId,status);
				oaProjImpl1.setAudit(currUser);
				oaProjImpl1.setAuditName(currUser.getName());
				oaProjImpl1.setUpdateByName(currUser.getName());
				oaProjImpl1.setAct(oaProjImpl.getAct());
				model.addAttribute("oaProjImpl", oaProjImpl1);
				return "modules/oa/"+view;
			}
		}
		oaProjImpl.setProcInsId(oaProjImpl.getAct().getProcInsId());
		oaProjImpl.setProject(oaProjectService.get(oaProjImpl.getAct().getProjectId()));
		oaProjImpl.setStatus(oaProjImpl.getAct().getTaskDefKey());
		oaProjImpl.setUser(currUser);
		oaProjImpl.setUserName(currUser.getName());
		oaProjImpl.setOffice(currUser.getOffice());
		oaProjImpl.setOfficeName(currUser.getOffice().getName());
		oaProjImpl.setCreateByName(currUser.getName());
		oaProjImpl.setUpdateByName(currUser.getName());
		model.addAttribute("oaProjImpl", oaProjImpl);
		return "modules/oa/"+view;
	}
	
	/**
	 * 查看项目实施流程表页面
	 */
	@RequiresPermissions(value="oa:oaProjImpl:view")
	@RequestMapping(value = "view")
	public String view(OaProjImpl oaProjImpl, Model model) {
		
		model.addAttribute("oaProjImpl", oaProjImpl);
		return "modules/oa/oaProjImplView";
	}

	/**
	 * 保存项目实施流程表
	 */
	@RequiresPermissions(value={"oa:oaProjImpl:add","oa:oaProjImpl:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(OaProjImpl oaProjImpl, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaProjImpl)){
			return form(oaProjImpl, model,redirectAttributes);
		}
		oaProjImplService.save(oaProjImpl);
		//对应任务状态改为完成
		OaTask oaTask = oaTaskService.getTaskByName(oaProjImpl.getAct().getTaskName(),
				oaProjImpl.getProject().getId(),oaProjImpl.getUser().getId());
		if(oaTask!=null && oaTask.getStatus().equals("1")) {
			//DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_END, oaTask.getId(), oaTask.getName(), null);
			oaTask.setStatus("2");
			oaTaskService.save(oaTask);
		}
		addMessage(redirectAttributes, "提交审批'" + oaProjImpl.getUser().getName() + "'成功");
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 工单执行（完成任务）
	 * @param oaProjImpl
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:oaProjCons:edit")
	@RequestMapping(value = "saveAudit", method = RequestMethod.POST)
	public String saveAudit(OaProjImpl oaProjImpl, Model model,RedirectAttributes redirectAttributes) {
		if (StringUtils.isBlank(oaProjImpl.getAct().getFlag())
				|| StringUtils.isBlank(oaProjImpl.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(oaProjImpl, model,redirectAttributes);
		}
		oaProjImplService.auditSave(oaProjImpl);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 删除项目实施流程表
	 */
	@RequiresPermissions("oa:oaProjImpl:del")
	@RequestMapping(value = "delete")
	public String delete(OaProjImpl oaProjImpl, RedirectAttributes redirectAttributes) {
		oaProjImplService.delete(oaProjImpl);
		addMessage(redirectAttributes, "删除项目实施流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjImpl/?repage";
	}
	
	/**
	 * 批量删除项目实施流程表
	 */
	@RequiresPermissions("oa:oaProjImpl:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaProjImplService.delete(oaProjImplService.get(id));
		}
		addMessage(redirectAttributes, "删除项目实施流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjImpl/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaProjImpl:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaProjImpl oaProjImpl, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目实施流程表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaProjImpl> page = oaProjImplService.findPage(new Page<OaProjImpl>(request, response, -1), oaProjImpl);
    		new ExportExcel("项目实施流程表", OaProjImpl.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出项目实施流程表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjImpl/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaProjImpl:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaProjImpl> list = ei.getDataList(OaProjImpl.class);
			for (OaProjImpl oaProjImpl : list){
				try{
					oaProjImplService.save(oaProjImpl);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条项目实施流程表记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条项目实施流程表记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入项目实施流程表失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjImpl/?repage";
    }
	
	/**
	 * 下载导入项目实施流程表数据模板
	 */
	@RequiresPermissions("oa:oaProjImpl:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目实施流程表数据导入模板.xlsx";
    		List<OaProjImpl> list = Lists.newArrayList(); 
    		new ExportExcel("项目实施流程表数据", OaProjImpl.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjImpl/?repage";
    }
	
	/**
	 * 项目实施流程表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaProjImpl oaProjImpl, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaProjImpl, request, response, model);
        return "modules/oa/oaProjImplSelectList";
	}
	
}