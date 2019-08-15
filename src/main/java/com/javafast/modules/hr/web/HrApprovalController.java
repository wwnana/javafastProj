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
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.AccountUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrApproval;
import com.javafast.modules.hr.service.HrApprovalService;

/**
 * 审批记录Controller
 * @author javafast
 * @version 2018-07-16
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrApproval")
public class HrApprovalController extends BaseController {

	@Autowired
	private HrApprovalService hrApprovalService;
	
	@ModelAttribute
	public HrApproval get(@RequestParam(required=false) String id) {
		HrApproval entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrApprovalService.get(id);
		}
		if (entity == null){
			entity = new HrApproval();
		}
		return entity;
	}
	
	/**
	 * 审批记录列表页面
	 */
	@RequiresPermissions("hr:hrApproval:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrApproval hrApproval, HttpServletRequest request, HttpServletResponse response, Model model) {
		
    	//检测是否配置打卡应用的Secret
    	SysConfig sysConfig = AccountUtils.getSysConfig(UserUtils.getSysAccount().getId());
		if(sysConfig == null || StringUtils.isBlank(sysConfig.getWxCorpid()) || StringUtils.isBlank(sysConfig.getCheckinSecret())){
			model.addAttribute("configMsg", "获取企业微信打卡数据需要配置打卡应用的Secret，请前往进行配置");
		}
		
		if(hrApproval.getApprovalType() == null){
			hrApproval.setApprovalType("1");
		}
		Page<HrApproval> page = hrApprovalService.findPage(new Page<HrApproval>(request, response), hrApproval); 
		model.addAttribute("page", page);
		return "modules/hr/hrApprovalList";
	}

	/**
	 * 编辑审批记录表单页面
	 */
	@RequiresPermissions(value={"hr:hrApproval:view","hr:hrApproval:add","hr:hrApproval:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrApproval hrApproval, Model model) {
		model.addAttribute("hrApproval", hrApproval);
		return "modules/hr/hrApprovalForm";
	}
	
	/**
	 * 查看审批记录页面
	 */
	@RequiresPermissions(value="hr:hrApproval:view")
	@RequestMapping(value = "view")
	public String view(HrApproval hrApproval, Model model) {
		model.addAttribute("hrApproval", hrApproval);
		return "modules/hr/hrApprovalView";
	}

	/**
	 * 保存审批记录
	 */
	@RequiresPermissions(value={"hr:hrApproval:add","hr:hrApproval:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrApproval hrApproval, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrApproval)){
			return form(hrApproval, model);
		}
		
		try{
		
			if(!hrApproval.getIsNewRecord()){//编辑表单保存				
				HrApproval t = hrApprovalService.get(hrApproval.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrApproval, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrApprovalService.save(t);//保存
			}else{//新增表单保存
				hrApprovalService.save(hrApproval);//保存
			}
			addMessage(redirectAttributes, "保存审批记录成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存审批记录失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
		}
	}
	
	/**
	 * 删除审批记录
	 */
	@RequiresPermissions("hr:hrApproval:del")
	@RequestMapping(value = "delete")
	public String delete(HrApproval hrApproval, RedirectAttributes redirectAttributes) {
		hrApprovalService.delete(hrApproval);
		addMessage(redirectAttributes, "删除审批记录成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
	}
	
	/**
	 * 批量删除审批记录
	 */
	@RequiresPermissions("hr:hrApproval:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrApprovalService.delete(hrApprovalService.get(id));
		}
		addMessage(redirectAttributes, "删除审批记录成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrApproval:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrApproval hrApproval, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "审批记录"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrApproval> page = hrApprovalService.findPage(new Page<HrApproval>(request, response, -1), hrApproval);
    		new ExportExcel("审批记录", HrApproval.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出审批记录记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrApproval:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrApproval> list = ei.getDataList(HrApproval.class);
			for (HrApproval hrApproval : list){
				try{
					hrApprovalService.save(hrApproval);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条审批记录记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条审批记录记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入审批记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
    }
	
	/**
	 * 下载导入审批记录数据模板
	 */
	@RequiresPermissions("hr:hrApproval:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "审批记录数据导入模板.xlsx";
    		List<HrApproval> list = Lists.newArrayList(); 
    		new ExportExcel("审批记录数据", HrApproval.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrApproval/?repage";
    }
	
	/**
	 * 审批记录列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrApproval hrApproval, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrApproval, request, response, model);
        return "modules/hr/hrApprovalSelectList";
	}
	
}