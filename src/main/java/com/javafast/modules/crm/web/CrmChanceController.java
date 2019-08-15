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
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;

/**
 * 商机Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmChance")
public class CrmChanceController extends BaseController {

	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@ModelAttribute
	public CrmChance get(@RequestParam(required=false) String id) {
		CrmChance entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmChanceService.get(id);
		}
		if (entity == null){
			entity = new CrmChance();
		}
		return entity;
	}
	
	/**
	 * 客户主页>商机
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "indexChanceList")
	public String indexChanceList(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CrmChance> list = crmChanceService.findListByCustomer(crmChance); 
		model.addAttribute("list", list);
		return "modules/crm/indexChanceList";
	}
	
	/**
	 * 商机列表页面
	 */
	@RequiresPermissions("crm:crmChance:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmChance> page = crmChanceService.findPage(new Page<CrmChance>(request, response), crmChance); 
		model.addAttribute("page", page);
		return "modules/crm/crmChanceList";
	}

	/**
	 * 商机看板页面
	 * @param crmChance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmChance:list")
	@RequestMapping(value = "list2")
	public String list2(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		if(crmChance.getBeginCreateDate() == null && crmChance.getEndCreateDate() == null) {
			crmChance.setBeginCreateDate(DateUtils.getBeginDayOfYear());
			crmChance.setEndCreateDate(DateUtils.getEndDayOfYear());
		}
		List<CrmChance> crmChanceList = crmChanceService.findList(crmChance);
		model.addAttribute("crmChanceList", crmChanceList);
		return "modules/crm/crmChanceList2";
	}
	
	/**
	 * 查看
	 */
	@RequiresPermissions(value="crm:crmChance:view")
	@RequestMapping(value = "view")
	public String view(CrmChance crmChance, Model model) {
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceView";
	}
	
	@RequiresPermissions(value="crm:crmChance:view")
	@RequestMapping(value = "index")
	public String index(CrmChance crmChance, Model model) {
		model.addAttribute("crmChance", crmChance);
		
		//查询关联报价单
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setChance(crmChance);
		List<CrmQuote> quoteList = crmQuoteService.findList(crmQuote);
		model.addAttribute("quoteList", quoteList);
		
		//查询关联订单合同
		OmContract conOmContract = new OmContract();
		conOmContract.setChance(crmChance);
		List<OmContract> omContractList = omContractService.findList(conOmContract);
		model.addAttribute("omContractList", omContractList);
		
		//查询商机里程
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, crmChance.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		//查询联系提醒
		if(crmChance.getNextcontactDate() != null){			
			int diffDay = DateUtils.differentDaysByMillisecond(new Date(), crmChance.getNextcontactDate());
			System.out.println(diffDay);
			model.addAttribute("diffDay", diffDay);		
		}
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(crmChance.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CHANCE);
		contactRecord.setTargetId(crmChance.getId());
		contactRecord.setTargetName(crmChance.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
		
		return "modules/crm/crmChanceIndex";
	}
	
	/**
	 * 查看，增加，编辑商机表单页面
	 */
	@RequiresPermissions(value={"crm:crmChance:view","crm:crmChance:add","crm:crmChance:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmChance crmChance, Model model) {

		if(crmChance.getIsNewRecord()){
			crmChance.setOwnBy(UserUtils.getUser());
			if(crmChance.getCustomer() != null && StringUtils.isNotBlank(crmChance.getCustomer().getId())){
				CrmCustomer customer = crmCustomerService.get(crmChance.getCustomer().getId());
				crmChance.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceForm";
	}

	/**
	 * 保存商机
	 */
	@RequiresPermissions(value={"crm:crmChance:add","crm:crmChance:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmChance crmChance, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmChance)){
			return form(crmChance, model);
		}
		
		try{
		
			if(!crmChance.getIsNewRecord()){//编辑表单保存				
				CrmChance t = crmChanceService.get(crmChance.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmChance, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmChanceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			}else{//新增表单保存
				crmChanceService.save(crmChance);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_ADD, crmChance.getId(), crmChance.getName(), crmChance.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存商机成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/index?id="+crmChance.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存商机失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
		}
	}
	
	/**
	 * 删除商机
	 */
	@RequiresPermissions("crm:crmChance:del")
	@RequestMapping(value = "delete")
	public String delete(CrmChance crmChance, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
		}
		crmChanceService.delete(crmChance);
		addMessage(redirectAttributes, "删除商机成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
	}
	
	/**
	 * 批量删除商机
	 */
	@RequiresPermissions("crm:crmChance:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmChanceService.delete(crmChanceService.get(id));
		}
		addMessage(redirectAttributes, "删除商机成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmChance:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "商机"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmChance> page = crmChanceService.findPage(new Page<CrmChance>(request, response, -1), crmChance);
    		new ExportExcel("商机", CrmChance.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出商机记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmChance:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmChance> list = ei.getDataList(CrmChance.class);
			for (CrmChance crmChance : list){
				try{
					crmChanceService.save(crmChance);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条商机记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条商机记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入商机失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
    }
	
	/**
	 * 下载导入商机数据模板
	 */
	@RequiresPermissions("crm:crmChance:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "商机数据导入模板.xlsx";
    		List<CrmChance> list = Lists.newArrayList(); 
    		new ExportExcel("商机数据", CrmChance.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmChance crmChance, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmChance, request, response, model);
        return "modules/crm/crmChanceSelectList";
	}
	
	/**
	 * 删除商机
	 */
	@RequiresPermissions("crm:crmChance:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(CrmChance crmChance, RedirectAttributes redirectAttributes) {
		crmChanceService.delete(crmChance);
		addMessage(redirectAttributes, "删除商机成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmChance.getCustomer().getId();
	}
	
	/**
	 * 更新商机阶段
	 * @param id
	 * @param periodType
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "updateChancePeriod")
	public String updateChancePeriod(String id, String periodType, RedirectAttributes redirectAttributes) {
		try {
			
			CrmChance crmChance = crmChanceService.get(id);
			crmChance.setPeriodType(periodType);
			
			//结算赢单率   销售阶段 1初步恰接，2需求确定，3方案报价，4签订合同,5赢单,6输单
			if("1".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(1);//10%
			}
			if("2".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(3);//30%
			}
			if("3".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(6);//60%
			}
			if("4".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(8);//80%
			}
			if("5".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(10);//100%
			}
			if("6".equals(crmChance.getPeriodType())) {
				crmChance.setProbability(0);//0%
			}
			crmChanceService.save(crmChance);
			addMessage(redirectAttributes, "更新成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "更新失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/index?id="+id;
		}
	}
	
	/**
	 * 输单form
	 * @param crmChance
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "loseForm")
	public String loseForm(CrmChance crmChance, Model model) {
		
		crmChance.setPeriodType("6");
		crmChance.setProbability(0);//0%
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmChanceLoseForm";
	}

	/**
	 * 更新商机-输单
	 */
	@RequestMapping(value = "saveLose")
	public String saveLose(CrmChance crmChance, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmChance)){
			return form(crmChance, model);
		}
		
		try{
		
			CrmChance t = crmChanceService.get(crmChance.getId());//从数据库取出记录的值
			t.setLoseReasons(crmChance.getLoseReasons());
			t.setPeriodType("6");
			t.setProbability(0);//0%
			crmChanceService.save(t);//保存
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			addMessage(redirectAttributes, "更新商机成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/index?id="+crmChance.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "更新商机失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmChance/?repage";
		}
	}
	
}