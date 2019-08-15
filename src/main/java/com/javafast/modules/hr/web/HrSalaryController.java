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
import com.javafast.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
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
import com.javafast.modules.hr.entity.HrEmployee;
import com.javafast.modules.hr.entity.HrSalary;
import com.javafast.modules.hr.entity.HrSalaryDetail;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrSalaryService;

/**
 * 工资表Controller
 * @author javafast
 * @version 2018-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrSalary")
public class HrSalaryController extends BaseController {

	@Autowired
	private HrSalaryService hrSalaryService;
	
	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@ModelAttribute
	public HrSalary get(@RequestParam(required=false) String id) {
		HrSalary entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrSalaryService.get(id);
		}
		if (entity == null){
			entity = new HrSalary();
		}
		return entity;
	}
	
	/**
	 * 工资表列表页面
	 */
	@RequiresPermissions("hr:hrSalary:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrSalary hrSalary, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrSalary> page = hrSalaryService.findPage(new Page<HrSalary>(request, response), hrSalary); 
		model.addAttribute("page", page);
		return "modules/hr/hrSalaryList";
	}

	/**
	 * 编辑工资表表单页面
	 */
	@RequiresPermissions(value={"hr:hrSalary:view","hr:hrSalary:add","hr:hrSalary:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrSalary hrSalary, Model model) {
		
		if(hrSalary.getIsNewRecord()){
			
			//获取当前月份
			String dateStr = DateUtils.getBeginDayOfMonthStr();
			String year = dateStr.substring(0, 4);
			String month = dateStr.substring(5, 7);
			
			//获取应出勤天数
			Integer mustWorkDays = 22;
			
			//判断当月是否生成了工资表
			hrSalary.setYear(year);
			hrSalary.setMonth(month);
			hrSalary.setWorkDays(mustWorkDays);
			List<HrSalary> hrSalaryList = hrSalaryService.findList(hrSalary);
			if(hrSalaryList != null && hrSalaryList.size() > 0){

				//从数据库获取当月工资表
				hrSalary = hrSalaryService.get(hrSalaryList.get(0).getId());
			}else{
				
				List<HrSalaryDetail> hrSalaryDetailList = Lists.newArrayList();	
				
				//查询所有在职的员工明细
				HrEmployee conHrEmployee = new HrEmployee();
				conHrEmployee.setStatus("0");
				List<HrEmployee> hrEmployeeList = hrEmployeeService.findList(conHrEmployee);
				for(int i=0; i<hrEmployeeList.size(); i++){
					HrEmployee hrEmployee = hrEmployeeList.get(i);
					
					HrSalaryDetail hrSalaryDetail = new HrSalaryDetail();
					hrSalaryDetail.setHrEmployee(hrEmployee);
					hrSalaryDetail.setName(hrEmployee.getName());
					hrSalaryDetail.setMustWorkDays(mustWorkDays);
					
					if("0".equals(hrEmployee.getRegularStatus())){
						hrSalaryDetail.setBaseSalary(hrEmployee.getProbationSalaryBase());
					}
					if("1".equals(hrEmployee.getRegularStatus())){
						hrSalaryDetail.setBaseSalary(hrEmployee.getFormalSalaryBase());
					}
					
					hrSalaryDetailList.add(hrSalaryDetail);
				}
				
				hrSalary.setHrSalaryDetailList(hrSalaryDetailList);
			}
		}
		model.addAttribute("hrSalary", hrSalary);
		return "modules/hr/hrSalaryForm";
	}
	
	/**
	 * 查看工资表页面
	 */
	@RequiresPermissions(value="hr:hrSalary:view")
	@RequestMapping(value = "view")
	public String view(HrSalary hrSalary, Model model) {
		model.addAttribute("hrSalary", hrSalary);
		return "modules/hr/hrSalaryView";
	}

	/**
	 * 保存工资表
	 */
	@RequiresPermissions(value={"hr:hrSalary:add","hr:hrSalary:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrSalary hrSalary, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrSalary)){
			return form(hrSalary, model);
		}
		
		try{
		
			if(!hrSalary.getIsNewRecord()){//编辑表单保存				
				HrSalary t = hrSalaryService.get(hrSalary.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrSalary, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrSalaryService.save(t);//保存
			}else{//新增表单保存
				hrSalary.setStatus("0");
				hrSalaryService.save(hrSalary);//保存
			}
			addMessage(redirectAttributes, "保存工资表成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存工资表失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
		}
	}
	
	/**
	 * 删除工资表
	 */
	@RequiresPermissions("hr:hrSalary:del")
	@RequestMapping(value = "delete")
	public String delete(HrSalary hrSalary, RedirectAttributes redirectAttributes) {
		hrSalaryService.delete(hrSalary);
		addMessage(redirectAttributes, "删除工资表成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
	}
	
	/**
	 * 批量删除工资表
	 */
	@RequiresPermissions("hr:hrSalary:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrSalaryService.delete(hrSalaryService.get(id));
		}
		addMessage(redirectAttributes, "删除工资表成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrSalary:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrSalary hrSalary, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工资表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrSalary> page = hrSalaryService.findPage(new Page<HrSalary>(request, response, -1), hrSalary);
    		new ExportExcel("工资表", HrSalary.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出工资表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrSalary:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrSalary> list = ei.getDataList(HrSalary.class);
			for (HrSalary hrSalary : list){
				try{
					hrSalaryService.save(hrSalary);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条工资表记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条工资表记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入工资表失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
    }
	
	/**
	 * 下载导入工资表数据模板
	 */
	@RequiresPermissions("hr:hrSalary:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工资表数据导入模板.xlsx";
    		List<HrSalary> list = Lists.newArrayList(); 
    		new ExportExcel("工资表数据", HrSalary.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalary/?repage";
    }
	
	/**
	 * 工资表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrSalary hrSalary, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrSalary, request, response, model);
        return "modules/hr/hrSalarySelectList";
	}
	
}