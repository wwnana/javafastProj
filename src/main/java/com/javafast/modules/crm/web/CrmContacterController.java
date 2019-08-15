package com.javafast.modules.crm.web;

import java.util.Date;
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
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
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
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 联系人Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmContacter")
public class CrmContacterController extends BaseController {

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
	 * 客户主页>联系人
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "indexContacterList")
	public String indexContacterList(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CrmContacter> list = crmContacterService.findListByCustomer(crmContacter); 
		model.addAttribute("list", list);
		return "modules/crm/indexContacterList";
	}
	
	@RequiresPermissions("crm:crmContacter:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmContacter> page = crmContacterService.findPage(new Page<CrmContacter>(request, response), crmContacter); 
		model.addAttribute("page", page);
		return "modules/crm/crmContacterList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="crm:crmContacter:view")
	@RequestMapping(value = "view")
	public String view(CrmContacter crmContacter, Model model) {
		model.addAttribute("crmContacter", crmContacter);
		return "modules/crm/crmContacterView";
	}
	
	/**
	 * 主页
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
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CONTACTER);
		contactRecord.setTargetId(crmContacter.getId());
		contactRecord.setTargetName(crmContacter.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
		
		return "modules/crm/crmContacterIndex";
	}
	
	/**
	 * 查看，增加，编辑联系人表单页面
	 */
	@RequiresPermissions(value={"crm:crmContacter:view","crm:crmContacter:add","crm:crmContacter:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmContacter crmContacter, Model model) {
		
		if(crmContacter.getIsNewRecord()){
			crmContacter.setOwnBy(UserUtils.getUser());
			if(crmContacter.getCustomer() != null && StringUtils.isNotBlank(crmContacter.getCustomer().getId())){
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
			return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/index?id="+crmContacter.getCustomer().getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存联系人失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/list";
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
			return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
		}
		crmContacterService.delete(crmContacter);
		addMessage(redirectAttributes, "删除联系人成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
	}
	
	/**
	 * 批量删除联系人
	 */
	@RequiresPermissions("crm:crmContacter:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmContacterService.delete(crmContacterService.get(id));
		}
		addMessage(redirectAttributes, "删除联系人成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmContacter:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "联系人"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmContacter> page = crmContacterService.findPage(new Page<CrmContacter>(request, response, -1), crmContacter);
    		new ExportExcel("联系人", CrmContacter.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出联系人记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmContacter:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmContacter> list = ei.getDataList(CrmContacter.class);
			for (CrmContacter crmContacter : list){
				try{
					crmContacterService.save(crmContacter);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条联系人记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条联系人记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入联系人失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
    }
	
	/**
	 * 下载导入联系人数据模板
	 */
	@RequiresPermissions("crm:crmContacter:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "联系人数据导入模板.xlsx";
    		List<CrmContacter> list = Lists.newArrayList(); 
    		new ExportExcel("联系人数据", CrmContacter.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
    }
	
	
	/**
	 * 列表选择器
	 * @param crmContacter
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmContacter crmContacter, HttpServletRequest request, HttpServletResponse response, Model model) {
		
        list(crmContacter, request, response, model);
        return "modules/crm/crmContacterSelectList";
	}

	/**
	 * 删除联系人
	 */
	@RequiresPermissions("crm:crmContacter:del")
	@RequestMapping(value = "indexDelete")
	public String indexDelete(CrmContacter crmContacter, RedirectAttributes redirectAttributes) {
		crmContacterService.delete(crmContacter);
		addMessage(redirectAttributes, "删除联系人成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmContacter.getCustomer().getId();
	}
	
	/**
	 * 设为首要
	 * @param crmContacter
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmContacter:add","crm:crmContacter:edit"},logical=Logical.OR)
	@RequestMapping(value = "setDefault")
	public String setDefault(CrmContacter crmContacter, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmContacter/?repage";
		}
		try {
			crmContacterService.setDefault(crmContacter);
			addMessage(redirectAttributes, "联系人'"+crmContacter.getName()+"'已经设为首要联系人");
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "联系人设为首要失败！");
		} finally {
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomer/index?id="+crmContacter.getCustomer().getId();
		}
	}
	
	/**
	 * 获取下拉菜单数据
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getSelectData")
	public String getSelectData(String customerId){
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setCustomer(new CrmCustomer(customerId));
		List<CrmContacter> list = crmContacterService.findList(crmContacter);		
		String json = JsonMapper.getInstance().toJson(list);
		return json;
	}
}