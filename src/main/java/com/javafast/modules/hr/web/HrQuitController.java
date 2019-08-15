package com.javafast.modules.hr.web;

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
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrQuit;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrQuitService;
import com.javafast.modules.hr.utils.ResumeLogUtils;

/**
 * 离职Controller
 * @author javafast
 * @version 2018-07-06
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrQuit")
public class HrQuitController extends BaseController {

	@Autowired
	private HrQuitService hrQuitService;
	
	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@ModelAttribute
	public HrQuit get(@RequestParam(required=false) String id) {
		HrQuit entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrQuitService.get(id);
		}
		if (entity == null){
			entity = new HrQuit();
		}
		return entity;
	}
	
	/**
	 * 离职列表页面
	 */
	@RequiresPermissions("hr:hrEmployee:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrQuit hrQuit, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrQuit> page = hrQuitService.findPage(new Page<HrQuit>(request, response), hrQuit); 
		model.addAttribute("page", page);
		return "modules/hr/hrQuitList";
	}

	/**
	 * 编辑离职表单页面
	 */
	@RequiresPermissions(value={"hr:hrEmployee:view","hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrQuit hrQuit, Model model) {
		
		if(hrQuit.getHrEmployee() != null){
			HrEmployee hrEmployee = hrEmployeeService.get(hrQuit.getHrEmployee().getId());
			hrQuit.setHrEmployee(hrEmployee);
		}

		model.addAttribute("hrQuit", hrQuit);
		return "modules/hr/hrQuitForm";
	}
	
	/**
	 * 查看离职页面
	 */
	@RequiresPermissions(value="hr:hrEmployee:view")
	@RequestMapping(value = "view")
	public String view(HrQuit hrQuit, Model model) {
		if(hrQuit.getHrEmployee() != null){
			HrEmployee hrEmployee = hrEmployeeService.get(hrQuit.getHrEmployee().getId());
			hrQuit.setHrEmployee(hrEmployee);
		}
		model.addAttribute("hrQuit", hrQuit);
		return "modules/hr/hrQuitView";
	}

	/**
	 * 保存离职
	 */
	@RequiresPermissions(value={"hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrQuit hrQuit, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrQuit)){
			return form(hrQuit, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrQuit.getHrEmployee().getId();
		}
		
		try{
		
			if(!hrQuit.getIsNewRecord()){//编辑表单保存				
				HrQuit t = hrQuitService.get(hrQuit.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrQuit, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrQuitService.save(t);//保存
			}else{//新增表单保存
				hrQuit.setStatus("0");
				hrQuitService.save(hrQuit);//保存
			}
			addMessage(redirectAttributes, "保存离职成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存离职失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrQuit.getHrEmployee().getId();
		}
	}
	
	/**
	 * 审核
	 * @param hrQuit
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "audit")
	public String audit(HrQuit hrQuit, RedirectAttributes redirectAttributes) {
		
		//审核离职
		hrQuitService.audit(hrQuit);
		addMessage(redirectAttributes, "审核离职成功");
		
		// 记录日志
		String logNote = "离职时间："+DateUtils.formatDate(hrQuit.getQuitDate(), "yyyy-MM-dd");
		ResumeLogUtils.addResumeLog(hrQuit.getHrEmployee().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_QUIT, logNote);
		
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrQuit.getHrEmployee().getId();
	}
	
	/**
	 * 删除离职
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "delete")
	public String delete(HrQuit hrQuit, RedirectAttributes redirectAttributes) {
		hrQuitService.delete(hrQuit);
		addMessage(redirectAttributes, "删除离职成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrQuit.getHrEmployee().getId();
	}
	
	/**
	 * 批量删除离职
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrQuitService.delete(hrQuitService.get(id));
		}
		addMessage(redirectAttributes, "删除离职成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrQuit/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrEmployee:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrQuit hrQuit, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "离职"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrQuit> page = hrQuitService.findPage(new Page<HrQuit>(request, response, -1), hrQuit);
    		new ExportExcel("离职", HrQuit.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出离职记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrQuit/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrEmployee:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrQuit> list = ei.getDataList(HrQuit.class);
			for (HrQuit hrQuit : list){
				try{
					hrQuitService.save(hrQuit);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条离职记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条离职记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入离职失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrQuit/?repage";
    }
	
	/**
	 * 下载导入离职数据模板
	 */
	@RequiresPermissions("hr:hrEmployee:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "离职数据导入模板.xlsx";
    		List<HrQuit> list = Lists.newArrayList(); 
    		new ExportExcel("离职数据", HrQuit.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrQuit/?repage";
    }
	
	/**
	 * 离职列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrQuit hrQuit, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrQuit, request, response, model);
        return "modules/hr/hrQuitSelectList";
	}
	
}