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

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;

/**
 * 报价单Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmQuote")
public class CrmQuoteController extends BaseController {

	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private OmContractService omContractService;
	
	@ModelAttribute
	public CrmQuote get(@RequestParam(required=false) String id) {
		CrmQuote entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmQuoteService.get(id);
		}
		if (entity == null){
			entity = new CrmQuote();
		}
		return entity;
	}
	
	/**
	 * 报价单列表页面
	 */
	@RequiresPermissions("crm:crmQuote:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmQuote crmQuote, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmQuote> page = crmQuoteService.findPage(new Page<CrmQuote>(request, response), crmQuote); 
		model.addAttribute("page", page);
		return "modules/crm/crmQuoteList";
	}

	/**
	 * 查看，增加，编辑报价单表单页面
	 */
	@RequiresPermissions(value={"crm:crmQuote:view","crm:crmQuote:add","crm:crmQuote:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmQuote crmQuote, Model model) {
		
		if(crmQuote.getIsNewRecord()){
			crmQuote.setNo("BJ"+IdUtils.getId());
			crmQuote.setStatus("0");
			crmQuote.setOwnBy(UserUtils.getUser());
			crmQuote.setStartdate(new Date());
			crmQuote.setEnddate(DateUtils.getDayAfterN(30));
			
			if(crmQuote.getCustomer() != null && crmQuote.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(crmQuote.getCustomer().getId());
				crmQuote.setCustomer(customer);
			}
			if(crmQuote.getChance() != null && crmQuote.getChance().getId() != null){
				CrmChance chance = crmChanceService.get(crmQuote.getChance().getId());
				crmQuote.setChance(chance);
			}
		}

		model.addAttribute("crmQuote", crmQuote);
		return "modules/crm/crmQuoteForm";
	}
	
	/**
	 * 查看
	 */
	@RequiresPermissions(value="crm:crmQuote:view")
	@RequestMapping(value = "view")
	public String view(CrmQuote crmQuote, Model model) {
		model.addAttribute("crmQuote", crmQuote);
		
		//查询关联合同
		OmContract conOmContract = new OmContract();
		conOmContract.setQuote(crmQuote);
		List<OmContract> omContractList = omContractService.findList(conOmContract);
		model.addAttribute("omContractList", omContractList);
		
		//查询日志
		SysDynamic conSysDynamic = new SysDynamic();
		conSysDynamic.setTargetId(crmQuote.getId());
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(conSysDynamic);
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		return "modules/crm/crmQuoteIndex";
	}
	
	/**
	 * 打印
	 */
	@RequiresPermissions(value="crm:crmQuote:view")
	@RequestMapping(value = "print")
	public String print(CrmQuote crmQuote, Model model) {
		model.addAttribute("crmQuote", crmQuote);
		return "modules/crm/crmQuotePrint";
	}

	/**
	 * 保存报价单
	 */
	@RequiresPermissions(value={"crm:crmQuote:add","crm:crmQuote:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmQuote crmQuote, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmQuote)){
			return form(crmQuote, model);
		}
		
		try{
		
			if(!crmQuote.getIsNewRecord()){//编辑表单保存				
				CrmQuote t = crmQuoteService.get(crmQuote.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmQuote, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmQuoteService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				crmQuote.setStatus("0");
				crmQuoteService.save(crmQuote);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_ADD, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存报价单成功");
			//return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/view?id="+crmQuote.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存报价单失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
		}
	}
	
	/**
	 * 保存报价单
	 */
	@RequiresPermissions(value={"crm:crmQuote:add","crm:crmQuote:edit"},logical=Logical.OR)
	@RequestMapping(value = "saveIndexQuote")
	public String saveIndexQuote(CrmQuote crmQuote, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmQuote)){
			return form(crmQuote, model);
		}
		
		try{
		
			if(!crmQuote.getIsNewRecord()){//编辑表单保存				
				CrmQuote t = crmQuoteService.get(crmQuote.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmQuote, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmQuoteService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				crmQuote.setStatus("0");
				crmQuoteService.save(crmQuote);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_ADD, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存报价单成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmQuote.getCustomer().getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存报价单失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
		}
	}
	
	/**
	 * 删除报价单
	 */
	@RequiresPermissions("crm:crmQuote:del")
	@RequestMapping(value = "delete")
	public String delete(CrmQuote crmQuote, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
		}
		crmQuoteService.delete(crmQuote);
		addMessage(redirectAttributes, "删除报价单成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
	}
	
	/**
	 * 批量删除报价单
	 */
	@RequiresPermissions("crm:crmQuote:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmQuoteService.delete(crmQuoteService.get(id));
		}
		addMessage(redirectAttributes, "删除报价单成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
	}
	
	/**
	 * 删除报价单
	 */
	@RequiresPermissions("crm:crmQuote:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(CrmQuote crmQuote, RedirectAttributes redirectAttributes) {
		crmQuoteService.delete(crmQuote);
		addMessage(redirectAttributes, "删除报价单成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmQuote.getCustomer().getId();
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmQuote:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmQuote crmQuote, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "报价单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmQuote> page = crmQuoteService.findPage(new Page<CrmQuote>(request, response, -1), crmQuote);
    		new ExportExcel("报价单", CrmQuote.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出报价单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmQuote:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmQuote> list = ei.getDataList(CrmQuote.class);
			for (CrmQuote crmQuote : list){
				try{
					crmQuoteService.save(crmQuote);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条报价单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条报价单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入报价单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
    }
	
	/**
	 * 下载导入报价单数据模板
	 */
	@RequiresPermissions("crm:crmQuote:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "报价单数据导入模板.xlsx";
    		List<CrmQuote> list = Lists.newArrayList(); 
    		new ExportExcel("报价单数据", CrmQuote.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmQuote crmQuote, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmQuote, request, response, model);
        return "modules/crm/crmQuoteSelectList";
	}
	
	/**
	 * 审核报价单
	 * @param crmQuote
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmQuote:audit")
	@RequestMapping(value = "audit")
	public String audit(CrmQuote crmQuote, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/?repage";
		}
		try{
		
			crmQuote.setAuditBy(UserUtils.getUser());
			crmQuote.setAuditDate(new Date());
			crmQuoteService.audit(crmQuote);
			addMessage(redirectAttributes, "审核报价单成功");
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_AUDIT, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId());
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "审核报价单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmQuote/view?id="+crmQuote.getId();
		}
	}

}