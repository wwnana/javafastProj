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
import com.javafast.modules.oa.entity.OaWorkLogRule;
import com.javafast.modules.oa.service.OaWorkLogRuleService;

/**
 * 汇报规则Controller
 * @author javafast
 * @version 2018-07-17
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaWorkLogRule")
public class OaWorkLogRuleController extends BaseController {

	@Autowired
	private OaWorkLogRuleService oaWorkLogRuleService;
	
	@ModelAttribute
	public OaWorkLogRule get(@RequestParam(required=false) String id) {
		OaWorkLogRule entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaWorkLogRuleService.get(id);
		}
		if (entity == null){
			entity = new OaWorkLogRule();
		}
		return entity;
	}
	
	/**
	 * 汇报规则列表页面
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaWorkLogRule oaWorkLogRule, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaWorkLogRule> page = oaWorkLogRuleService.findPage(new Page<OaWorkLogRule>(request, response), oaWorkLogRule); 
		model.addAttribute("page", page);
		return "modules/oa/oaWorkLogRuleList";
	}

	/**
	 * 编辑汇报规则表单页面
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = "form")
	public String form(OaWorkLogRule oaWorkLogRule, Model model) {
		model.addAttribute("oaWorkLogRule", oaWorkLogRule);
		return "modules/oa/oaWorkLogRuleForm";
	}
	
	/**
	 * 查看汇报规则页面
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = "view")
	public String view(OaWorkLogRule oaWorkLogRule, Model model) {
		model.addAttribute("oaWorkLogRule", oaWorkLogRule);
		return "modules/oa/oaWorkLogRuleView";
	}

	/**
	 * 保存汇报规则
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = "save")
	public String save(OaWorkLogRule oaWorkLogRule, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaWorkLogRule)){
			return form(oaWorkLogRule, model);
		}
		
		try{
		
			if(!oaWorkLogRule.getIsNewRecord()){//编辑表单保存				
				OaWorkLogRule t = oaWorkLogRuleService.get(oaWorkLogRule.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaWorkLogRule, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaWorkLogRuleService.save(t);//保存
			}else{//新增表单保存
				oaWorkLogRuleService.save(oaWorkLogRule);//保存
			}
			addMessage(redirectAttributes, "保存汇报规则成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存汇报规则失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
		}
	}
	
	/**
	 * 删除汇报规则
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = "delete")
	public String delete(OaWorkLogRule oaWorkLogRule, RedirectAttributes redirectAttributes) {
		oaWorkLogRuleService.delete(oaWorkLogRule);
		addMessage(redirectAttributes, "删除汇报规则成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
	}
	
	/**
	 * 批量删除汇报规则
	 */
	@RequiresPermissions("oa:oaWorkLogRule:list")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaWorkLogRuleService.delete(oaWorkLogRuleService.get(id));
		}
		addMessage(redirectAttributes, "删除汇报规则成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaWorkLogRule:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaWorkLogRule oaWorkLogRule, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "汇报规则"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaWorkLogRule> page = oaWorkLogRuleService.findPage(new Page<OaWorkLogRule>(request, response, -1), oaWorkLogRule);
    		new ExportExcel("汇报规则", OaWorkLogRule.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出汇报规则记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaWorkLogRule:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaWorkLogRule> list = ei.getDataList(OaWorkLogRule.class);
			for (OaWorkLogRule oaWorkLogRule : list){
				try{
					oaWorkLogRuleService.save(oaWorkLogRule);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条汇报规则记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条汇报规则记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入汇报规则失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
    }
	
	/**
	 * 下载导入汇报规则数据模板
	 */
	@RequiresPermissions("oa:oaWorkLogRule:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "汇报规则数据导入模板.xlsx";
    		List<OaWorkLogRule> list = Lists.newArrayList(); 
    		new ExportExcel("汇报规则数据", OaWorkLogRule.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaWorkLogRule/?repage";
    }
	
	/**
	 * 汇报规则列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaWorkLogRule oaWorkLogRule, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaWorkLogRule, request, response, model);
        return "modules/oa/oaWorkLogRuleSelectList";
	}
	
}