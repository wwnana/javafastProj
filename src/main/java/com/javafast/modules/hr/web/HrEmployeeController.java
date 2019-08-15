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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrEmployee;
import com.javafast.modules.hr.entity.HrOffer;
import com.javafast.modules.hr.entity.HrOption;
import com.javafast.modules.hr.entity.HrQuit;
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.hr.entity.HrResumeLog;
import com.javafast.modules.hr.service.HrEmployeeService;
import com.javafast.modules.hr.service.HrOfferService;
import com.javafast.modules.hr.service.HrOptionService;
import com.javafast.modules.hr.service.HrQuitService;
import com.javafast.modules.hr.service.HrResumeLogService;
import com.javafast.modules.hr.service.HrResumeService;
import com.javafast.modules.hr.utils.ResumeLogUtils;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 员工信息Controller
 * @author javafast
 * @version 2018-07-03
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrEmployee")
public class HrEmployeeController extends BaseController {

	@Autowired
	private HrEmployeeService hrEmployeeService;
	
	@Autowired
	private HrResumeService hrResumeService;
	
	@Autowired
	private HrOfferService hrOfferService;
	
	@Autowired
	private HrResumeLogService hrResumeLogService;
	
	@Autowired
	private HrQuitService hrQuitService;
	
	@Autowired
	private HrOptionService hrOptionService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public HrEmployee get(@RequestParam(required=false) String id) {
		HrEmployee entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrEmployeeService.get(id);
		}
		if (entity == null){
			entity = new HrEmployee();
		}
		return entity;
	}
	
	/**
	 * 员工信息列表页面
	 */
	@RequiresPermissions("hr:hrEmployee:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrEmployee hrEmployee, HttpServletRequest request, HttpServletResponse response, Model model) {
		if(StringUtils.isBlank(hrEmployee.getStatus())){
			hrEmployee.setStatus("0");
		}
		Page<HrEmployee> page = hrEmployeeService.findPage(new Page<HrEmployee>(request, response), hrEmployee); 
		model.addAttribute("page", page);
		return "modules/hr/hrEmployeeList";
	}

	/**
	 * 编辑员工信息表单页面
	 */
	@RequiresPermissions(value={"hr:hrEmployee:view","hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrEmployee hrEmployee, Model model) {
		model.addAttribute("hrEmployee", hrEmployee);
		return "modules/hr/hrEmployeeForm";
	}
	
	/**
	 * 查看员工信息页面
	 */
	@RequiresPermissions(value="hr:hrEmployee:view")
	@RequestMapping(value = "view")
	public String view(HrEmployee hrEmployee, Model model) {
		model.addAttribute("hrEmployee", hrEmployee);
		return "modules/hr/hrEmployeeView";
	}
	
	/**
	 * 员工信息主页
	 * @param hrEmployee
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="hr:hrEmployee:view")
	@RequestMapping(value = "index")
	public String index(HrEmployee hrEmployee, Model model) {
		model.addAttribute("hrEmployee", hrEmployee);
		
		//查询用户信息
		User user = userService.get(hrEmployee.getId());
		model.addAttribute("user", user);
		
		//离职员工查询离职信息
		if("1".equals(hrEmployee.getStatus())){
			HrQuit hrQuit = new HrQuit();
			hrQuit.setHrEmployee(hrEmployee);
			List<HrQuit> hrQuitList = hrQuitService.findList(hrQuit);
			if(hrQuitList != null && hrQuitList.size()>0){
				model.addAttribute("hrQuit", hrQuitList.get(0));
			}
		}
		
		//期权
		HrOption hrOption = new HrOption();
		hrOption.setHrEmployee(hrEmployee);
		List<HrOption> hrOptionList = hrOptionService.findList(hrOption);
		model.addAttribute("hrOptionList", hrOptionList);
		
		//
		
		//查询HR日志
		List<HrResumeLog> hrResumeLogList = hrResumeLogService.findList(new HrResumeLog(null, hrEmployee.getHrResume().getId()));
		model.addAttribute("hrResumeLogList", hrResumeLogList);
		
		return "modules/hr/hrEmployeeIndex";
	}

	/**
	 * 保存员工信息
	 */
	@RequiresPermissions(value={"hr:hrEmployee:add","hr:hrEmployee:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrEmployee hrEmployee, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrEmployee)){
			return form(hrEmployee, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
		
		try{
		
			if(!hrEmployee.getIsNewRecord()){//编辑表单保存				
				HrEmployee t = hrEmployeeService.get(hrEmployee.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrEmployee, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrEmployeeService.save(t);//保存
			}else{//新增表单保存
				
				User user = hrEmployee.getUser();
				if(user.getOffice() != null){
					//获取公司部门
					user.setCompany(UserUtils.getUser().getCompany());
				}
				hrEmployee.setUser(user);
				hrEmployeeService.create(hrEmployee);//创建
			}
			addMessage(redirectAttributes, "保存员工信息成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存员工信息失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
		}
	}
	
	/**
	 * 删除员工信息
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "delete")
	public String delete(HrEmployee hrEmployee, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
		hrEmployeeService.delete(hrEmployee);
		addMessage(redirectAttributes, "删除员工信息成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
	}
	
	/**
	 * 批量删除员工信息
	 */
	@RequiresPermissions("hr:hrEmployee:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrEmployeeService.delete(hrEmployeeService.get(id));
		}
		addMessage(redirectAttributes, "删除员工信息成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrEmployee:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrEmployee hrEmployee, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "员工信息"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrEmployee> page = hrEmployeeService.findPage(new Page<HrEmployee>(request, response, -1), hrEmployee);
    		new ExportExcel("员工信息", HrEmployee.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出员工信息记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
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
			List<HrEmployee> list = ei.getDataList(HrEmployee.class);
			for (HrEmployee hrEmployee : list){
				try{
					hrEmployeeService.save(hrEmployee);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条员工信息记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条员工信息记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入员工信息失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
    }
	
	/**
	 * 下载导入员工信息数据模板
	 */
	@RequiresPermissions("hr:hrEmployee:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "员工信息数据导入模板.xlsx";
    		List<HrEmployee> list = Lists.newArrayList(); 
    		new ExportExcel("员工信息数据", HrEmployee.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/?repage";
    }
	
	/**
	 * 员工信息列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrEmployee hrEmployee, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrEmployee, request, response, model);
        return "modules/hr/hrEmployeeSelectList";
	}
	
	/**
	 * 入职页面
	 * @param hrEmployee
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "entryForm")
	public String entryForm(HrEmployee hrEmployee, Model model) {
		
		if(hrEmployee.getHrResume() != null){
			
			HrResume hrResume = hrResumeService.get(hrEmployee.getHrResume().getId());   //对应简历
			
			hrEmployee.setHrResume(hrResume);
			hrEmployee.setName(hrResume.getName());
			hrEmployee.setSex(hrResume.getSex());
			hrEmployee.setMobile(hrResume.getMobile());
			hrEmployee.setEmail(hrResume.getMail());
			hrEmployee.setEducationType(hrResume.getEducation());
			hrEmployee.setGraduateSchool(hrResume.getUniversity());
			hrEmployee.setSpecialty(hrResume.getSpecialty());
			hrEmployee.setLastCompany(hrResume.getLastCompany());
			hrEmployee.setLastPosition(hrResume.getLastJob());
			hrEmployee.setPosition(hrResume.getPosition());
			hrEmployee.setRecruitSource(hrResume.getResumeSource());
			
			//查询是否下发过offer
			List<HrOffer> hrOfferList = hrOfferService.findList(new HrOffer(null, hrResume));
			if(hrOfferList !=null && hrOfferList.size()>0){
				HrOffer hrOffer = hrOfferList.get(0);
				
				hrEmployee.setPosition(hrOffer.getPosition());
				hrEmployee.setEntryDate(hrOffer.getReportDate());
				hrEmployee.setProbationPeriod(hrOffer.getProbationPeriod());
				//计算转正日期
				if(hrOffer.getProbationPeriod() != null){
					Date regularDate = DateUtils.getDayAfterMonth(hrOffer.getReportDate(), hrOffer.getProbationPeriod());
					hrEmployee.setRegularDate(regularDate);
				}
				hrEmployee.setFormalSalaryBase(hrOffer.getFormalSalaryBase());
				hrEmployee.setProbationSalaryBase(hrOffer.getProbationSalaryBase());
				hrEmployee.setSalaryRemarks(hrOffer.getSalaryRemarks());
			}
			hrEmployee.setStatus("0");
		}
		
		model.addAttribute("hrEmployee", hrEmployee);
		return "modules/hr/hrEmployeeEntryForm";
	}
	
	/**
	 * 提交入职
	 * @param hrEmployee
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveEntry")
	public String saveEntry(HrEmployee hrEmployee, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrEmployee)){
			return form(hrEmployee, model);
		}

		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
		
		//检测是否重复入职
		HrEmployee conHrEmployee = new HrEmployee();
		conHrEmployee.setName(hrEmployee.getName());
		conHrEmployee.setMobile(hrEmployee.getMobile());
		List<HrEmployee> list = hrEmployeeService.findList(conHrEmployee);
		if(list != null && list.size()>0){
			addMessage(redirectAttributes, "入职失败，"+hrEmployee.getName()+"已经办理过入职");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/index?id="+hrEmployee.getHrResume().getId();
		}
		
		//检测是否可以创建账号
		User checkUser =  userService.findUniqueByProperty("mobile", hrEmployee.getMobile());
		if(checkUser != null){
			addMessage(redirectAttributes, "入职失败，"+hrEmployee.getName()+"已经创建了账号");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/index?id="+hrEmployee.getHrResume().getId();
		}
		
		try{
		
			User user = hrEmployee.getUser();
			if(hrEmployee.getOffice() != null){
				//获取公司部门
				user.setCompany(UserUtils.getUser().getCompany());
				user.setOffice(hrEmployee.getOffice());
			}
			hrEmployee.setUser(user);
			hrEmployeeService.create(hrEmployee);//创建
			
			// 记录日志
			String logNote = "职位：" + hrEmployee.getPosition()+"<br>入职时间："+DateUtils.formatDate(hrEmployee.getEntryDate(), "yyyy-MM-dd");
			ResumeLogUtils.addResumeLog(hrEmployee.getHrResume().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_ENTRY, logNote);
			
			//发送短信
            String isSmsMsg = request.getParameter("isSmsMsg");
            if ("1".equals(isSmsMsg)) {
            	SmsUtils.sendEntrySms(hrEmployee.getMobile(), hrEmployee.getName(), UserUtils.getSysAccount().getName(), Global.getConfig("webSite"));
            }
            
			addMessage(redirectAttributes, "入职办理成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "入职办理失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
	}
	
	/**
	 * 转正页面
	 * @param hrEmployee
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "regularForm")
	public String regularForm(HrEmployee hrEmployee, Model model) {
		
		model.addAttribute("hrEmployee", hrEmployee);
		return "modules/hr/hrEmployeeRegularForm";
	}
	
	/**
	 * 提交转正
	 * @param hrEmployee
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveRegular")
	public String saveRegular(HrEmployee hrEmployee, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrEmployee)){
			return form(hrEmployee, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
		
		try{
			
			hrEmployee.setRegularStatus("1");
			hrEmployeeService.save(hrEmployee);//保存
			
			// 记录日志
			String logNote = "转正时间："+DateUtils.formatDate(hrEmployee.getRegularDate(), "yyyy-MM-dd");
			ResumeLogUtils.addResumeLog(hrEmployee.getHrResume().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_REGULAR, logNote);
			addMessage(redirectAttributes, "转正办理成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "转正办理失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrEmployee/index?id="+hrEmployee.getId();
		}
	}
}