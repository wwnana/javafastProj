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
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.BrowseLogUtils;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

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
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.crm.service.CrmServiceService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaTaskService;

/**
 * 服务工单Controller
 * @author javafast
 * @version 2019-03-28
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmService")
public class CrmServiceController extends BaseController {

	@Autowired
	private CrmServiceService crmServiceService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmDocumentService crmDocumentService;
	
	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public CrmService get(@RequestParam(required=false) String id) {
		CrmService entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmServiceService.get(id);
		}
		if (entity == null){
			entity = new CrmService();
		}
		return entity;
	}
	
	/**
	 * 服务管理，查询客户
	 * @param crmService
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmService:list")
	@RequestMapping(value = "customerList")
	public String customerList(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		if(StringUtils.isNotBlank(crmCustomer.getName())) {
			Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
			model.addAttribute("page", page);
		}
		return "modules/crm/crmServiceCustomerList";
	}
	
	/**
	 * 服务管理，客户主页
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmService:list")
	@RequestMapping(value = "crmServiceCustomerIndex")
	public String crmServiceCustomerIndex(String id, Model model) {
		
		//客户
		CrmCustomer crmCustomer = crmCustomerService.get(id);
		
		//工单
		CrmService crmService = new CrmService();
		crmService.setCustomer(crmCustomer);
		model.addAttribute("crmService", crmService);
		
		//查询联系人
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		List<CrmContacter> crmContacterList = crmContacterService.findListByCustomer(crmContacter); 
		model.addAttribute("crmContacterList", crmContacterList);
		
		//查询跟进记录
		CrmContactRecord crmContactRecord = new CrmContactRecord();
		crmContactRecord.setTargetId(crmCustomer.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByCustomer(crmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
		
		//查询订单合同
		OmContract omContract = new OmContract();
		omContract.setCustomer(crmCustomer);
		List<OmContract> omContractList = omContractService.findListByCustomer(omContract);
		model.addAttribute("omContractList", omContractList);
		
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		fiReceiveAble.setCustomer(crmCustomer);
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findListByCustomer(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		//查询附件
		CrmDocument crmDocument = new CrmDocument();
		crmDocument.setCustomer(crmCustomer);
		List<CrmDocument> crmDocumentList = crmDocumentService.findList(crmDocument);
		model.addAttribute("crmDocumentList", crmDocumentList);
		
		//客户信息
		model.addAttribute("crmCustomer", crmCustomer);
		
		//查询客户概况统计
		CrmCustomer generalCout = crmCustomerService.getGeneralCountByCustomer(crmCustomer.getId());
		model.addAttribute("generalCout", generalCout);
		
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setContactDate(new Date());
		contactRecord.setTargetId(crmCustomer.getId());
		contactRecord.setTargetName(crmCustomer.getName());
		model.addAttribute("crmContactRecord", contactRecord);
		
		if(StringUtils.isNotBlank(crmCustomer.getCrmClueId())) {
			
			CrmClue crmClue = crmClueService.get(crmCustomer.getCrmClueId());
			if(crmClue != null)
				model.addAttribute("crmClue", crmClue);
		}
		
		//客户主页
		return "modules/crm/crmServiceCustomerIndex";
	}
	
	/**
	 * 服务工单列表页面
	 */
	@RequiresPermissions("crm:crmService:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmService crmService, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmService> page = crmServiceService.findPage(new Page<CrmService>(request, response), crmService); 
		model.addAttribute("page", page);
		return "modules/crm/crmServiceList";
	}

	/**
	 * 编辑服务工单表单页面
	 */
	@RequiresPermissions(value={"crm:crmService:view","crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmService crmService, Model model) {
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceForm";
	}
	
	/**
	 * 查看服务工单页面
	 */
	@RequiresPermissions(value="crm:crmService:view")
	@RequestMapping(value = "view")
	public String view(CrmService crmService, Model model) {
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceView";
	}

	/**
	 * 保存服务工单
	 */
	@RequiresPermissions(value={"crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmService crmService, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmService)){
			return form(crmService, model);
		}
		
		try{
		
			if(!crmService.getIsNewRecord()){//编辑表单保存				
				
				CrmService t = crmServiceService.get(crmService.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmService, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmServiceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{
				
				//新增表单保存
				crmService.setNo("GD"+IdUtils.getId());
				crmService.setStatus("0");
				crmServiceService.save(crmService);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_ADD, crmService.getId(), crmService.getName(), null);
			}
			
			//工单提醒
			User user = userService.get(crmService.getOwnBy().getId());
			if(StringUtils.isNotBlank(user.getUserId())) {
				String request_url_service_index = Global.getConfig("webSite")+Global.getConfig("adminPath") + "/crm/crmService/index";
				String content = "您有新的工单：" + crmService.getName() + "\n\n <a href=\""+request_url_service_index+"?id="+crmService.getId()+"\">点击查看详情</a>";
				WorkWechatMsgUtils.sendMsg(user.getUserId(), content, "0");
			}
			
			addMessage(redirectAttributes, "保存服务工单成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存服务工单失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
		}
	}
	
	/**
	 * 删除服务工单
	 */
	@RequiresPermissions("crm:crmService:del")
	@RequestMapping(value = "delete")
	public String delete(CrmService crmService, RedirectAttributes redirectAttributes) {
		crmServiceService.delete(crmService);
		addMessage(redirectAttributes, "删除服务工单成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
	}
	
	/**
	 * 批量删除服务工单
	 */
	@RequiresPermissions("crm:crmService:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmServiceService.delete(crmServiceService.get(id));
		}
		addMessage(redirectAttributes, "删除服务工单成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmService:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmService crmService, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "服务工单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmService> page = crmServiceService.findPage(new Page<CrmService>(request, response, -1), crmService);
    		new ExportExcel("服务工单", CrmService.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出服务工单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmService:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmService> list = ei.getDataList(CrmService.class);
			for (CrmService crmService : list){
				try{
					crmServiceService.save(crmService);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条服务工单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条服务工单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入服务工单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
    }
	
	/**
	 * 下载导入服务工单数据模板
	 */
	@RequiresPermissions("crm:crmService:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "服务工单数据导入模板.xlsx";
    		List<CrmService> list = Lists.newArrayList(); 
    		new ExportExcel("服务工单数据", CrmService.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
    }
	
	/**
	 * 服务工单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmService crmService, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmService, request, response, model);
        return "modules/crm/crmServiceSelectList";
	}
	
	/**
	 * 查看服务工单页面
	 */
	@RequiresPermissions(value="crm:crmService:view")
	@RequestMapping(value = "index")
	public String index(CrmService crmService, Model model) {
		model.addAttribute("crmService", crmService);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, crmService.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(crmService.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_ORDERWORK);
		contactRecord.setTargetId(crmService.getId());
		contactRecord.setTargetName(crmService.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
		
		return "modules/crm/crmServiceIndex";
	}
	
	/**
	 * 完成
	 * @param id
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "deal")
	public String deal(String id, RedirectAttributes redirectAttributes) {
		try{
		
			CrmService crmService = crmServiceService.get(id);
			crmService.setStatus("2");
			crmService.setDealDate(new Date());
			crmServiceService.save(crmService);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_END, crmService.getId(), crmService.getName(), crmService.getCustomer().getId());
			
			addMessage(redirectAttributes, "服务工单已标记为完成");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "操作失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
		}
	}
	
	/**
	 * 编辑服务工单表单页面
	 */
	@RequiresPermissions(value={"crm:crmService:view","crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "auditForm")
	public String auditForm(CrmService crmService, Model model) {
		crmService.setAuditBy(UserUtils.getUser());
		crmService.setAuditDate(new Date());
		model.addAttribute("crmService", crmService);
		return "modules/crm/crmServiceAuditForm";
	}

	/**
	 * 审核服务工单
	 */
	@RequiresPermissions(value={"crm:crmService:add","crm:crmService:edit"},logical=Logical.OR)
	@RequestMapping(value = "audit")
	public String audit(CrmService crmService, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmService)){
			return form(crmService, model);
		}
		
		try{
		
			if(!crmService.getIsNewRecord()){//编辑表单保存				
				crmService.setAuditStatus("1");
				CrmService t = crmServiceService.get(crmService.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmService, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmServiceService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDERWORK, Contants.ACTION_TYPE_AUDIT, crmService.getId(), crmService.getName(), crmService.getCustomer().getId());
			}
			
			addMessage(redirectAttributes, "审核服务工单成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/index?id="+crmService.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "审核服务工单失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmService/?repage";
		}
	}
}