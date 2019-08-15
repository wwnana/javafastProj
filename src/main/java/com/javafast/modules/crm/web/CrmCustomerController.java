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

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.iim.utils.MailUtils;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.BrowseLogUtils;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsProduct;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.entity.CrmDocument;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.entity.CrmService;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.crm.service.CrmServiceService;

/**
 * 客户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmCustomer")
public class CrmCustomerController extends BaseController {

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
	private OaTaskService oaTaskService;
	
	@Autowired
	private CrmCustomerStarService crmCustomerStarService;
	
	@Autowired
	private MyCalendarService myCalendarService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmDocumentService crmDocumentService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CrmServiceService crmServiceService;
	
	@ModelAttribute
	public CrmCustomer get(@RequestParam(required=false) String id) {
		CrmCustomer entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmCustomerService.get(id);
		}
		if (entity == null){
			entity = new CrmCustomer();
		}
		return entity;
	}
	
	/**
	 * 客户列表页面
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
		model.addAttribute("page", page);
		return "modules/crm/crmCustomerList";
	}

	/**
	 * 客户查重列表页面
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "query")
	public String query(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		if(StringUtils.isNotBlank(crmCustomer.getKeywords())) {
			
			Page<CrmCustomer> page = crmCustomerService.findAllPage(new Page<CrmCustomer>(request, response), crmCustomer); 
			model.addAttribute("page", page);
		}
		
		return "modules/crm/crmCustomerQueryList";
	}
	
	/**
	 * 查看，增加，编辑客户表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmCustomer crmCustomer, Model model) {
		
		if(crmCustomer.getIsNewRecord()){
			
			if(crmCustomer.getOwnBy() == null){
				crmCustomer.setOwnBy(UserUtils.getUser());
			}
		}
		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerForm";
	}
	
	/**
	 * 修改客户表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "editForm")
	public String editForm(CrmCustomer crmCustomer, Model model) {
		
		if(crmCustomer.getIsNewRecord()){
			
			if(crmCustomer.getOwnBy() == null){
				crmCustomer.setOwnBy(UserUtils.getUser());
			}
		}
		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerEditForm";
	}

	/**
	 * 保存客户
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmCustomer crmCustomer, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, crmCustomer)){
			return form(crmCustomer, model);
		}
		
		try{
						
			if(!crmCustomer.getIsNewRecord()){//编辑表单保存
				CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmCustomer, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmCustomerService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getId());
			}else{
				
				//首要联系人
				if(crmCustomer.getCrmContacter() != null && StringUtils.isNotBlank(crmCustomer.getCrmContacter().getName())){
					crmCustomer.setContacterName(crmCustomer.getCrmContacter().getName());
					crmCustomer.setMobile(crmCustomer.getCrmContacter().getMobile());
				}
				
				//新增表单保存				
				crmCustomerService.save(crmCustomer);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_ADD, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			}
			addMessage(redirectAttributes, "保存客户成功");			
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/?repage";
		}		
	}
	
	/**
	 * 锁定
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:edit")
	@RequestMapping(value = "lock")
	public String lock(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
		try{
			
			crmCustomerService.lock(crmCustomer);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_LOCK, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			addMessage(redirectAttributes, "锁定客户成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "操作失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/?repage";
		}		
	}
	
	/**
	 * 解锁
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:edit")
	@RequestMapping(value = "unLock")
	public String unLock(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
		try{
			
			crmCustomerService.unLock(crmCustomer);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_UNLOCK, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			addMessage(redirectAttributes, "解锁客户成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "操作失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/?repage";
		}	
	}
	
	/**
	 * 删除客户
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
		crmCustomerService.delete(crmCustomer);
		DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DEL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
		addMessage(redirectAttributes, "删除客户成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
	}
	
	/**
	 * 批量删除客户
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmCustomerService.delete(crmCustomerService.get(id));
		}
		addMessage(redirectAttributes, "删除客户成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmCustomer:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response, -1), crmCustomer);
    		new ExportExcel("客户", CrmCustomer.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
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
			List<CrmCustomer> list = ei.getDataList(CrmCustomer.class);
			for (CrmCustomer crmCustomer : list){
				try{
					
					crmCustomer.setCustomerType("0");
					crmCustomer.setOwnBy(UserUtils.getUser());
					crmCustomer.setIsPool("0");
					crmCustomerService.add(crmCustomer);
					
					DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_IMPORT, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
					
					//保存首要联系人
					if(StringUtils.isNotBlank(crmCustomer.getContacterName())){
						
						CrmContacter crmContacter = new CrmContacter();
						crmContacter.setCustomer(crmCustomer);
						crmContacter.setName(crmCustomer.getContacterName());
						crmContacter.setMobile(crmCustomer.getMobile());
						crmContacter.setOwnBy(UserUtils.getUser());
						crmContacterService.save(crmContacter);
						
						DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, Contants.ACTION_TYPE_IMPORT, crmContacter.getId(), crmContacter.getName(), crmCustomer.getId());
					}
					
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
					ex.printStackTrace();
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条客户记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条客户记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入客户失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
    }
	
	/**
	 * 下载导入客户数据模板
	 */
	@RequiresPermissions("crm:crmCustomer:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户数据导入模板.xlsx";
    		List<CrmCustomer> list = Lists.newArrayList(); 
    		new ExportExcel("客户数据", CrmCustomer.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
    }
	
	/**
	 * 列表选择器
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
        list(crmCustomer, request, response, model);
        return "modules/crm/crmCustomerSelectList";
	}
	
	/**
	 * 客户指派表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "shareForm")
	public String shareForm(CrmCustomer crmCustomer, Model model) {
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerShareForm";
	}
	
	/**
	 * 保存客户指派
	 * @param crmCustomer
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "saveShare")
	public String saveShare(CrmCustomer crmCustomer, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, crmCustomer)){
			return form(crmCustomer, model);
		}
		
		try{
			
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			
			User user = userService.getUserByDb(crmCustomer.getOwnBy().getId());
			t.setOwnBy(user);
			t.setOfficeId(user.getOfficeId());
			crmCustomerService.updateOwnBy(t);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_APPOINT, t.getId(), t.getName(), t.getId());
			addMessage(redirectAttributes, "指派客户成功");
			
			//消息提醒
			String isMsg = request.getParameter("isMsg");
			String isSmsMsg = request.getParameter("isSmsMsg");
			ReportUtils.sendWxMsg(crmCustomer, isMsg, isSmsMsg);
			
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "指派客户失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
	}
	
	/**
	 * 批量指派
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:share","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "batchShare")
	public String batchShare(String ids, Model model) {
				
		model.addAttribute("ids", ids);
		return "modules/crm/crmCustomerBatchShareForm";
	}
	
	/**
	 * 保存批量指派
	 * @param ids
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:share","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "saveBatchShare")
	public String saveBatchShare(CrmCustomer crmCustomer, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		
		try{
			
			String ids = request.getParameter("ids");
			String ownById = request.getParameter("ownBy.id");
			System.out.println("ownById:"+ownById);
			
			User user = userService.getUserByDb(crmCustomer.getOwnBy().getId());
			
			String idArray[] =ids.split(",");
			for(String id : idArray){
				CrmCustomer t = crmCustomerService.get(id);//从数据库取出记录的值
				t.setOwnBy(user);
				t.setOfficeId(user.getOfficeId());
				
				crmCustomerService.updateOwnBy(t);
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_APPOINT, t.getId(), t.getName(), t.getId());
			}
			addMessage(redirectAttributes, "批量指派客户成功");
			
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "批量指派客户失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
	}
	
	/**
	 * 领取客户
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "receipt")
	public String receipt(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		
		try{
			
			//判断是否已经被领取
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			if("0".equals(t.getIsPool())) {
				addMessage(redirectAttributes, "对不起，该客户刚刚已被其他人领取了");
				return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
			}
			
			//更新客户负责人和负责人部门信息	
			t.setOwnBy(UserUtils.getUser());
			t.setOfficeId(UserUtils.getUser().getOffice().getId());
			crmCustomerService.updateOwnBy(t);			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DRAW, t.getId(), t.getName(), t.getId());
			addMessage(redirectAttributes, "领取客户成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "客户领取失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * 客户详情
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "detail")
	public String home(CrmCustomer crmCustomer, Model model) {
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerDetail";
	}
	
	/**
	 * 客户基本信息
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "view")
	public String view(CrmCustomer crmCustomer, Model model) {
		model.addAttribute("crmCustomer", crmCustomer);
		
		//查询客户里程
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(crmCustomer.getId(), true));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		return "modules/crm/crmCustomerView";
	}
	
	/**
	 * 客户主页
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "index")
	public String index(CrmCustomer crmCustomer, Model model) {
		
		//客户信息
		model.addAttribute("crmCustomer", crmCustomer);
				
		//添加浏览足迹
		BrowseLogUtils.addBrowseLog("1", crmCustomer.getId(), crmCustomer.getName());
		
		//查询联系人
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(crmCustomer);
		List<CrmContacter> crmContacterList = crmContacterService.findListByCustomer(crmContacter); 
		model.addAttribute("crmContacterList", crmContacterList);
		
		//查询商机
		CrmChance crmChance = new CrmChance();
		crmChance.setCustomer(crmCustomer);
		List<CrmChance> crmChanceList = crmChanceService.findListByCustomer(crmChance); 
		model.addAttribute("crmChanceList", crmChanceList);
		
		//查询跟进记录
		CrmContactRecord crmContactRecord = new CrmContactRecord();
		crmContactRecord.setTargetId(crmCustomer.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByCustomer(crmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
		
		//查询报价
		CrmQuote crmQuote = new CrmQuote();
		crmQuote.setCustomer(crmCustomer);
		List<CrmQuote> crmQuoteList = crmQuoteService.findListByCustomer(crmQuote);
		model.addAttribute("crmQuoteList", crmQuoteList);
		
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
		
		//查询服务工单
		CrmService conCrmService = new CrmService();
		conCrmService.setCustomer(crmCustomer);
		List<CrmService> crmServiceList = crmServiceService.findList(conCrmService);
		model.addAttribute("crmServiceList", crmServiceList);
		
//		//查询关联任务
//		OaTask oaTask = new OaTask();
//		oaTask.setRelationId(crmCustomer.getId());
//		List<OaTask> oaTaskList = oaTaskService.findList(oaTask);
//		model.addAttribute("oaTaskList", oaTaskList);
//		
//		//查询日程数
//		MyCalendar myCalendar = new MyCalendar();
//		myCalendar.setCustomerId(crmCustomer.getId());
//		Long calendarCount = myCalendarService.findCount(myCalendar);
//		model.addAttribute("calendarCount", calendarCount);
		
		//查询附件
		CrmDocument crmDocument = new CrmDocument();
		crmDocument.setCustomer(crmCustomer);
		List<CrmDocument> crmDocumentList = crmDocumentService.findList(crmDocument);
		model.addAttribute("crmDocumentList", crmDocumentList);
		
		//查询是否关注
		CrmCustomerStar crmCustomerStar = new CrmCustomerStar();
		crmCustomerStar.setCustomer(crmCustomer);
		crmCustomerStar.setOwnBy(UserUtils.getUser().getId());
		List<CrmCustomerStar> starList = crmCustomerStarService.findList(crmCustomerStar);
		if(starList != null && starList.size()>0){			
			model.addAttribute("isStar", "1");
		}
		
		//查询客户日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(crmCustomer.getId(), true));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//查询客户概况统计
		CrmCustomer generalCout = crmCustomerService.getGeneralCountByCustomer(crmCustomer.getId());
		model.addAttribute("generalCout", generalCout);
		
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CUSTOMER);
		contactRecord.setTargetId(crmCustomer.getId());
		contactRecord.setTargetName(crmCustomer.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
		
		//客户主页
		return "modules/crm/crmCustomerIndex";
	}
	
	/**
	 * 回收站
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:edit")
	@RequestMapping(value = "delList")
	public String delList(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Page<CrmCustomer> page = crmCustomerService.findDelPage(new Page<CrmCustomer>(request, response), crmCustomer); 
		model.addAttribute("page", page);
		return "modules/crm/crmCustomerDelList";
	}
	
	/**
	 * 还原
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:edit")
	@RequestMapping(value = "replay")
	public String replay(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {

		try{
			
			crmCustomerService.replay(crmCustomer);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_BACK, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			addMessage(redirectAttributes, "还原客户成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "还原客户失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * 批量还原
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:edit")
	@RequestMapping(value = "replayAll")
	public String replayAll(String ids, RedirectAttributes redirectAttributes) {
		
		try{
			
			String idArray[] =ids.split(",");
			for(String id : idArray){
				crmCustomerService.replay(new CrmCustomer(id));
			}
			addMessage(redirectAttributes, "批量还原客户成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "批量还原客户失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/delList?repage";
		}
	}
	
	/**
	 * 批量放入公海
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "batchToPool")
	public String batchToPool(String ids, RedirectAttributes redirectAttributes) {
		try{
			
			String idArray[] =ids.split(",");
			for(String id : idArray){
				
				//判断是否已经被放入公海
				CrmCustomer crmCustomer = crmCustomerService.get(id);//从数据库取出记录的值
				if("1".equals(crmCustomer.getIsPool())) {
					addMessage(redirectAttributes, "客户已经放入公海");
					return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
				}
				
				crmCustomerService.throwToPool(crmCustomer);
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_POOL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			}

			addMessage(redirectAttributes, "批量放入公海成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "批量放入公海失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list";
		}
	}
	
	/**
	 * 放入公海
	 * @param crmCustomer
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "toPool")
	public String toPool(CrmCustomer crmCustomer, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/list?repage";
		}
		
		try{
			
			//判断是否已经被放入公海
			CrmCustomer t = crmCustomerService.get(crmCustomer.getId());//从数据库取出记录的值
			if("1".equals(t.getIsPool())) {
				addMessage(redirectAttributes, "客户已经放入公海");
				return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
			}
			
			crmCustomerService.throwToPool(crmCustomer);
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_POOL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId());
			addMessage(redirectAttributes, "放入公海成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "放入公海失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmCustomer.getId();
		}
	}
	
	/**
	 * ajax验证客户名称是否已经存在
	 */
	@ResponseBody
	@RequestMapping(value = "validateCustomerName")
	public boolean validateCustomerName(HttpServletRequest request, String name, String id) {
		
		List<CrmCustomer> list = crmCustomerService.findListByCustomerName(UserUtils.getUser().getAccountId(), name, id);
		if (list == null || list.size() == 0) {
			return true;
		} else {
			return false;
		}
	}
}