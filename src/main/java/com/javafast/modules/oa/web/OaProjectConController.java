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
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.entity.Office;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaProjectCon;
import com.javafast.modules.oa.entity.TestAudit;
import com.javafast.modules.oa.service.OaProjectConService;
import com.javafast.modules.oa.service.OaProjectService;

/**
 * 项目咨询流程表Controller
 * @author javafast
 * @version 2019-08-06
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaProjectCon")
public class OaProjectConController extends BaseController {

	@Autowired
	private OaProjectConService oaProjectConService;
	
	@Autowired
	private OaProjectService oaProjectService;
	
	@ModelAttribute
	public OaProjectCon get(@RequestParam(required=false) String id) {
		OaProjectCon entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaProjectConService.get(id);
		}
		if (entity == null){
			entity = new OaProjectCon();
		}
		return entity;
	}
	
	/**
	 * 项目咨询流程表列表页面
	 */
	@RequiresPermissions("oa:oaProjectCon:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaProjectCon oaProjectCon, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaProjectCon> page = oaProjectConService.findPage(new Page<OaProjectCon>(request, response), oaProjectCon); 
		model.addAttribute("page", page);
		return "modules/oa/oaProjectConList";
	}

	/**
	 * 编辑项目咨询流程表表单页面
	 */
	@RequiresPermissions(value={"oa:oaProjectCon:view","oa:oaProjectCon:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OaProjectCon oaProjectCon, Model model) {
		String view = "oaProjectConStart";
		if (StringUtils.isNotBlank(oaProjectCon.getId())){

			// 环节编号
			String taskDefKey = oaProjectCon.getAct().getTaskDefKey();
			// 查看工单
			if(oaProjectCon.getAct().isFinishTask()){
				view = "oaProjectConView";
			}
			// 审核环节
			else if ("audit10".equals(taskDefKey)||"audit3".equals(taskDefKey)
					||"audit11".equals(taskDefKey)||"audit12".equals(taskDefKey)){
				view = "oaProjectConAudit";
			}else if("audit2".equals(taskDefKey)||"audit00".equals(taskDefKey)
					||"audit01".equals(taskDefKey)||"audit02".equals(taskDefKey)) {
				view = "oaProjectConForm";
			}
		}else {
			oaProjectCon.setUser(UserUtils.getUser());
			oaProjectCon.setOffice(UserUtils.getUser().getOffice());
		}
		oaProjectCon.setProject(oaProjectService.get(oaProjectCon.getAct().getProjectId()));
		model.addAttribute("oaProjectCon", oaProjectCon);
		return "modules/oa/"+view;
//		model.addAttribute("oaProjectCon", oaProjectCon);
//		return "modules/oa/oaProjectConForm";
	}
	
	/**
	 * 查看项目咨询流程表页面
	 */
	@RequiresPermissions(value="oa:oaProjectCon:view")
	@RequestMapping(value = "view")
	public String view(OaProjectCon oaProjectCon, Model model) {
		model.addAttribute("oaProjectCon", oaProjectCon);
		return "modules/oa/oaProjectConView";
	}

	/**
	 * 保存项目咨询流程表
	 */
	@RequiresPermissions(value={"oa:oaProjectCon:add","oa:oaProjectCon:edit"},logical=Logical.OR)
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(OaProjectCon oaProjectCon, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaProjectCon)){
			return form(oaProjectCon, model);
		}
		oaProjectConService.save(oaProjectCon);
		addMessage(redirectAttributes, "提交审批'" + oaProjectCon.getUser().getName() + "'成功");
		return "redirect:" + adminPath + "/act/task/todo/";
		
//		try{
//			System.out.println("id===="+StringUtils.isBlank(oaProjectCon.getId()));
//			if(!oaProjectCon.getIsNewRecord()){//编辑表单保存
//				System.out.println("****测试1");
//				OaProjectCon t = oaProjectConService.get(oaProjectCon.getId());//从数据库取出记录的值
//				MyBeanUtils.copyBeanNotNull2Bean(oaProjectCon, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
//				oaProjectConService.save(t);//保存
//				addMessage(redirectAttributes, "**保存项目咨询流程表成功");
//			}else{//新增表单保存
//				System.out.println("**********测试2");
//				oaProjectConService.save(oaProjectCon);//保存
//				addMessage(redirectAttributes, "提交审批'" + oaProjectCon.getUser().getName() + "'成功");
//			}
//			addMessage(redirectAttributes, "保存项目咨询流程表成功");
//		}catch(Exception e){			
//			e.printStackTrace();
//			addMessage(redirectAttributes, "保存项目咨询流程表失败");
//		}finally{
//			return "redirect:" + adminPath + "/act/task/todo/";
//		}
	}
	
	/**
	 * 工单执行（完成任务）
	 * @param testAudit
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:oaProjectCon:edit")
	@RequestMapping(value = "saveAudit", method = RequestMethod.POST)
	public String saveAudit(OaProjectCon oaProjectCon, Model model) {
		if (StringUtils.isBlank(oaProjectCon.getAct().getFlag())
				|| StringUtils.isBlank(oaProjectCon.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(oaProjectCon, model);
		}
		oaProjectConService.auditSave(oaProjectCon);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	/**
	 * 删除项目咨询流程表
	 */
	@RequiresPermissions("oa:oaProjectCon:del")
	@RequestMapping(value = "delete")
	public String delete(OaProjectCon oaProjectCon, RedirectAttributes redirectAttributes) {
		oaProjectConService.delete(oaProjectCon);
		addMessage(redirectAttributes, "删除项目咨询流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectCon/?repage";
	}
	
	/**
	 * 批量删除项目咨询流程表
	 */
	@RequiresPermissions("oa:oaProjectCon:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaProjectConService.delete(oaProjectConService.get(id));
		}
		addMessage(redirectAttributes, "删除项目咨询流程表成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectCon/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaProjectCon:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaProjectCon oaProjectCon, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目咨询流程表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaProjectCon> page = oaProjectConService.findPage(new Page<OaProjectCon>(request, response, -1), oaProjectCon);
    		new ExportExcel("项目咨询流程表", OaProjectCon.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出项目咨询流程表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectCon/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaProjectCon:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaProjectCon> list = ei.getDataList(OaProjectCon.class);
			for (OaProjectCon oaProjectCon : list){
				try{
					oaProjectConService.save(oaProjectCon);
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
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectCon/?repage";
    }
	
	/**
	 * 下载导入项目咨询流程表数据模板
	 */
	@RequiresPermissions("oa:oaProjectCon:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "项目咨询流程表数据导入模板.xlsx";
    		List<OaProjectCon> list = Lists.newArrayList(); 
    		new ExportExcel("项目咨询流程表数据", OaProjectCon.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaProjectCon/?repage";
    }
	
	/**
	 * 项目咨询流程表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaProjectCon oaProjectCon, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaProjectCon, request, response, model);
        return "modules/oa/oaProjectConSelectList";
	}
	
}