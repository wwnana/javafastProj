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
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
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
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmMarketService;

/**
 * 市场活动Controller
 * @author javafast
 * @version 2019-03-26
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmMarket")
public class CrmMarketController extends BaseController {

	@Autowired
	private CrmMarketService crmMarketService;
	
	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public CrmMarket get(@RequestParam(required=false) String id) {
		CrmMarket entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmMarketService.get(id);
		}
		if (entity == null){
			entity = new CrmMarket();
		}
		return entity;
	}
	
	/**
	 * 市场活动列表页面
	 */
	@RequiresPermissions("crm:crmMarket:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmMarket> page = crmMarketService.findPage(new Page<CrmMarket>(request, response), crmMarket); 
		model.addAttribute("page", page);
		return "modules/crm/crmMarketList";
	}

	/**
	 * 编辑市场活动表单页面
	 */
	@RequiresPermissions(value={"crm:crmMarket:view","crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmMarket crmMarket, Model model) {
		if(crmMarket.getIsNewRecord()){
			crmMarket.setOwnBy(UserUtils.getUser());
		}
		model.addAttribute("crmMarket", crmMarket);
		return "modules/crm/crmMarketForm";
	}
	
	/**
	 * 查看市场活动页面
	 */
	@RequiresPermissions(value="crm:crmMarket:view")
	@RequestMapping(value = "view")
	public String view(CrmMarket crmMarket, Model model) {
		model.addAttribute("crmMarket", crmMarket);
		return "modules/crm/crmMarketView";
	}

	/**
	 * 保存市场活动
	 */
	@RequiresPermissions(value={"crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmMarket crmMarket, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmMarket)){
			return form(crmMarket, model);
		}
		
		try{
		
			if(!crmMarket.getIsNewRecord()){//编辑表单保存				
				CrmMarket t = crmMarketService.get(crmMarket.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmMarket, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmMarketService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_MARKET, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				crmMarketService.save(crmMarket);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_MARKET, Contants.ACTION_TYPE_ADD, crmMarket.getId(), crmMarket.getName(), null);
			}
			addMessage(redirectAttributes, "保存市场活动成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/index?id="+crmMarket.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存市场活动失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
		}
	}
	
	/**
	 * 删除市场活动
	 */
	@RequiresPermissions("crm:crmMarket:del")
	@RequestMapping(value = "delete")
	public String delete(CrmMarket crmMarket, RedirectAttributes redirectAttributes) {
		crmMarketService.delete(crmMarket);
		addMessage(redirectAttributes, "删除市场活动成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
	}
	
	/**
	 * 批量删除市场活动
	 */
	@RequiresPermissions("crm:crmMarket:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmMarketService.delete(crmMarketService.get(id));
		}
		addMessage(redirectAttributes, "删除市场活动成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmMarket:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "市场活动"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmMarket> page = crmMarketService.findPage(new Page<CrmMarket>(request, response, -1), crmMarket);
    		new ExportExcel("市场活动", CrmMarket.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出市场活动记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
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
			List<CrmMarket> list = ei.getDataList(CrmMarket.class);
			for (CrmMarket crmMarket : list){
				try{
					crmMarketService.save(crmMarket);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条市场活动记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条市场活动记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入市场活动失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
    }
	
	/**
	 * 下载导入市场活动数据模板
	 */
	@RequiresPermissions("crm:crmMarket:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "市场活动数据导入模板.xlsx";
    		List<CrmMarket> list = Lists.newArrayList(); 
    		new ExportExcel("市场活动数据", CrmMarket.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmMarket/?repage";
    }
	
	/**
	 * 市场活动列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmMarket, request, response, model);
        return "modules/crm/crmMarketSelectList";
	}
	
	/**
	 * 
	 * @param crmMarket
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "index")
	public String index(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("crmMarket", crmMarket);
		
		CrmClue conCrmClue = new CrmClue();
		conCrmClue.setCrmMarket(crmMarket);
		Page<CrmClue> crmCluePage = crmClueService.findPage(new Page<CrmClue>(request, response), conCrmClue); 
		model.addAttribute("crmCluePage", crmCluePage);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_MARKET, crmMarket.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		return "modules/crm/crmMarketIndex";
	}
}