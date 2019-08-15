package com.javafast.modules.oa.web;

import java.util.List;
import java.util.Map;

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
import com.google.common.collect.Maps;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.oa.entity.OaProjectImple;
import com.javafast.modules.oa.service.OaProjectImpleService;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 项目实施流程表Controller
 * @author javafast
 * @version 2019-07-15
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaProjectImple")
public class OaProjectImpleController extends BaseController {

	@Autowired
	private OaProjectImpleService oaProjectImpleService;
	
	@Autowired
	private OaProjectService oaProjectService;
	
	@ModelAttribute
	public OaProjectImple get(@RequestParam(required=false) String id) {
		OaProjectImple entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaProjectImpleService.get(id);
		}
		if (entity == null){
			entity = new OaProjectImple();
		}
		return entity;
	}
	
	/**
	 * 项目实施流程表列表页面
	 */
	@RequiresPermissions("oa:oaProjectImple:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaProjectImple oaProjectImple, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProjectImple> page = oaProjectImpleService.findPage(new Page<OaProjectImple>(request, response), oaProjectImple); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjectImpleList";
	}

	/**
	 * 编辑项目实施流程表表单页面
	 */
	@RequiresPermissions(value={"oa:oaProjectImple:view","oa:oaProjectImple:add","oa:oaProjectImple:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaProjectImple oaProjectImple, Model model) {
		String view = "oaProjectImpleStart";
		if (StringUtils.isNotBlank(oaProjectImple.getId())){//.getAct().getProcInsId())){

			// 环节编号
			String taskDefKey = oaProjectImple.getAct().getTaskDefKey();
			// 查看工单
			if(oaProjectImple.getAct().isFinishTask()){
				view = "oaProjectImpleView";
			}
			//提交表单环节
			else if (taskDefKey.contains("mem0")||taskDefKey.contains("audit1")||taskDefKey.contains("mem1")
					||taskDefKey.contains("form1")||taskDefKey.contains("form2")||taskDefKey.contains("mem2")
					||taskDefKey.contains("mem3")){
				view = "oaProjectImpleForm";
			}
			// 审核环节
			else if (taskDefKey.contains("audit0")||taskDefKey.contains("audit2")
					||taskDefKey.contains("audit5")||taskDefKey.contains("audit6")){
				view = "oaProjectImpleAudit";
//				String formKey = "/oa/oaProjectImple";
//				return "redirect:" + ActUtils.getFormUrl(formKey, oaProjectImple.getAct());
			}
			else if(taskDefKey.contains("audit3")) {
				view = "oaProjectImpleAudit1";
			}
		}else {
			oaProjectImple.setUser(UserUtils.getUser());
			oaProjectImple.setOffice(UserUtils.getUser().getOffice());
		}
		oaProjectImple.setProject(oaProjectService.get(oaProjectImple.getAct().getProjectId()));
		model.addAttribute("oaProjectImple", oaProjectImple);
		return "modules/oa/"+view;
	}
	
	/**
	 * 工单执行（完成任务）
	 * @param oaProjectImple
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:oaProjectImple:edit")
	@RequestMapping(value = "saveAudit")
	public String saveAudit(OaProjectImple oaProjectImple, Model model) {
		if (StringUtils.isBlank(oaProjectImple.getAct().getFlag())
				|| StringUtils.isBlank(oaProjectImple.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(oaProjectImple, model);
		}
		oaProjectImpleService.auditSave(oaProjectImple);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 查看项目实施流程表页面
	 */
	@RequiresPermissions(value="oa:oaProjectImple:view")
	@RequestMapping(value = "view")
	public String view(OaProjectImple oaProjectImple, Model model) {
		model.addAttribute("oaProjectImple", oaProjectImple);
		return "modules/oa/oaProjectImpleView";
	}

	/**
	 * 保存项目实施流程表
	 */
	@RequiresPermissions(value={"oa:oaProjectImple:add","oa:oaProjectImple:edit"},logical=Logical.OR)
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(OaProjectImple oaProjectImple, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, oaProjectImple)){
			return form(oaProjectImple, model);
		}
		oaProjectImpleService.save(oaProjectImple);
		addMessage(redirectAttributes, "提交审批'" + oaProjectImple.getUser().getName() + "'成功");
		return "redirect:" + adminPath + "/act/task/todo/";

	}
	
	/**
	 * 删除项目实施流程表
	 */
	@RequiresPermissions("oa:oaProjectImple:del")
	@RequestMapping(value = "delete")
	public String delete(OaProjectImple oaProjectImple, RedirectAttributes redirectAttributes) {
		oaProjectImpleService.delete(oaProjectImple);
		addMessage(redirectAttributes, "删除项目实施流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectImple/?repage";
	}
	
	/**
	 * 批量删除项目实施流程表
	 */
	@RequiresPermissions("oa:oaProjectImple:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaProjectImpleService.delete(oaProjectImpleService.get(id));
		}
		addMessage(redirectAttributes, "删除项目实施流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectImple/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaProjectImple:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaProjectImple oaProjectImple, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目实施流程表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaProjectImple> page = oaProjectImpleService.findPage(new Page<OaProjectImple>(request, response, -1), oaProjectImple);
    		new ExportExcel("项目实施流程表", OaProjectImple.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出项目实施流程表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectImple/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaProjectImple:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaProjectImple> list = ei.getDataList(OaProjectImple.class);
			for (OaProjectImple oaProjectImple : list){
				try{
					oaProjectImpleService.save(oaProjectImple);
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
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectImple/?repage";
    }
	
	/**
	 * 下载导入项目实施流程表数据模板
	 */
	@RequiresPermissions("oa:oaProjectImple:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目实施流程表数据导入模板.xlsx";
    		List<OaProjectImple> list = Lists.newArrayList(); 
    		new ExportExcel("项目实施流程表数据", OaProjectImple.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectImple/?repage";
    }
	
	/**
	 * 项目实施流程表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaProjectImple oaProjectImple, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaProjectImple, request, response, model);
        return "modules/oa/oaProjectImpleSelectList";
	}
	
	
}