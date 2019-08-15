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

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.oa.entity.OaNote;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 客户关注Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmCustomerStar")
public class CrmCustomerStarController extends BaseController {

	@Autowired
	private CrmCustomerStarService crmCustomerStarService;
	
	@ModelAttribute
	public CrmCustomerStar get(@RequestParam(required=false) String id) {
		CrmCustomerStar entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmCustomerStarService.get(id);
		}
		if (entity == null){
			entity = new CrmCustomerStar();
		}
		return entity;
	}
	
	/**
	 * 客户关注列表页面
	 */
	@RequiresPermissions("crm:crmCustomerStar:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmCustomerStar crmCustomerStar, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmCustomerStar> page = crmCustomerStarService.findPage(new Page<CrmCustomerStar>(request, response), crmCustomerStar); 
		model.addAttribute("page", page);
		return "modules/crm/crmCustomerStarList";
	}

	/**
	 * 编辑客户关注客户关注表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomerStar:view","crm:crmCustomerStar:add","crm:crmCustomerStar:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmCustomerStar crmCustomerStar, Model model) {
		model.addAttribute("crmCustomerStar", crmCustomerStar);
		return "modules/crm/crmCustomerStarForm";
	}
	
	/**
	 * 查看客户关注页面
	 */
	@RequiresPermissions(value="crm:crmCustomerStar:view")
	@RequestMapping(value = "view")
	public String view(CrmCustomerStar crmCustomerStar, Model model) {
		model.addAttribute("crmCustomerStar", crmCustomerStar);
		return "modules/crm/crmCustomerStarView";
	}

	/**
	 * 保存客户关注
	 */
	@RequiresPermissions(value={"crm:crmCustomerStar:add","crm:crmCustomerStar:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmCustomerStar crmCustomerStar, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmCustomerStar)){
			return form(crmCustomerStar, model);
		}
		
		try{
		
			if(!crmCustomerStar.getIsNewRecord()){//编辑表单保存				
				CrmCustomerStar t = crmCustomerStarService.get(crmCustomerStar.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmCustomerStar, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmCustomerStarService.save(t);//保存
			}else{//新增表单保存
				crmCustomerStarService.save(crmCustomerStar);//保存
			}
			addMessage(redirectAttributes, "保存客户关注成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户关注失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
		}
	}
	
	/**
	 * 删除客户关注
	 */
	@RequiresPermissions("crm:crmCustomerStar:del")
	@RequestMapping(value = "delete")
	public String delete(CrmCustomerStar crmCustomerStar, RedirectAttributes redirectAttributes) {
		crmCustomerStarService.delete(crmCustomerStar);
		addMessage(redirectAttributes, "删除客户关注成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
	}
	
	/**
	 * 批量删除客户关注
	 */
	@RequiresPermissions("crm:crmCustomerStar:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmCustomerStarService.delete(crmCustomerStarService.get(id));
		}
		addMessage(redirectAttributes, "删除客户关注成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmCustomerStar:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmCustomerStar crmCustomerStar, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户关注"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmCustomerStar> page = crmCustomerStarService.findPage(new Page<CrmCustomerStar>(request, response, -1), crmCustomerStar);
    		new ExportExcel("客户关注", CrmCustomerStar.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户关注记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmCustomerStar:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmCustomerStar> list = ei.getDataList(CrmCustomerStar.class);
			for (CrmCustomerStar crmCustomerStar : list){
				try{
					crmCustomerStarService.save(crmCustomerStar);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户关注记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户关注记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户关注失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
    }
	
	/**
	 * 下载导入客户关注数据模板
	 */
	@RequiresPermissions("crm:crmCustomerStar:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户关注数据导入模板.xlsx";
    		List<CrmCustomerStar> list = Lists.newArrayList(); 
    		new ExportExcel("客户关注数据", CrmCustomerStar.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerStar/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmCustomerStar crmCustomerStar, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmCustomerStar, request, response, model);
        return "modules/crm/crmCustomerStarSelectList";
	}
	
	/**
	 * ajax保存关注
	 * @param customerId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveCustomerStar", method=RequestMethod.POST)
	public String saveCustomerStar(String customerId, boolean isStar) {
			
		try{
			
			CrmCustomerStar crmCustomerStar = new CrmCustomerStar();
			crmCustomerStar.setCustomer(new CrmCustomer(customerId));
			crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
			List<CrmCustomerStar> list = crmCustomerStarService.findList(crmCustomerStar);
			
			if(isStar){
				
				if(list != null && list.size()>0)
					crmCustomerStarService.delete(list.get(0));
			}else{
				
				if(list == null || list.size()==0)					
					crmCustomerStarService.save(crmCustomerStar);
			}
			
			return "true";		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "false";
	}
}