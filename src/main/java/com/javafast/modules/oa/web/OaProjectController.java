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
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysDynamic;

import com.google.common.collect.Lists;

import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.act.entity.Act;
import com.javafast.modules.act.service.ActTaskService;
import com.javafast.modules.act.web.ActTaskController;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.oa.service.OaTaskService;

/**
 * 项目Controller
 * @author javafast
 * @version 2018-05-18
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaProject")
public class OaProjectController extends BaseController {

	@Autowired
	private OaProjectService oaProjectService;
	
	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	public ActTaskService actTaskService;
	
	
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
		Page<OaProject> page = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjectList";
	}
	
	/**
	 * 项目列表页面2
	 */
	@RequiresPermissions("oa:oaProject:list")
	@RequestMapping(value = "list2")
	public String list2(OaProject oaProject, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProject> page = oaProjectService.findPage(new Page<OaProject>(request, response), oaProject); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjectList2";
	}

	/**
	 * 编辑项目表单页面
	 */
	@RequiresPermissions(value={"oa:oaProject:view","oa:oaProject:add","oa:oaProject:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaProject oaProject, Model model) {
		
		if(oaProject.getIsNewRecord()){
			oaProject.setNo("XM"+IdUtils.getId());
			oaProject.setSchedule(0);
			oaProject.setOwnBy(UserUtils.getUser());
		}
		
		model.addAttribute("oaProject", oaProject);
		return "modules/oa/oaProjectForm";
	}
	
	/**
	 * 查看项目页面
	 */
	@RequiresPermissions(value="oa:oaProject:view")
	@RequestMapping(value = "view")
	public String view(OaProject oaProject,Model model,String category, HttpServletRequest request, HttpServletResponse response) {
		
		//更新阅读状态
		if (StringUtils.isNotBlank(oaProject.getId())){
			oaProjectService.updateReadFlag(oaProject);
		}
		model.addAttribute("oaProject", oaProject);
		
		OaTask conOaTask = new OaTask();
		conOaTask.setRelationId(oaProject.getId());
		List<OaTask> oaTaskList = oaTaskService.findList(conOaTask);
		model.addAttribute("oaTaskList", oaTaskList);
		
		//查询里程
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_OA_TYPE_PROJECT, oaProject.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		//查询到期提醒
		if(oaProject.getEndDate() != null){			
			int diffDay = DateUtils.differentDaysByMillisecond(new Date(), oaProject.getEndDate());
			model.addAttribute("diffDay", diffDay);		
		}
		
		//加入流程模板
		Page<Object[]> page = new Page<Object[]>(request, response);
	    page = actTaskService.processList(page, category);
		model.addAttribute("page", page);
		model.addAttribute("category", category);
		
		
		return "modules/oa/oaProjectIndex";
	}

	/**
	 * 保存项目
	 */
	@RequiresPermissions(value={"oa:oaProject:add","oa:oaProject:edit"},logical=Logical.OR)
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(OaProject oaProject, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaProject)){
			return form(oaProject, model);
		}
		
		try{
		
			if(!oaProject.getIsNewRecord()){//编辑表单保存				
				OaProject t = oaProjectService.get(oaProject.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaProject, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaProjectService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_UPDATE, oaProject.getId(), oaProject.getName(), null);
			}else{//新增表单保存
				oaProject.setSchedule(0);
				oaProject.setStatus("0");
				oaProjectService.save(oaProject);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_ADD, oaProject.getId(), oaProject.getName(), null);
			}
			addMessage(redirectAttributes, "保存项目成功");
			return "redirect:"+Global.getAdminPath()+"/oa/oaProject/view?id="+oaProject.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存项目失败");
			return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
		}
	}
	
	/**
	 * 删除项目
	 */
	@RequiresPermissions("oa:oaProject:del")
	@RequestMapping(value = "delete")
	public String delete(OaProject oaProject, RedirectAttributes redirectAttributes) {
		oaProjectService.delete(oaProject);
		addMessage(redirectAttributes, "删除项目成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
	}
	
	/**
	 * 批量删除项目
	 */
	@RequiresPermissions("oa:oaProject:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaProjectService.delete(oaProjectService.get(id));
		}
		addMessage(redirectAttributes, "删除项目成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaProject:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaProject oaProject, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaProject> page = oaProjectService.findPage(new Page<OaProject>(request, response, -1), oaProject);
    		new ExportExcel("项目", OaProject.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出项目记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaProject:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaProject> list = ei.getDataList(OaProject.class);
			for (OaProject oaProject : list){
				try{
					oaProjectService.save(oaProject);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条项目记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条项目记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入项目失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
    }
	
	/**
	 * 下载导入项目数据模板
	 */
	@RequiresPermissions("oa:oaProject:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目数据导入模板.xlsx";
    		List<OaProject> list = Lists.newArrayList(); 
    		new ExportExcel("项目数据", OaProject.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/?repage";
    }
	
	/**
	 * 项目列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaProject oaProject, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaProject, request, response, model);
        return "modules/oa/oaProjectSelectList";
	}
	
	/**
	 * 执行项目
	 * @param oaProject
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "deal")
	public String deal(OaProject oaProject, RedirectAttributes redirectAttributes) {
		
		OaProject t = oaProjectService.get(oaProject.getId());//从数据库取出记录的值
		t.setStatus(oaProject.getStatus());
		
		if("2".equals(oaProject.getStatus()))
			t.setSchedule(100);
		
		oaProjectService.save(t);
		
		if("1".equals(oaProject.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_START, oaProject.getId(), oaProject.getName(), null);
		}
		if("2".equals(oaProject.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_END, oaProject.getId(), oaProject.getName(), null);
		}
		if("3".equals(oaProject.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_CLOSE, oaProject.getId(), oaProject.getName(), null);
		}
		
		
		addMessage(redirectAttributes, "操作成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProject/view?id="+oaProject.getId();
	}
}