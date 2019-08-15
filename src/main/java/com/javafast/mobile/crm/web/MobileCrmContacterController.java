package com.javafast.mobile.crm.web;

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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 联系人Controller（手机端）
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmContacter")
public class MobileCrmContacterController extends BaseController {

	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public CrmContacter get(@RequestParam(required=false) String id) {
		CrmContacter entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmContacterService.get(id);
		}
		if (entity == null){
			entity = new CrmContacter();
		}
		return entity;
	}
	
	/**
	 * 联系人列表页面
	 * @param crmContacter
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmContacter:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmContacterList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmContacter
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmContacter> page = crmContacterService.findPage(new Page<CrmContacter>(request, response), crmContacter); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmContacter
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmContacter crmContacter, Model model) {		
		model.addAttribute("crmContacter", crmContacter);
		return "modules/crm/crmContacterSearch";
	}
	
	/**
	 * 联系人详情页面
	 * @param crmContacter
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmContacter:view")
	@RequestMapping(value = "view")
	public String view(CrmContacter crmContacter, Model model) {
		model.addAttribute("crmContacter", crmContacter);
		return "modules/crm/crmContacterView";
	}
	
	/**
	 * 联系人主页
	 * @param crmContacter
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmContacter:view")
	@RequestMapping(value = "index")
	public String index(CrmContacter crmContacter, Model model) {
		model.addAttribute("crmContacter", crmContacter);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, crmContacter.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(crmContacter.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
		
		return "modules/crm/crmContacterIndex";
	}
	
	/**
	 * 增加，编辑联系人表单页面
	 */
	@RequiresPermissions(value={"crm:crmContacter:view","crm:crmContacter:add","crm:crmContacter:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmContacter crmContacter, Model model) {
		
		if(crmContacter.getIsNewRecord()){
			if(crmContacter.getCustomer() != null && crmContacter.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(crmContacter.getCustomer().getId());
				crmContacter.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmContacter", crmContacter);
		return "modules/crm/crmContacterForm";
	}
	
	/**
	 * 保存联系人
	 */
	@RequiresPermissions(value={"crm:crmContacter:add","crm:crmContacter:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmContacter crmContacter, Model model, RedirectAttributes redirectAttributes){
		if (!beanValidator(model, crmContacter)){
			return form(crmContacter, model);
		}
		
		try{
			
			if(!crmContacter.getIsNewRecord()){//编辑表单保存
				
				CrmContacter t = crmContacterService.get(crmContacter.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmContacter, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmContacterService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			}else{//新增表单保存
				crmContacterService.save(crmContacter);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, Contants.ACTION_TYPE_ADD, crmContacter.getId(), crmContacter.getName(), crmContacter.getCustomer().getId());
			}
			
			addMessage(redirectAttributes, "保存联系人成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmCustomer/index?repage&id="+crmContacter.getCustomer().getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存联系人失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContacter/?repage";
		}
	}
	
	/**
	 * 删除联系人
	 */
	@RequiresPermissions("crm:crmContacter:del")
	@RequestMapping(value = "delete")
	public String delete(CrmContacter crmContacter, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContacter/?repage";
		}
		crmContacterService.delete(crmContacter);
		addMessage(redirectAttributes, "删除联系人成功");
		return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmContacter/?repage";
	}
}
