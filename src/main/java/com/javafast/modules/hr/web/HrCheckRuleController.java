package com.javafast.modules.hr.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.alibaba.fastjson.JSON;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.modules.hr.api.WxCheckData;
import com.javafast.modules.hr.api.WxCheckInAPI;
import com.javafast.modules.hr.api.WxRuleInfo;
import com.javafast.modules.hr.dto.HrCheckRuleDTO;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrCheckRule;
import com.javafast.modules.hr.service.HrCheckRuleService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 打卡规则表Controller
 * @author javafast
 * @version 2018-07-08
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrCheckRule")
public class HrCheckRuleController extends BaseController {

	@Autowired
	private HrCheckRuleService hrCheckRuleService;
	
	@ModelAttribute
	public HrCheckRule get(@RequestParam(required=false) String id) {
		HrCheckRule entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrCheckRuleService.get(id);
		}
		if (entity == null){
			entity = new HrCheckRule();
		}
		return entity;
	}
	
	/**
	 * 打卡规则表列表页面
	 */
	@RequiresPermissions("hr:hrCheckReport:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrCheckRule hrCheckRule, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<HrCheckRule> hrCheckRuleList = hrCheckRuleService.findList(hrCheckRule);
		model.addAttribute("hrCheckRuleList", hrCheckRuleList);
		return "modules/hr/hrCheckRuleList";
	}

	/**
	 * 编辑打卡规则表表单页面
	 */
	@RequiresPermissions(value={"hr:hrCheckReport:view","hr:hrCheckReport:add","hr:hrCheckReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrCheckRule hrCheckRule, Model model) {
		model.addAttribute("hrCheckRule", hrCheckRule);
		return "modules/hr/hrCheckRuleForm";
	}




    @RequestMapping(value = "synch")
    public String synch( RedirectAttributes redirectAttributes, Model model) {

        try {
            hrCheckRuleService.synchHrCheckRuleList(UserUtils.getSysAccount().getId());
            addMessage(redirectAttributes, "同步成功");
        } catch (Exception e) {
            addMessage(redirectAttributes, "失败" + e.getMessage());
        }finally {
        	return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
		}
    }
	/**
	 * 查看打卡规则表页面
	 */
	@RequiresPermissions(value="hr:hrCheckReport:view")
	@RequestMapping(value = "view")
	public String view(HrCheckRule hrCheckRule, Model model) {
		HrCheckRuleDTO detail = this.hrCheckRuleService.detail(hrCheckRule.getId());
		model.addAttribute("hrCheckRuleDto", detail);
		return "modules/hr/hrCheckRuleDtoView";
	}

	/**
	 * 查看打卡规则表页面
	 */
	@RequiresPermissions(value="hr:hrCheckReport:view")
	@RequestMapping(value = "viewDetail")
	public String viewDetail(HrCheckRule hrCheckRule, Model model) {
		HrCheckRuleDTO detail = this.hrCheckRuleService.getCheckRuleDetailByName(hrCheckRule);
		model.addAttribute("hrCheckRuleDto", detail);
		return "modules/hr/hrCheckRuleDtoView";
	}


	/**
	 * 保存打卡规则表
	 */
	@RequiresPermissions(value={"hr:hrCheckReport:add","hr:hrCheckReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrCheckRule hrCheckRule, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrCheckRule)){
			return form(hrCheckRule, model);
		}
		
		try{
		
			if(!hrCheckRule.getIsNewRecord()){//编辑表单保存				
				HrCheckRule t = hrCheckRuleService.get(hrCheckRule.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrCheckRule, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrCheckRuleService.save(t);//保存
			}else{//新增表单保存
				hrCheckRuleService.save(hrCheckRule);//保存
			}
			addMessage(redirectAttributes, "保存打卡规则表成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存打卡规则表失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
		}
	}
	
	/**
	 * 删除打卡规则表
	 */
	@RequiresPermissions("hr:hrCheckReport:del")
	@RequestMapping(value = "delete")
	public String delete(HrCheckRule hrCheckRule, RedirectAttributes redirectAttributes) {
		hrCheckRuleService.delete(hrCheckRule);
		addMessage(redirectAttributes, "删除打卡规则表成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
	}
	
	/**
	 * 批量删除打卡规则表
	 */
	@RequiresPermissions("hr:hrCheckReport:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrCheckRuleService.delete(hrCheckRuleService.get(id));
		}
		addMessage(redirectAttributes, "删除打卡规则表成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrCheckReport:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrCheckRule hrCheckRule, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "打卡规则表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrCheckRule> page = hrCheckRuleService.findPage(new Page<HrCheckRule>(request, response, -1), hrCheckRule);
    		new ExportExcel("打卡规则表", HrCheckRule.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出打卡规则表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrCheckRule> list = ei.getDataList(HrCheckRule.class);
			for (HrCheckRule hrCheckRule : list){
				try{
					hrCheckRuleService.save(hrCheckRule);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条打卡规则表记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条打卡规则表记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入打卡规则表失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
    }
	
	/**
	 * 下载导入打卡规则表数据模板
	 */
	@RequiresPermissions("hr:hrCheckReport:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "打卡规则表数据导入模板.xlsx";
    		List<HrCheckRule> list = Lists.newArrayList(); 
    		new ExportExcel("打卡规则表数据", HrCheckRule.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrCheckRule/?repage";
    }
	
	/**
	 * 打卡规则表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrCheckRule hrCheckRule, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrCheckRule, request, response, model);
        return "modules/hr/hrCheckRuleSelectList";
	}



}