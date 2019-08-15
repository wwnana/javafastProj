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

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import org.hibernate.validator.constraints.Length;
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
import com.javafast.modules.hr.entity.HrOption;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrOptionService;
import com.javafast.modules.hr.utils.ResumeLogUtils;

/**
 * 期权Controller
 * @author javafast
 * @version 2018-07-06
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrOption")
public class HrOptionController extends BaseController {

	@Autowired
	private HrOptionService hrOptionService;
	
	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@ModelAttribute
	public HrOption get(@RequestParam(required=false) String id) {
		HrOption entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrOptionService.get(id);
		}
		if (entity == null){
			entity = new HrOption();
		}
		return entity;
	}
	
	/**
	 * 期权列表页面
	 */
	@RequiresPermissions("hr:hrEmployee:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrOption hrOption, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrOption> page = hrOptionService.findPage(new Page<HrOption>(request, response), hrOption); 
		model.addAttribute("page", page);
		return "modules/hr/hrOptionList";
	}

	/**
	 * 编辑期权表单页面
	 */
	@RequiresPermissions(value={"hr:hrEmployee:view","hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrOption hrOption, Model model) {
		if(hrOption.getHrEmployee() != null){
			HrEmployee hrEmployee = hrEmployeeService.get(hrOption.getHrEmployee().getId());
			hrOption.setHrEmployee(hrEmployee);
		}
		model.addAttribute("hrOption", hrOption);
		return "modules/hr/hrOptionForm";
	}
	
	/**
	 * 查看期权页面
	 */
	@RequiresPermissions(value="hr:hrEmployee:view")
	@RequestMapping(value = "view")
	public String view(HrOption hrOption, Model model) {
		if(hrOption.getHrEmployee() != null){
			HrEmployee hrEmployee = hrEmployeeService.get(hrOption.getHrEmployee().getId());
			hrOption.setHrEmployee(hrEmployee);
		}
		model.addAttribute("hrOption", hrOption);
		return "modules/hr/hrOptionView";
	}

	/**
	 * 保存期权
	 */
	@RequiresPermissions(value={"hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrOption hrOption, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrOption)){
			return form(hrOption, model);
		}
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrOption.getHrEmployee().getId();
		}
		try{
		
			if(!hrOption.getIsNewRecord()){//编辑表单保存				
				HrOption t = hrOptionService.get(hrOption.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrOption, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrOptionService.save(t);//保存
			}else{//新增表单保存
				hrOption.setStatus("0");
				hrOptionService.save(hrOption);//保存
				
				// 记录日志
				String logNote = "期权奖励"+"<br>授予时间："+DateUtils.formatDate(hrOption.getGrantDate(), "yyyy-MM-dd");
				ResumeLogUtils.addResumeLog(hrOption.getHrEmployee().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_REWARD, logNote);
			}
			addMessage(redirectAttributes, "保存期权成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存期权失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrOption.getHrEmployee().getId();
		}
	}
	
	/**
	 * 删除期权
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "delete")
	public String delete(HrOption hrOption, RedirectAttributes redirectAttributes) {
		hrOptionService.delete(hrOption);
		addMessage(redirectAttributes, "删除期权成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrOption.getHrEmployee().getId();
	}
	
	/**
	 * 批量删除期权
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrOptionService.delete(hrOptionService.get(id));
		}
		addMessage(redirectAttributes, "删除期权成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrOption/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrEmployee:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrOption hrOption, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "期权"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrOption> page = hrOptionService.findPage(new Page<HrOption>(request, response, -1), hrOption);
    		new ExportExcel("期权", HrOption.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出期权记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrOption/?repage";
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
			List<HrOption> list = ei.getDataList(HrOption.class);
			for (HrOption hrOption : list){
				try{
					hrOptionService.save(hrOption);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条期权记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条期权记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入期权失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrOption/?repage";
    }
	
	/**
	 * 下载导入期权数据模板
	 */
	@RequiresPermissions("hr:hrEmployee:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "期权数据导入模板.xlsx";
    		List<HrOption> list = Lists.newArrayList(); 
    		new ExportExcel("期权数据", HrOption.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrOption/?repage";
    }
	
	/**
	 * 期权列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrOption hrOption, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrOption, request, response, model);
        return "modules/hr/hrOptionSelectList";
	}
	
}