package com.javafast.mobile.crm.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 沟通Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmContactRecord")
public class MobileContactRecordController extends BaseController{

	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
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
	 * 列表页面
	 * @param crmContactRecord
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"list", ""})
	public String list(CrmContactRecord crmContactRecord, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmContactRecordList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmContactRecord
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmContactRecord crmContactRecord, HttpServletRequest request, HttpServletResponse response, Model model) {
		String createById = request.getParameter("createById");
		if(StringUtils.isNotBlank(createById))
			crmContactRecord.setCreateBy(new User(createById));
		Page<CrmContactRecord> page = crmContactRecordService.findPage(new Page<CrmContactRecord>(request, response), crmContactRecord); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	@RequestMapping(value = "search")
	public String search(CrmChance crmChance, Model model) {		
		model.addAttribute("crmChance", crmChance);
		return "modules/crm/crmContactRecordSearch";
	}
	
	/**
	 * 查看
	 */
	@RequestMapping(value = "view")
	public String view(CrmContactRecord crmContactRecord, Model model) {
		model.addAttribute("crmContactRecord", crmContactRecord);
		return "modules/crm/crmContactRecordView";
	}
	
	/**
	 * 查看，增加，编辑跟进记录表单页面
	 */
	@RequestMapping(value = "form")
	public String form(CrmContactRecord crmContactRecord, Model model) {
		
		if(crmContactRecord.getIsNewRecord()){
			crmContactRecord.setContactDate(new Date());
			crmContactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CUSTOMER);
		}
		
		model.addAttribute("crmContactRecord", crmContactRecord);
		return "modules/crm/crmContactRecordForm";
	}

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
			if(!crmContactRecord.getIsNewRecord()){//编辑表单保存
				CrmContactRecord t = crmContactRecordService.get(crmContactRecord.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmContactRecord, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmContactRecordService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_UPDATE, t.getId(), content, t.getTargetName());
			}else{//新增表单保存
				crmContactRecordService.save(crmContactRecord);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_ADD, crmContactRecord.getId(), content, crmContactRecord.getTargetName());
			}
			
			//更新下次联系时间和内容
			if(crmContactRecord.getNextcontactDate() != null){
				
				//如果是客户的话，更新客户更进时间
				if(crmContactRecord.getTargetType().equals(Contants.OBJECT_CRM_TYPE_CUSTOMER)) {
					
					//更新客户
					CrmCustomer crmCustomer = crmCustomerService.get(crmContactRecord.getTargetId());				
					if(crmCustomer != null) {
						
						crmCustomer.setNextcontactDate(crmContactRecord.getNextcontactDate());				
						if(crmContactRecord.getNextcontactNote().length() > 50)
							crmCustomer.setNextcontactNote(crmContactRecord.getNextcontactNote().substring(0, 50));
						else
							crmCustomer.setNextcontactNote(crmContactRecord.getNextcontactNote());
						
						crmCustomerService.save(crmCustomer);
					}
				}
			}
			
			addMessage(redirectAttributes, "保存跟进记录成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存跟进记录失败");
		}finally{
			
			//线索
			if(Contants.OBJECT_CRM_TYPE_CLUE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmClue/index?id="+crmContactRecord.getTargetId();
			}
			//客户
			if(Contants.OBJECT_CRM_TYPE_CUSTOMER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?id="+crmContactRecord.getTargetId();
			}
			//联系人
			if(Contants.OBJECT_CRM_TYPE_CONTACTER.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContacter/index?id="+crmContactRecord.getTargetId();
			}
			//商机
			if(Contants.OBJECT_CRM_TYPE_CHANCE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmChance/index?id="+crmContactRecord.getTargetId();
			}
			//合同
			if(Contants.OBJECT_CRM_TYPE_CONTRACT.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/om/omContract/index?id="+crmContactRecord.getTargetId();
			}
			//应收款
			if(Contants.OBJECT_FI_TYPE_RECEIVABLE.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveAble/index?id="+crmContactRecord.getTargetId();
			}
			//工单
			if(Contants.OBJECT_CRM_TYPE_ORDERWORK.equals(crmContactRecord.getTargetType())) {
				return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmService/index?id="+crmContactRecord.getTargetId();
			}
			
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContactRecord/list";
		}
	}
	
	@RequestMapping(value = "delete")
	public String delete(CrmContactRecord crmContactRecord, RedirectAttributes redirectAttributes) {
		crmContactRecordService.delete(crmContactRecord);
		addMessage(redirectAttributes, "删除跟进记录成功");
		return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContactRecord/?repage";
	}
}
