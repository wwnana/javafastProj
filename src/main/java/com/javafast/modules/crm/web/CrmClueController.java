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
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.SysDynamic;
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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmContactRecordService;

/**
 * 销售线索Controller
 * @author javafast
 * @version 2019-02-15
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmClue")
public class CrmClueController extends BaseController {

	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@ModelAttribute
	public CrmClue get(@RequestParam(required=false) String id) {
		CrmClue entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmClueService.get(id);
		}
		if (entity == null){
			entity = new CrmClue();
		}
		return entity;
	}
	
	/**
	 * 销售线索列表页面
	 */
	@RequiresPermissions("crm:crmClue:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmClue crmClue, HttpServletRequest request, HttpServletResponse response, Model model) {
		if(StringUtils.isBlank(crmClue.getIsChange())) {
			crmClue.setIsChange("0");//默认查询未转化的
		}
		Page<CrmClue> page = crmClueService.findPage(new Page<CrmClue>(request, response), crmClue); 
		model.addAttribute("page", page);
		return "modules/crm/crmClueList";
	}

	/**
	 * 编辑销售线索表单页面
	 */
	@RequiresPermissions(value={"crm:crmClue:view","crm:crmClue:add","crm:crmClue:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmClue crmClue, Model model) {
		if(crmClue.getIsNewRecord()){
			crmClue.setOwnBy(UserUtils.getUser());
		}
		model.addAttribute("crmClue", crmClue);
		return "modules/crm/crmClueForm";
	}
	
	/**
	 * 转为客户
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"crm:crmClue:view","crm:crmClue:add","crm:crmClue:edit"},logical=Logical.OR)
	@RequestMapping(value = "toCustomerform")
	public String toCustomerform(CrmClue crmClue, Model model) {
		
		CrmCustomer crmCustomer = new CrmCustomer();
		crmCustomer.setCrmClueId(crmClue.getId());
		
		crmCustomer.setOwnBy(UserUtils.getUser());
		crmCustomer.setName(crmClue.getName());
		crmCustomer.setSourType(crmClue.getSourType());
		crmCustomer.setIndustryType(crmClue.getIndustryType());
		crmCustomer.setNatureType(crmClue.getNatureType());
		crmCustomer.setScaleType(crmClue.getScaleType());
		crmCustomer.setProvince(crmClue.getProvince());
		crmCustomer.setCity(crmClue.getCity());
		crmCustomer.setDict(crmClue.getDict());
		crmCustomer.setAddress(crmClue.getAddress());
		crmCustomer.setNextcontactDate(crmClue.getNextcontactDate());
		crmCustomer.setNextcontactNote(crmClue.getNextcontactNote());
		crmCustomer.setRemarks(crmClue.getRemarks());
		
		CrmContacter crmContacter = new CrmContacter();
		crmContacter.setName(crmClue.getContacterName());
		crmContacter.setEmail(crmClue.getEmail());
		crmContacter.setSex(crmClue.getSex());
		crmContacter.setJobType(crmClue.getJobType());
		crmContacter.setMobile(crmClue.getMobile());
		
		crmCustomer.setCrmContacter(crmContacter);
		
		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerForm";
	}
	
	/**
	 * 查看销售线索页面
	 */
	@RequiresPermissions(value="crm:crmClue:view")
	@RequestMapping(value = "view")
	public String view(CrmClue crmClue, Model model) {
		model.addAttribute("crmClue", crmClue);
		return "modules/crm/crmClueView";
	}

	/**
	 * 保存销售线索
	 */
	@RequiresPermissions(value={"crm:crmClue:add","crm:crmClue:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmClue crmClue, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmClue)){
			return form(crmClue, model);
		}
		
		try{
		
			if(!crmClue.getIsNewRecord()){//编辑表单保存				
				CrmClue t = crmClueService.get(crmClue.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmClue, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmClueService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CLUE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				crmClueService.save(crmClue);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CLUE, Contants.ACTION_TYPE_ADD, crmClue.getId(), crmClue.getName(), null);
			}
			addMessage(redirectAttributes, "保存销售线索成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存销售线索失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmClue/index?id="+crmClue.getId();
		}
	}
	
	/**
	 * 删除销售线索
	 */
	@RequiresPermissions("crm:crmClue:del")
	@RequestMapping(value = "delete")
	public String delete(CrmClue crmClue, RedirectAttributes redirectAttributes) {
		crmClueService.delete(crmClue);
		addMessage(redirectAttributes, "删除销售线索成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmClue/?repage";
	}
	
	/**
	 * 批量删除销售线索
	 */
	@RequiresPermissions("crm:crmClue:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmClueService.delete(crmClueService.get(id));
		}
		addMessage(redirectAttributes, "删除销售线索成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmClue/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmClue:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmClue crmClue, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售线索"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmClue> page = crmClueService.findPage(new Page<CrmClue>(request, response, -1), crmClue);
    		new ExportExcel("销售线索", CrmClue.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出销售线索记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmClue/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("crm:crmClue:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CrmClue> list = ei.getDataList(CrmClue.class);
			for (CrmClue crmClue : list){
				try{
					crmClueService.save(crmClue);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条销售线索记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条销售线索记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入销售线索失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmClue/?repage";
    }
	
	/**
	 * 下载导入销售线索数据模板
	 */
	@RequiresPermissions("crm:crmClue:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售线索数据导入模板.xlsx";
    		List<CrmClue> list = Lists.newArrayList(); 
    		new ExportExcel("销售线索数据", CrmClue.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmClue/?repage";
    }
	
	/**
	 * 销售线索列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmClue crmClue, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmClue, request, response, model);
        return "modules/crm/crmClueSelectList";
	}
	
	/**
	 * 销售线索主页
	 * @param crmClue
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmClue:view")
	@RequestMapping(value = "index")
	public String index(CrmClue crmClue, Model model) {
		
		model.addAttribute("crmClue", crmClue);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_CLUE, crmClue.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		
		//查询联系提醒
		if(crmClue.getNextcontactDate() != null){			
			int diffDay = DateUtils.differentDaysByMillisecond(new Date(), crmClue.getNextcontactDate());
			System.out.println(diffDay);
			model.addAttribute("diffDay", diffDay);		
		}
		
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(crmClue.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CLUE);
		contactRecord.setTargetId(crmClue.getId());
		contactRecord.setTargetName(crmClue.getName());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
				
		return "modules/crm/crmClueIndex";
	}
}