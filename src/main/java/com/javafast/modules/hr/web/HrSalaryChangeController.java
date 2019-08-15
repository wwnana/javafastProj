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

import com.javafast.modules.hr.entity.HrEmployee;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.sys.entity.User;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrSalaryChange;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrSalaryChangeService;
import com.javafast.modules.hr.utils.ResumeLogUtils;

/**
 * 调薪Controller
 * @author javafast
 * @version 2018-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrSalaryChange")
public class HrSalaryChangeController extends BaseController {

	@Autowired
	private HrSalaryChangeService hrSalaryChangeService;
	
	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@ModelAttribute
	public HrSalaryChange get(@RequestParam(required=false) String id) {
		HrSalaryChange entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrSalaryChangeService.get(id);
		}
		if (entity == null){
			entity = new HrSalaryChange();
		}
		return entity;
	}
	
	/**
	 * 调薪列表页面
	 */
	@RequiresPermissions("hr:hrSalaryChange:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrSalaryChange hrSalaryChange, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrSalaryChange> page = hrSalaryChangeService.findPage(new Page<HrSalaryChange>(request, response), hrSalaryChange); 
		model.addAttribute("page", page);
		return "modules/hr/hrSalaryChangeList";
	}

	/**
	 * 编辑调薪表单页面
	 */
	@RequiresPermissions(value={"hr:hrSalaryChange:view","hr:hrSalaryChange:add","hr:hrSalaryChange:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrSalaryChange hrSalaryChange, Model model) {
		
		if(hrSalaryChange.getHrEmployee() != null){
			
			HrEmployee hrEmployee = hrEmployeeService.get(hrSalaryChange.getHrEmployee().getId());
			hrSalaryChange.setHrEmployee(hrEmployee);
			model.addAttribute("hrEmployee", hrEmployee);
			
			if("0".equals(hrEmployee.getRegularStatus())){
				hrSalaryChange.setOldBaseSalary(hrEmployee.getProbationSalaryBase());
			}
			if("1".equals(hrEmployee.getRegularStatus())){
				hrSalaryChange.setOldBaseSalary(hrEmployee.getFormalSalaryBase());
			}
		}
		
		if(hrSalaryChange.getIsNewRecord()){
			hrSalaryChange.setEffectDate(new Date());
		}

		model.addAttribute("hrSalaryChange", hrSalaryChange);
		return "modules/hr/hrSalaryChangeForm";
	}
	
	/**
	 * 查看调薪页面
	 */
	@RequiresPermissions(value="hr:hrSalaryChange:view")
	@RequestMapping(value = "view")
	public String view(HrSalaryChange hrSalaryChange, Model model) {
		model.addAttribute("hrSalaryChange", hrSalaryChange);
		return "modules/hr/hrSalaryChangeView";
	}

	/**
	 * 保存调薪
	 */
	@RequiresPermissions(value={"hr:hrSalaryChange:add","hr:hrSalaryChange:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrSalaryChange hrSalaryChange, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrSalaryChange)){
			return form(hrSalaryChange, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrSalaryChange.getHrEmployee().getId();
		}
		
		try{
		
			if(!hrSalaryChange.getIsNewRecord()){//编辑表单保存				
				HrSalaryChange t = hrSalaryChangeService.get(hrSalaryChange.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrSalaryChange, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrSalaryChangeService.save(t);//保存
			}else{//新增表单保存
				hrSalaryChange.setStatus("0");
				hrSalaryChangeService.save(hrSalaryChange);//保存
			}
			addMessage(redirectAttributes, "保存调薪成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存调薪失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrSalaryChange.getHrEmployee().getId();
		}
	}
	
	/**
	 * 审核
	 * @param hrSalaryChange
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "audit")
	public String audit(HrSalaryChange hrSalaryChange, RedirectAttributes redirectAttributes) {
		
		try{
			
			hrSalaryChangeService.audit(hrSalaryChange);
			addMessage(redirectAttributes, "审核调薪成功");
			
			// 记录日志
			String logNote = "调薪前基本工资：" + hrSalaryChange.getOldBaseSalary()+"<br>调薪后基本工资：" + hrSalaryChange.getBaseSalary()+"<br>调薪幅度："+hrSalaryChange.getChangeRange()+"%";
			ResumeLogUtils.addResumeLog(hrSalaryChange.getHrEmployee().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_ADDSALARY, logNote);
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审核调薪失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
		}
	}
	
	/**
	 * 删除调薪
	 */
	@RequiresPermissions("hr:hrSalaryChange:del")
	@RequestMapping(value = "delete")
	public String delete(HrSalaryChange hrSalaryChange, RedirectAttributes redirectAttributes) {
		hrSalaryChangeService.delete(hrSalaryChange);
		addMessage(redirectAttributes, "删除调薪成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
	}
	
	/**
	 * 批量删除调薪
	 */
	@RequiresPermissions("hr:hrSalaryChange:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrSalaryChangeService.delete(hrSalaryChangeService.get(id));
		}
		addMessage(redirectAttributes, "删除调薪成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrSalaryChange:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrSalaryChange hrSalaryChange, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调薪"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrSalaryChange> page = hrSalaryChangeService.findPage(new Page<HrSalaryChange>(request, response, -1), hrSalaryChange);
    		new ExportExcel("调薪", HrSalaryChange.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调薪记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrSalaryChange:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrSalaryChange> list = ei.getDataList(HrSalaryChange.class);
			for (HrSalaryChange hrSalaryChange : list){
				try{
					hrSalaryChangeService.save(hrSalaryChange);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调薪记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调薪记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调薪失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
    }
	
	/**
	 * 下载导入调薪数据模板
	 */
	@RequiresPermissions("hr:hrSalaryChange:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调薪数据导入模板.xlsx";
    		List<HrSalaryChange> list = Lists.newArrayList(); 
    		new ExportExcel("调薪数据", HrSalaryChange.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryChange/?repage";
    }
	
	/**
	 * 调薪列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrSalaryChange hrSalaryChange, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrSalaryChange, request, response, model);
        return "modules/hr/hrSalaryChangeSelectList";
	}
	
}