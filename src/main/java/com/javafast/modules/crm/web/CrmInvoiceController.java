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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmInvoice;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmInvoiceService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 开票信息Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmInvoice")
public class CrmInvoiceController extends BaseController {

	@Autowired
	private CrmInvoiceService crmInvoiceService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmInvoice get(@RequestParam(required=false) String id) {
		CrmInvoice entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmInvoiceService.get(id);
		}
		if (entity == null){
			entity = new CrmInvoice();
		}
		return entity;
	}
	
	/**
	 * 开票信息列表页面
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmInvoice crmInvoice, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmInvoice> page = crmInvoiceService.findPage(new Page<CrmInvoice>(request, response), crmInvoice); 
		model.addAttribute("page", page);
		return "modules/crm/crmInvoiceList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="crm:crmCustomer:view")
	@RequestMapping(value = "view")
	public String view(CrmInvoice crmInvoice, Model model) {
		model.addAttribute("crmInvoice", crmInvoice);
		return "modules/crm/crmInvoiceView";
	}
	
	/**
	 * 查看，增加，编辑开票信息表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomer:view","crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmInvoice crmInvoice, Model model) {
		
		if(crmInvoice.getIsNewRecord()){
			if(crmInvoice.getCustomer() != null && StringUtils.isNotBlank(crmInvoice.getCustomer().getId())){
				CrmCustomer customer = crmCustomerService.get(crmInvoice.getCustomer().getId());
				crmInvoice.setCustomer(customer);
			}			
		}
		
		model.addAttribute("crmInvoice", crmInvoice);
		return "modules/crm/crmInvoiceForm";
	}

	/**
	 * 保存开票信息
	 */
	@RequiresPermissions(value={"crm:crmCustomer:add","crm:crmCustomer:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmInvoice crmInvoice, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmInvoice)){
			return form(crmInvoice, model);
		}
		
		try{
		
			if(!crmInvoice.getIsNewRecord()){//编辑表单保存				
				CrmInvoice t = crmInvoiceService.get(crmInvoice.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmInvoice, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmInvoiceService.save(t);//保存
			}else{//新增表单保存
				crmInvoiceService.save(crmInvoice);//保存
			}
			addMessage(redirectAttributes, "保存开票信息成功");
			return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/list?customer.id="+crmInvoice.getCustomer().getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存开票信息失败");
			return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/list?customer.id="+crmInvoice.getCustomer().getId();
		}
	}
	
	/**
	 * 删除开票信息
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "delete")
	public String delete(CrmInvoice crmInvoice, RedirectAttributes redirectAttributes) {
		crmInvoiceService.delete(crmInvoice);
		addMessage(redirectAttributes, "删除开票信息成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/list?customer.id="+crmInvoice.getCustomer().getId();
	}
	
	/**
	 * 批量删除开票信息
	 */
	@RequiresPermissions("crm:crmCustomer:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			crmInvoiceService.delete(crmInvoiceService.get(id));
		}
		addMessage(redirectAttributes, "删除开票信息成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("crm:crmCustomer:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(CrmInvoice crmInvoice, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "开票信息"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<CrmInvoice> page = crmInvoiceService.findPage(new Page<CrmInvoice>(request, response, -1), crmInvoice);
    		new ExportExcel("开票信息", CrmInvoice.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出开票信息记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/?repage";
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
			List<CrmInvoice> list = ei.getDataList(CrmInvoice.class);
			for (CrmInvoice crmInvoice : list){
				try{
					crmInvoiceService.save(crmInvoice);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条开票信息记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条开票信息记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入开票信息失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/?repage";
    }
	
	/**
	 * 下载导入开票信息数据模板
	 */
	@RequiresPermissions("crm:crmCustomer:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "开票信息数据导入模板.xlsx";
    		List<CrmInvoice> list = Lists.newArrayList(); 
    		new ExportExcel("开票信息数据", CrmInvoice.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/crm/crmInvoice/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(CrmInvoice crmInvoice, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(crmInvoice, request, response, model);
        return "modules/crm/crmInvoiceSelectList";
	}
	
	

}