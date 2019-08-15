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
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 跟进记录Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmContactRecord")
public class CrmContactRecordController extends BaseController {

	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmContactRecord get(@RequestParam(required=false) String id) {
		CrmContactRecord entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmContactRecordService.get(id);
		}
		if (entity == null){
			entity = new CrmContactRecord();
		}
		return entity;
	}
	
	/**
	 * 客户主页>联系记录
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "indexContactRecordList")
	public String indexContactRecordList(CrmContactRecord crmContactRecord, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CrmContactRecord> list = crmContactRecordService.findListByCustomer(crmContactRecord);
		model.addAttribute("list", list);
		return "modules/crm/indexContactRecordList";
	}
	
	/**
	 * 跟进记录列表页面
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmContactRecord crmContactRecord, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmContactRecord> page = crmContactRecordService.findPage(new Page<CrmContactRecord>(request, response), crmContactRecord); 
		model.addAttribute("page", page);
		return "modules/crm/crmContactRecordList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "view")
	public String view(CrmContactRecord crmContactRecord, Model model) {
		model.addAttribute("crmContactRecord", crmContactRecord);
		return "modules/crm/crmContactRecordView";
	}
	
	/**
	 * 查看，增加，编辑跟进记录表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmContactRecord crmContactRecord, Model model) {
		
		if(crmContactRecord.getIsNewRecord()){
			crmContactRecord.setContactDate(new Date());
		}
		
		//查询客户信息
		if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())){
			CrmCustomer crmCustomer = crmCustomerService.get(crmContactRecord.getTargetId());
			if(crmCustomer != null){
				crmContactRecord.setTargetName(crmCustomer.getName());
			}
		}
		
		model.addAttribute("crmContactRecord", crmContactRecord);
		return "modules/crm/crmContactRecordForm";
	}

	/**
	 * 保存跟进记录
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmContactRecord crmContactRecord, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmContactRecord)){
			return form(crmContactRecord, model);
		}
		
		try{
			
			String content = crmContactRecord.getContent();
			if(content.length()>50){
				content = content.substring(0,45)+"...";
			}
			if(crmContactRecord.getContactDate() == null)
				crmContactRecord.setContactDate(new Date());
			
			if(!crmContactRecord.getIsNewRecord()){//编辑表单保存
				CrmContactRecord t = crmContactRecordService.get(crmContactRecord.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmContactRecord, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmContactRecordService.save(t);//保存
				
				if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())) {
					DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_UPDATE, crmContactRecord.getId(), content, crmContactRecord.getTargetId());
				}else {
					DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_UPDATE, crmContactRecord.getId(), content, null);
				}
			}else{//新增表单保存
				crmContactRecordService.save(crmContactRecord);//保存
				
				if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())) {
					DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_ADD, crmContactRecord.getId(), content, crmContactRecord.getTargetId());
				}else {
					DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_ADD, crmContactRecord.getId(), content, null);
				}
			}
			
			addMessage(redirectAttributes, "保存跟进记录成功");
			
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存跟进记录失败");
		}finally{
			
			//线索
			if(Contants.OBJECT_CRM_TYPE_CLUE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmClue/index?id="+crmContactRecord.getTargetId();
			}
			//客户
			if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmContactRecord.getTargetId();
			}
			//联系人
			if(Contants.OBJECT_CRM_TYPE_CONTACTER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/index?id="+crmContactRecord.getTargetId();
			}
			//商机
			if(Contants.OBJECT_CRM_TYPE_CHANCE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmChance/index?id="+crmContactRecord.getTargetId();
			}
			//合同
			if(Contants.OBJECT_CRM_TYPE_CONTRACT.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/om/omContract/index?id="+crmContactRecord.getTargetId();
			}
			//应收款
			if(Contants.OBJECT_FI_TYPE_RECEIVABLE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/index?id="+crmContactRecord.getTargetId();
			}
			//工单
			if(Contants.OBJECT_CRM_TYPE_ORDERWORK.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmService/index?id="+crmContactRecord.getTargetId();
			}
			
			return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/list";
		}
	}
	
	/**
	 * 删除跟进记录
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmContactRecord crmContactRecord, RedirectAttributes redirectAttributes) {
		crmContactRecordService.delete(crmContactRecord);
		addMessage(redirectAttributes, "删除跟进记录成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/?repage";
	}
	
	/**
	 * 批量删除跟进记录
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmContactRecordService.delete(crmContactRecordService.get(id));
		}
		addMessage(redirectAttributes, "删除跟进记录成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmCustomer:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmContactRecord crmContactRecord, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "跟进记录"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmContactRecord> page = crmContactRecordService.findPage(new Page<CrmContactRecord>(request, response, -1), crmContactRecord);
    		new ExportExcel("跟进记录", CrmContactRecord.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出跟进记录记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/?repage";
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
			List<CrmContactRecord> list = ei.getDataList(CrmContactRecord.class);
			for (CrmContactRecord crmContactRecord : list){
				try{
					crmContactRecordService.save(crmContactRecord);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条跟进记录记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条跟进记录记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入跟进记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/?repage";
    }
	
	/**
	 * 下载导入跟进记录数据模板
	 */
	@RequiresPermissions("crm:crmCustomer:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "跟进记录数据导入模板.xlsx";
    		List<CrmContactRecord> list = Lists.newArrayList(); 
    		new ExportExcel("跟进记录数据", CrmContactRecord.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/?repage";
    }
	
	/**
	 * 下次联系提醒设置
	 * @param crmContactRecord
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "nextContactForm")
	public String nextContactForm(String id, Model model) {

		CrmContactRecord crmContactRecord = new CrmContactRecord();
		
		//查询客户信息
		if(id != null){
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			if(crmCustomer != null){
				crmContactRecord.setTargetId(id);
				crmContactRecord.setTargetName(crmCustomer.getName());
			}
		}
		
		model.addAttribute("crmContactRecord", crmContactRecord);
		return "modules/crm/crmNextContactForm";
	}
	
	/**
	 * 下次联系提醒保存
	 * @param crmContactRecord
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "nextContactSave")
	public String nextContactSave(CrmContactRecord crmContactRecord, Model model, RedirectAttributes redirectAttributes) {
		
		if (!beanValidator(model, crmContactRecord)){
			return form(crmContactRecord, model);
		}
		
		try{
			
			CrmCustomer crmCustomer = crmCustomerService.get(crmContactRecord.getTargetId());
			if(crmCustomer != null) {
				
				crmCustomer.setNextcontactDate(crmContactRecord.getContactDate());
				
				if(StringUtils.isNotBlank(crmContactRecord.getContent())){
					
					if(crmContactRecord.getContent().length() > 50)
						crmCustomer.setNextcontactNote(crmContactRecord.getContent().substring(0, 50));
					else
						crmCustomer.setNextcontactNote(crmContactRecord.getContent());
				}
				
				crmCustomerService.save(crmCustomer);
			}
			
			
			addMessage(redirectAttributes, "联系提醒设置成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "联系提醒设置失败");
		}finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmContactRecord.getTargetId();
		}
	}
	
	/**
	 * 删除跟进记录
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(CrmContactRecord crmContactRecord, RedirectAttributes redirectAttributes) {
	
		try{
			
			crmContactRecordService.delete(crmContactRecord);
			addMessage(redirectAttributes, "删除跟进记录成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "联系提醒设置失败");
		}finally {

			//线索
			if(Contants.OBJECT_CRM_TYPE_CLUE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmClue/index?id="+crmContactRecord.getTargetId();
			}
			//客户
			if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmContactRecord.getTargetId();
			}
			//联系人
			if(Contants.OBJECT_CRM_TYPE_CONTACTER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/index?id="+crmContactRecord.getTargetId();
			}
			//商机
			if(Contants.OBJECT_CRM_TYPE_CHANCE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmChance/index?id="+crmContactRecord.getTargetId();
			}
			//合同
			if(Contants.OBJECT_CRM_TYPE_CONTRACT.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/om/omContract/index?id="+crmContactRecord.getTargetId();
			}
			//应收款
			if(Contants.OBJECT_FI_TYPE_RECEIVABLE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/index?id="+crmContactRecord.getTargetId();
			}
			//工单
			if(Contants.OBJECT_CRM_TYPE_ORDERWORK.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/crm/crmService/index?id="+crmContactRecord.getTargetId();
			}
			
			return "redirect:"+Global.getAdminPath()+"/crm/crmContactRecord/list";
		}
	}
}