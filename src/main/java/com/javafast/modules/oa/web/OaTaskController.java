package com.javafast.modules.oa.web;

import java.util.ArrayList;
import java.util.Date;
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
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.oa.entity.OaProject;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 任务Controller
 * @author javafast
 * @version 2017-07-08
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaTask")
public class OaTaskController extends BaseController {

	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private OaProjectService oaProjectService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
//	@Autowired
//	private ActDao actDao;
	
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
		Page<OaTask> page = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("page", page);
		return "modules/oa/oaTaskList";
	}
	
	/**
	 * 任务列表页面
	 */
	@RequestMapping(value = "indexTaskList")
	public String indexTaskList(OaTask oaTask, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaTask> page = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("page", page);
		return "modules/oa/indexTaskList";
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
		
		//查询里程
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_OA_TYPE_TASK, oaTask.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		//查询到期提醒
		if(oaTask.getEndDate() != null){			
			int diffDay = DateUtils.differentDaysByMillisecond(new Date(), oaTask.getEndDate());
			model.addAttribute("diffDay", diffDay);		
		}
		
		model.addAttribute("oaTask", oaTask);
		return "modules/oa/oaTaskIndex";
	}
	
	/**
	 * 查看，增加，编辑任务表单页面
	 */
	@RequiresPermissions(value={"oa:oaTask:view","oa:oaTask:add","oa:oaTask:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaTask oaTask, Model model,RedirectAttributes redirectAttributes) {
		//添加任务前判断项目状态是否处于进行中
		OaProject oaProj = oaProjectService.get(oaTask.getRelationId());
		if(oaProj!=null && !"1".equals(oaProj.getStatus())) {
			addMessage(redirectAttributes, "当前项目状态未在进行中");
			return "redirect:"+Global.getAdminPath()+"/oa/oaProject/view?id="+oaTask.getRelationId();
		}
		if(oaTask.getIsNewRecord()){
			oaTask.setNo("RW"+IdUtils.getId());
			oaTask.setSchedule(0);
			
			//项目
			if("20".equals(oaTask.getRelationType())){
				OaProject oaProject = oaProjectService.get(oaTask.getRelationId());
				oaTask.setRelationName(oaProject.getName());
			}
			
			//客户
			if("0".equals(oaTask.getRelationType())){
				if(oaTask.getRelationId() != null){
					CrmCustomer customer = crmCustomerService.get(oaTask.getRelationId());
					if(customer != null)
						oaTask.setRelationName(customer.getName());
				}
			}
			
			if(oaTask.getOwnBy() == null){
				oaTask.setOwnBy(UserUtils.getUser());
			}
		}
		
		//更新阅读状态
		if (StringUtils.isNotBlank(oaTask.getId())){
			oaTaskService.updateReadFlag(oaTask);
		}
		
		//List<String> procList = actDao.findProcDefName();
		List<String> procList = new ArrayList<String>();
		procList.add("项目咨询流程");
		procList.add("项目实施流程-可执行方案");
		procList.add("项目实施流程-详细方案");
		procList.add("项目实施流程-任务计划书反馈");
		procList.add("项目实施流程-子系统验收");
		
		model.addAttribute("oaTask", oaTask);
		model.addAttribute("procList",procList);
		
		return "modules/oa/oaTaskForm";
	}

	/**
	 * 保存任务
	 */
	@RequiresPermissions(value={"oa:oaTask:add","oa:oaTask:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	
	public String save(OaTask oaTask, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaTask)){
			return form(oaTask, model,redirectAttributes);
		}
		
		try{
			
//			for(int i=0;i<oaTask.getOaTaskRecordList().size();i++){
//				
//				OaTaskRecord oaTaskRecord = oaTask.getOaTaskRecordList().get(i);
//				if(oaTaskRecord.getUser().getId().equals(oaTask.getOwnBy().getId())){
//					
//				}
//			}
		
			if(!oaTask.getIsNewRecord()){//编辑表单保存				
				OaTask t = oaTaskService.get(oaTask.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaTask, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaTaskService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getRelationId());
			}else{//新增表单保存
				oaTask.setSchedule(0);
				oaTask.setStatus("0");
				oaTaskService.save(oaTask);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_ADD, oaTask.getId(), oaTask.getName(), oaTask.getRelationId());
			}
			addMessage(redirectAttributes, "保存任务成功");
			return "redirect:"+Global.getAdminPath()+"/oa/oaTask/view?id="+oaTask.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存任务失败");
			return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
		}
	}
	
	/**
	 * 删除任务
	 */
	@RequiresPermissions("oa:oaTask:del")
	@RequestMapping(value = "delete")
	public String delete(OaTask oaTask, RedirectAttributes redirectAttributes) {
		oaTaskService.delete(oaTask);
		addMessage(redirectAttributes, "删除任务成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
	}
	
	/**
	 * 批量删除任务
	 */
	@RequiresPermissions("oa:oaTask:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaTaskService.delete(oaTaskService.get(id));
		}
		addMessage(redirectAttributes, "删除任务成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaTask:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaTask oaTask, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "任务"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaTask> page = oaTaskService.findPage(new Page<OaTask>(request, response, -1), oaTask);
    		new ExportExcel("任务", OaTask.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出任务记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaTask:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaTask> list = ei.getDataList(OaTask.class);
			for (OaTask oaTask : list){
				try{
					oaTaskService.save(oaTask);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条任务记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条任务记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入任务失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
    }
	
	/**
	 * 下载导入任务数据模板
	 */
	@RequiresPermissions("oa:oaTask:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "任务数据导入模板.xlsx";
    		List<OaTask> list = Lists.newArrayList(); 
    		new ExportExcel("任务数据", OaTask.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/?repage";
    }
	
	/**
	 * 我的任务
	 */
	@RequestMapping(value = "self")
	public String self(OaTask oaTask, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaTask.setSelf(true);
		Page<OaTask> page = oaTaskService.findPage(new Page<OaTask>(request, response), oaTask); 
		model.addAttribute("page", page);
		return "modules/oa/oaTaskList";
	}
	
	/**
	 * 执行任务
	 * @param oaTask
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "deal")
	public String deal(OaTask oaTask, RedirectAttributes redirectAttributes) {
		
		OaTask t = oaTaskService.get(oaTask.getId());//从数据库取出记录的值
		t.setStatus(oaTask.getStatus());
		String proId = t.getRelationId();
		OaProject project = oaProjectService.get(proId);
		
		//完成
		if("2".equals(oaTask.getStatus()))
			t.setSchedule(100);
		
		oaTaskService.update(t);
		//开始
		if("1".equals(oaTask.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_START, oaTask.getId(), oaTask.getName(), null);
		}
		//完成
		if("2".equals(oaTask.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_END, oaTask.getId(), oaTask.getName(), null);
		}
		//关闭
		if("3".equals(oaTask.getStatus())){
			DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_CLOSE, oaTask.getId(), oaTask.getName(), null);
		}
		
		addMessage(redirectAttributes, "操作成功");
		return "redirect:"+Global.getAdminPath() +"/oa/oaTask/view?id="+oaTask.getId();
	}
	
	/**
	 * 删除任务
	 */
	@RequiresPermissions("oa:oaTask:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(OaTask oaTask, RedirectAttributes redirectAttributes) {
		
		String customerId = oaTaskService.get(oaTask.getId()).getRelationId();
		oaTaskService.delete(oaTask);
		addMessage(redirectAttributes, "删除任务成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTask/indexTaskList?relationId="+customerId;
	}
}