package com.javafast.modules.crm.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmTag;
import com.javafast.modules.crm.service.CrmTagService;
import com.javafast.modules.fi.entity.FiFinanceAccount;

/**
 * 客户标签Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmTag")
public class CrmTagController extends BaseController {

	@Autowired
	private CrmTagService crmTagService;
	
	@ModelAttribute
	public CrmTag get(@RequestParam(required=false) String id) {
		CrmTag entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmTagService.get(id);
		}
		if (entity == null){
			entity = new CrmTag();
		}
		return entity;
	}
	
	/**
	 * 客户标签列表页面
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmTag crmTag, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmTag> page = crmTagService.findPage(new Page<CrmTag>(request, response), crmTag); 
		model.addAttribute("page", page);
		return "modules/crm/crmTagList";
	}

	/**
	 * 编辑客户标签表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmTag crmTag, Model model) {
		model.addAttribute("crmTag", crmTag);
		return "modules/crm/crmTagForm";
	}
	
	/**
	 * 查看客户标签页面
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "view")
	public String view(CrmTag crmTag, Model model) {
		model.addAttribute("crmTag", crmTag);
		return "modules/crm/crmTagView";
	}

	/**
	 * 保存客户标签
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmTag crmTag, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmTag)){
			return form(crmTag, model);
		}
		
		try{
		
			if(!crmTag.getIsNewRecord()){//编辑表单保存				
				CrmTag t = crmTagService.get(crmTag.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmTag, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmTagService.save(t);//保存
			}else{//新增表单保存
				crmTagService.save(crmTag);//保存
			}
			addMessage(redirectAttributes, "保存客户标签成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户标签失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
		}
	}
	
	/**
	 * 删除客户标签
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmTag crmTag, RedirectAttributes redirectAttributes) {
		crmTagService.delete(crmTag);
		addMessage(redirectAttributes, "删除客户标签成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
	}
	
	/**
	 * 批量删除客户标签
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmTagService.delete(crmTagService.get(id));
		}
		addMessage(redirectAttributes, "删除客户标签成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmCustomer:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmTag crmTag, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户标签"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmTag> page = crmTagService.findPage(new Page<CrmTag>(request, response, -1), crmTag);
    		new ExportExcel("客户标签", CrmTag.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户标签记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmCustomer:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmTag> list = ei.getDataList(CrmTag.class);
			for (CrmTag crmTag : list){
				try{
					crmTagService.save(crmTag);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户标签记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户标签记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户标签失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
    }
	
	/**
	 * 下载导入客户标签数据模板
	 */
	@RequiresPermissions("crm:crmCustomer:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户标签数据导入模板.xlsx";
    		List<CrmTag> list = Lists.newArrayList(); 
    		new ExportExcel("客户标签数据", CrmTag.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmTag/?repage";
    }
	
	/**
	 * 客户标签列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmTag crmTag, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmTag, request, response, model);
        return "modules/crm/crmTagSelectList";
	}
	
	/**
	 * 获取下拉菜单数据
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getSelectData")
	public String getSelectData(){
		List<CrmTag> list = crmTagService.findList(new CrmTag());		
		String json = JsonMapper.getInstance().toJson(list);
		return json;
	}
}