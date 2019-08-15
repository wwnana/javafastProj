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
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.oa.service.OaWorkLogService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 工作报告Controller
 * @author javafast
 * @version 2018-05-03
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaWorkLog")
public class OaWorkLogController extends BaseController {

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
	@RequiresPermissions("oa:oaWorkLog:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaWorkLog.setCreateBy(UserUtils.getUser());
		Page<OaWorkLog> page = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response), oaWorkLog); 
		model.addAttribute("page", page);
		return "modules/oa/oaWorkLogList2";
	}
	
	/**
	 * 查询自己有权限查看的
	 * @param oaWorkLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:oaWorkLog:list")
	@RequestMapping(value = "self")
	public String self(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		oaWorkLog.setSelf(true);
		Page<OaWorkLog> page = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response), oaWorkLog); 
		model.addAttribute("page", page);
		return "modules/oa/oaWorkLogList";
	}

	/**
	 * 编辑工作报告表单页面
	 */
	@RequiresPermissions(value={"oa:oaWorkLog:view","oa:oaWorkLog:add","oa:oaWorkLog:edit"},logical=Logical.OR)
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
	@RequiresPermissions(value="oa:oaWorkLog:view")
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
	@RequiresPermissions(value={"oa:oaWorkLog:add","oa:oaWorkLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(OaWorkLog oaWorkLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaWorkLog)){
			return form(oaWorkLog, model);
		}
		
		try{
		
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
			return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
		}
	}
	
	/**
	 * 删除工作报告
	 */
	@RequiresPermissions("oa:oaWorkLog:del")
	@RequestMapping(value = "delete")
	public String delete(OaWorkLog oaWorkLog, RedirectAttributes redirectAttributes) {
		oaWorkLogService.delete(oaWorkLog);
		addMessage(redirectAttributes, "删除工作报告成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
	}
	
	/**
	 * 批量删除工作报告
	 */
	@RequiresPermissions("oa:oaWorkLog:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaWorkLogService.delete(oaWorkLogService.get(id));
		}
		addMessage(redirectAttributes, "删除工作报告成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaWorkLog:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工作报告"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaWorkLog> page = oaWorkLogService.findPage(new Page<OaWorkLog>(request, response, -1), oaWorkLog);
    		new ExportExcel("工作报告", OaWorkLog.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出工作报告记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaWorkLog:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaWorkLog> list = ei.getDataList(OaWorkLog.class);
			for (OaWorkLog oaWorkLog : list){
				try{
					oaWorkLogService.save(oaWorkLog);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条工作报告记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条工作报告记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入工作报告失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
    }
	
	/**
	 * 下载导入工作报告数据模板
	 */
	@RequiresPermissions("oa:oaWorkLog:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工作报告数据导入模板.xlsx";
    		List<OaWorkLog> list = Lists.newArrayList(); 
    		new ExportExcel("工作报告数据", OaWorkLog.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/?repage";
    }
	
	/**
	 * 工作报告列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaWorkLog oaWorkLog, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaWorkLog, request, response, model);
        return "modules/oa/oaWorkLogSelectList";
	}
	
	/**
	 * 评论
	 * @param oaWorkLog
	 * @param auditNotes
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "addReadNote")
	public String addReadNote(OaWorkLog oaWorkLog, String auditNotes, Model model, RedirectAttributes redirectAttributes) {
		
		try{
			System.out.println(auditNotes);
			//更新评论信息
			oaWorkLogService.updateReadNote(oaWorkLog, auditNotes);
			addMessage(redirectAttributes, "评论成功");
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "评论失败");
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLog/view?id="+oaWorkLog.getId();
	}
}