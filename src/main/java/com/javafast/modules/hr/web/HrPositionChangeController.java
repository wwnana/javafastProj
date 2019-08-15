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

import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
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
import com.javafast.modules.hr.entity.HrPositionChange;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrPositionChangeService;
import com.javafast.modules.hr.utils.ResumeLogUtils;

/**
 * 调岗Controller
 * @author javafast
 * @version 2018-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrPositionChange")
public class HrPositionChangeController extends BaseController {

	@Autowired
	private HrPositionChangeService hrPositionChangeService;
	
	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public HrPositionChange get(@RequestParam(required=false) String id) {
		HrPositionChange entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrPositionChangeService.get(id);
		}
		if (entity == null){
			entity = new HrPositionChange();
		}
		return entity;
	}
	
	/**
	 * 调岗列表页面
	 */
	@RequiresPermissions("hr:hrEmployee:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrPositionChange hrPositionChange, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrPositionChange> page = hrPositionChangeService.findPage(new Page<HrPositionChange>(request, response), hrPositionChange); 
		model.addAttribute("page", page);
		return "modules/hr/hrPositionChangeList";
	}

	/**
	 * 编辑调岗表单页面
	 */
	@RequiresPermissions(value={"hr:hrEmployee:view","hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrPositionChange hrPositionChange, Model model) {
		
		if(hrPositionChange.getHrEmployee() != null){
			
			HrEmployee hrEmployee = hrEmployeeService.get(hrPositionChange.getHrEmployee().getId());
			hrPositionChange.setHrEmployee(hrEmployee);
			
			User user = userService.get(hrEmployee.getUser().getId());
			
			hrPositionChange.setOldOffice(user.getOffice());
			hrPositionChange.setOldPosition(hrEmployee.getPosition());
			hrPositionChange.setOldPositionLevel(hrEmployee.getPositionLevel());
			hrPositionChange.setChangeDate(new Date());
			model.addAttribute("hrPositionChange", hrPositionChange);
		}
		
		
		return "modules/hr/hrPositionChangeForm";
	}
	
	/**
	 * 查看调岗页面
	 */
	@RequiresPermissions(value="hr:hrEmployee:view")
	@RequestMapping(value = "view")
	public String view(HrPositionChange hrPositionChange, Model model) {

		if(hrPositionChange.getHrEmployee() != null){
			
			HrEmployee hrEmployee = hrEmployeeService.get(hrPositionChange.getHrEmployee().getId());
			hrPositionChange.setHrEmployee(hrEmployee);
		}
		
		model.addAttribute("hrPositionChange", hrPositionChange);
		return "modules/hr/hrPositionChangeView";
	}

	/**
	 * 保存调岗
	 */
	@RequiresPermissions(value={"hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrPositionChange hrPositionChange, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrPositionChange)){
			return form(hrPositionChange, model);
		}
		
		try{
		
			if(!hrPositionChange.getIsNewRecord()){//编辑表单保存				
				HrPositionChange t = hrPositionChangeService.get(hrPositionChange.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrPositionChange, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrPositionChangeService.save(t);//保存
			}else{
				
				//新增表单保存
				hrPositionChangeService.save(hrPositionChange);//保存
				
				HrEmployee hrEmployee = hrEmployeeService.get(hrPositionChange.getHrEmployee().getId());
				hrEmployee.setPosition(hrPositionChange.getPosition());
				hrEmployee.setPositionLevel(hrPositionChange.getPositionLevel());
				hrEmployeeService.save(hrEmployee);
				
				if(hrPositionChange.getOffice() != null && hrPositionChange.getOffice().getId() != null && hrPositionChange.getOldOffice()!=null && !hrPositionChange.getOldOffice().getId().equals(hrPositionChange.getOffice().getId())){
					
					//更新部门
					User user = userService.get(hrEmployee.getUser().getId());
					user.setOffice(hrPositionChange.getOffice());
					userService.updateUser(user);
				}	
				
				// 记录日志
				String logNote = "调岗前职位：" + hrPositionChange.getOldPosition()+"<br>调岗后职位：" + hrPositionChange.getPosition()+"<br>调岗时间："+DateUtils.formatDate(hrPositionChange.getChangeDate(), "yyyy-MM-dd");
				ResumeLogUtils.addResumeLog(hrPositionChange.getHrEmployee().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_CHANGEPOSITION, logNote);
			}
			addMessage(redirectAttributes, "调岗成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "调岗失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrPositionChange.getHrEmployee().getId();
		}
	}
	
	/**
	 * 删除调岗
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "delete")
	public String delete(HrPositionChange hrPositionChange, RedirectAttributes redirectAttributes) {
		hrPositionChangeService.delete(hrPositionChange);
		addMessage(redirectAttributes, "删除调岗成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrPositionChange/?repage";
	}
	
	/**
	 * 批量删除调岗
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrPositionChangeService.delete(hrPositionChangeService.get(id));
		}
		addMessage(redirectAttributes, "删除调岗成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrPositionChange/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrEmployee:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrPositionChange hrPositionChange, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调岗"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrPositionChange> page = hrPositionChangeService.findPage(new Page<HrPositionChange>(request, response, -1), hrPositionChange);
    		new ExportExcel("调岗", HrPositionChange.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调岗记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrPositionChange/?repage";
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
			List<HrPositionChange> list = ei.getDataList(HrPositionChange.class);
			for (HrPositionChange hrPositionChange : list){
				try{
					hrPositionChangeService.save(hrPositionChange);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调岗记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调岗记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调岗失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrPositionChange/?repage";
    }
	
	/**
	 * 下载导入调岗数据模板
	 */
	@RequiresPermissions("hr:hrEmployee:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调岗数据导入模板.xlsx";
    		List<HrPositionChange> list = Lists.newArrayList(); 
    		new ExportExcel("调岗数据", HrPositionChange.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrPositionChange/?repage";
    }
	
	/**
	 * 调岗列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrPositionChange hrPositionChange, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrPositionChange, request, response, model);
        return "modules/hr/hrPositionChangeSelectList";
	}
	
}