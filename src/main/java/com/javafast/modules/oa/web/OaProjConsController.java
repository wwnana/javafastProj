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

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaProjCons;
import com.javafast.modules.oa.service.OaProjConsService;
import com.javafast.modules.oa.service.OaProjectService;

/**
 * 项目咨询流程表Controller
 * @author javafast
 * @version 2019-08-16
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaProjCons")
public class OaProjConsController extends BaseController {

	@Autowired
	private OaProjConsService oaProjConsService;
	@Autowired
	private OaProjectService oaProjectService;
	
	@ModelAttribute
	public OaProjCons get(@RequestParam(required=false) String id) {
		OaProjCons entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaProjConsService.get(id);
		}
		if (entity == null){
			entity = new OaProjCons();
		}
		return entity;
	}
	
	/**
	 * 项目咨询流程表列表页面
	 */
	@RequiresPermissions("oa:oaProjCons:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaProjCons oaProjCons, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProjCons> page = oaProjConsService.findPage(new Page<OaProjCons>(request, response), oaProjCons); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjConsList";
	}

	/**
	 * 编辑项目咨询流程表表单页面
	 */
	@RequiresPermissions(value={"oa:oaProjCons:view","oa:oaProjCons:add","oa:oaProjCons:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaProjCons oaProjCons, Model model) {
		User currUser = UserUtils.getUser();
		String view = "oaProjConsStart";
		String sta = oaProjCons.getAct().getTaskDefKey();
		//显示历史记录中的详情
		if(oaProjCons.getAct().getStatus().equals("finish")) {
			view="oaProjConsView";
			String status = "";
			if(oaProjCons.getAct().getTaskDefKey().equals("apply_end")) {
				status="apply_end";
			}else {
				status = "form"+sta.substring(sta.length()-2, sta.length());
			}
			String procInsId = oaProjCons.getAct().getProcInsId();
			OaProjCons oaProjCons2 = oaProjConsService.findLastTask(procInsId,status);
			model.addAttribute("oaProjCons", oaProjCons2);
			return "modules/oa/"+view;
		}
		if (StringUtils.isNotBlank(oaProjCons.getId())){

			// 环节编号
			String taskDefKey = oaProjCons.getAct().getTaskDefKey();
			// 查看工单
			if(oaProjCons.getAct().isFinishTask()){
				view = "oaProjConsView";
			}else if("apply_end".equals(taskDefKey)) {
				view = "oaProjConsFinish";
			}
			// 成员提交表单环节
			else if(taskDefKey.contains("form0")||"form10".equals(taskDefKey)) {
				view = "oaProjConsForm";
			}
			//审核环节
			else if(taskDefKey.contains("audit0")||"audit10".equals(taskDefKey)) {
				view = "oaProjConsAudit";
				String status = "form"+oaProjCons.getAct().getTaskDefKey().substring(5);
				String procInsId = oaProjCons.getAct().getProcInsId();
				OaProjCons oaProjCons1 = oaProjConsService.findLastTask(procInsId,status);
				oaProjCons1.setAudit(currUser);
				oaProjCons1.setAuditName(currUser.getName());
				oaProjCons1.setAct(oaProjCons.getAct());
				oaProjCons1.setUpdateByName(currUser.getName());
				model.addAttribute("oaProjCons", oaProjCons1);
				return "modules/oa/"+view;
			}
		}
		oaProjCons.setUser(currUser);//设置申请人
		oaProjCons.setOffice(currUser.getOffice());//设置申请人部门
		oaProjCons.setProcInsId(oaProjCons.getAct().getProcInsId());//设置流程实例ID
		oaProjCons.setStatus(oaProjCons.getAct().getTaskDefKey());//设置状态
		oaProjCons.setProject(oaProjectService.get(oaProjCons.getAct().getProjectId()));
		oaProjCons.setUserName(currUser.getName());
		oaProjCons.setOfficeName(currUser.getOffice().getName());
		oaProjCons.setCreateByName(currUser.getName());
		oaProjCons.setUpdateByName(currUser.getName());
		model.addAttribute("oaProjCons", oaProjCons);
		return "modules/oa/"+view;
	}
	
	
	/**
	 * 查看项目咨询流程表页面
	 */
	@RequiresPermissions(value="oa:oaProjCons:view")
	@RequestMapping(value = "view")
	public String view(OaProjCons oaProjCons, Model model) {
		model.addAttribute("oaProjCons", oaProjCons);
		return "modules/oa/oaProjConsView";
	}

	/**
	 * 保存项目咨询流程表
	 */
	@RequiresPermissions(value={"oa:oaProjCons:add","oa:oaProjCons:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(OaProjCons oaProjCons, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaProjCons)){
			return form(oaProjCons, model);
		}
		oaProjConsService.save(oaProjCons);
		addMessage(redirectAttributes, "提交审批'" + oaProjCons.getUser().getName() + "'成功");
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 工单执行（完成任务）
	 * @param oaProjCons
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:oaProjCons:edit")
	@RequestMapping(value = "saveAudit", method = RequestMethod.POST)
	public String saveAudit(OaProjCons oaProjCons, Model model) {
		if (StringUtils.isBlank(oaProjCons.getAct().getFlag())
				|| StringUtils.isBlank(oaProjCons.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(oaProjCons, model);
		}
		oaProjConsService.auditSave(oaProjCons);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 删除项目咨询流程表
	 */
	@RequiresPermissions("oa:oaProjCons:del")
	@RequestMapping(value = "delete")
	public String delete(OaProjCons oaProjCons, RedirectAttributes redirectAttributes) {
		oaProjConsService.delete(oaProjCons);
		addMessage(redirectAttributes, "删除项目咨询流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjCons/?repage";
	}
	
	/**
	 * 批量删除项目咨询流程表
	 */
	@RequiresPermissions("oa:oaProjCons:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaProjConsService.delete(oaProjConsService.get(id));
		}
		addMessage(redirectAttributes, "删除项目咨询流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjCons/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaProjCons:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaProjCons oaProjCons, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目咨询流程表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaProjCons> page = oaProjConsService.findPage(new Page<OaProjCons>(request, response, -1), oaProjCons);
    		new ExportExcel("项目咨询流程表", OaProjCons.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出项目咨询流程表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjCons/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaProjCons:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaProjCons> list = ei.getDataList(OaProjCons.class);
			for (OaProjCons oaProjCons : list){
				try{
					oaProjConsService.save(oaProjCons);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条项目咨询流程表记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条项目咨询流程表记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入项目咨询流程表失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjCons/?repage";
    }
	
	/**
	 * 下载导入项目咨询流程表数据模板
	 */
	@RequiresPermissions("oa:oaProjCons:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目咨询流程表数据导入模板.xlsx";
    		List<OaProjCons> list = Lists.newArrayList(); 
    		new ExportExcel("项目咨询流程表数据", OaProjCons.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjCons/?repage";
    }
	
	/**
	 * 项目咨询流程表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaProjCons oaProjCons, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaProjCons, request, response, model);
        return "modules/oa/oaProjConsSelectList";
	}
	
}