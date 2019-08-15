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
import com.javafast.modules.crm.entity.CrmMarketData;
import com.javafast.modules.crm.service.CrmMarketDataService;

/**
 * 活动详情Controller
 * @author javafast
 * @version 2019-05-09
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmMarketData")
public class CrmMarketDataController extends BaseController {

	@Autowired
	private CrmMarketDataService crmMarketDataService;
	
	@ModelAttribute
	public CrmMarketData get(@RequestParam(required=false) String id) {
		CrmMarketData entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmMarketDataService.get(id);
		}
		if (entity == null){
			//防止异常
			entity = new CrmMarketData();
			entity.setId(id);
			crmMarketDataService.add(entity);//保存
			entity.setIsNewRecord(false);
		}
		return entity;
	}
	
	/**
	 * 活动详情列表页面
	 */
	@RequiresPermissions("crm:crmMarket:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmMarketData crmMarketData, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmMarketData> page = crmMarketDataService.findPage(new Page<CrmMarketData>(request, response), crmMarketData); 
		model.addAttribute("page", page);
		return "modules/crm/crmMarketDataList";
	}

	/**
	 * 编辑活动详情表单页面
	 */
	@RequiresPermissions(value={"crm:crmMarket:view","crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmMarketData crmMarketData, Model model) {

		model.addAttribute("crmMarketData", crmMarketData);
		return "modules/crm/crmMarketDataForm";
	}
	
	/**
	 * 查看活动详情页面
	 */
	@RequiresPermissions(value="crm:crmMarket:view")
	@RequestMapping(value = "view")
	public String view(CrmMarketData crmMarketData, Model model) {
		model.addAttribute("crmMarketData", crmMarketData);
		return "modules/crm/crmMarketDataView";
	}

	/**
	 * 保存活动详情
	 */
	@RequiresPermissions(value={"crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmMarketData crmMarketData, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmMarketData)){
			return form(crmMarketData, model);
		}
		
		try{
		
			crmMarketDataService.save(crmMarketData);//保存
			addMessage(redirectAttributes, "保存活动详情成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存活动详情失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/index?id="+crmMarketData.getId();
		}
	}
	
	/**
	 * 删除活动详情
	 */
	@RequiresPermissions("crm:crmMarket:del")
	@RequestMapping(value = "delete")
	public String delete(CrmMarketData crmMarketData, RedirectAttributes redirectAttributes) {
		crmMarketDataService.delete(crmMarketData);
		addMessage(redirectAttributes, "删除活动详情成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarketData/?repage";
	}
	
	/**
	 * 批量删除活动详情
	 */
	@RequiresPermissions("crm:crmMarket:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmMarketDataService.delete(crmMarketDataService.get(id));
		}
		addMessage(redirectAttributes, "删除活动详情成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarketData/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmMarket:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmMarketData crmMarketData, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "活动详情"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmMarketData> page = crmMarketDataService.findPage(new Page<CrmMarketData>(request, response, -1), crmMarketData);
    		new ExportExcel("活动详情", CrmMarketData.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出活动详情记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarketData/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmMarket:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmMarketData> list = ei.getDataList(CrmMarketData.class);
			for (CrmMarketData crmMarketData : list){
				try{
					crmMarketDataService.save(crmMarketData);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条活动详情记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条活动详情记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入活动详情失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarketData/?repage";
    }
	
	/**
	 * 下载导入活动详情数据模板
	 */
	@RequiresPermissions("crm:crmMarket:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "活动详情数据导入模板.xlsx";
    		List<CrmMarketData> list = Lists.newArrayList(); 
    		new ExportExcel("活动详情数据", CrmMarketData.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarketData/?repage";
    }
	
	/**
	 * 活动详情列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmMarketData crmMarketData, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmMarketData, request, response, model);
        return "modules/crm/crmMarketDataSelectList";
	}
	
}