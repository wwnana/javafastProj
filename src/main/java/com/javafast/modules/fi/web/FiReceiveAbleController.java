/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.web;

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

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.service.OmOrderService;

/**
 * 应收款Controller
 * @author javafast
 * @version 2017-07-14
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiReceiveAble")
public class FiReceiveAbleController extends BaseController {

	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private OmOrderService omOrderService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@ModelAttribute
	public FiReceiveAble get(@RequestParam(required=false) String id) {
		FiReceiveAble entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiReceiveAbleService.get(id);
		}
		if (entity == null){
			entity = new FiReceiveAble();
		}
		return entity;
	}
	
	/**
	 * 客户主页>应收款
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = "indexReceiveAbleList")
	public String indexReceiveAbleList(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<FiReceiveAble> list = fiReceiveAbleService.findListByCustomer(fiReceiveAble);
		model.addAttribute("list", list);
		return "modules/fi/indexReceiveAbleList";
	}
	
	/**
	 * 应收款列表页面
	 */
	@RequiresPermissions("fi:fiReceiveAble:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiReceiveAble> page = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response), fiReceiveAble); 
		model.addAttribute("page", page);
		return "modules/fi/fiReceiveAbleList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="fi:fiReceiveAble:view")
	@RequestMapping(value = "view")
	public String view(FiReceiveAble fiReceiveAble, Model model) {
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		return "modules/fi/fiReceiveAbleView";
	}
	
	/**
	 * 查看，增加，编辑应收款表单页面
	 */
	@RequiresPermissions(value={"fi:fiReceiveAble:view","fi:fiReceiveAble:add","fi:fiReceiveAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiReceiveAble fiReceiveAble, Model model) {
		
		if(fiReceiveAble.getIsNewRecord()){
			fiReceiveAble.setNo("YS"+IdUtils.getId());
			
			if(fiReceiveAble.getCustomer()!=null && fiReceiveAble.getCustomer().getId()!=null){
				fiReceiveAble.setCustomer(crmCustomerService.get(fiReceiveAble.getCustomer().getId()));
			}
		}
		
		if(fiReceiveAble.getOwnBy() == null){
			fiReceiveAble.setOwnBy(UserUtils.getUser());
		}
		if(fiReceiveAble.getStatus() == null){
			fiReceiveAble.setStatus("0");
		}
		
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		return "modules/fi/fiReceiveAbleForm";
	}
	
	/**
	 * 编辑应收款表单页面
	 */
	@RequiresPermissions(value={"fi:fiReceiveAble:view","fi:fiReceiveAble:add","fi:fiReceiveAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "editForm")
	public String editForm(FiReceiveAble fiReceiveAble, Model model) {
		
		if(fiReceiveAble.getIsNewRecord()){
			fiReceiveAble.setNo("YS"+IdUtils.getId());
		}
		if(fiReceiveAble.getOwnBy() == null){
			fiReceiveAble.setOwnBy(UserUtils.getUser());
		}
		if(fiReceiveAble.getStatus() == null){
			fiReceiveAble.setStatus("0");
		}
		
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		return "modules/fi/fiReceiveAbleEditForm";
	}

	/**
	 * 保存应收款
	 */
	@RequiresPermissions(value={"fi:fiReceiveAble:add","fi:fiReceiveAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiReceiveAble fiReceiveAble, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiReceiveAble)){
			return form(fiReceiveAble, model);
		}
		
		try{
		
			if(!fiReceiveAble.getIsNewRecord()){//编辑表单保存				
				FiReceiveAble t = fiReceiveAbleService.get(fiReceiveAble.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiReceiveAble, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiReceiveAbleService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				
				OmOrder omOrder = omOrderService.get(fiReceiveAble.getOrder());
				if(omOrder != null)
					fiReceiveAble.setCustomer(omOrder.getCustomer());
				fiReceiveAble.setStatus("0");
				fiReceiveAbleService.save(fiReceiveAble);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_ADD, fiReceiveAble.getId(), fiReceiveAble.getNo(), fiReceiveAble.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存应收款成功");
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/index?id="+fiReceiveAble.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存应收款失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
		}
	}
	
	/**
	 * 删除应收款
	 */
	@RequiresPermissions("fi:fiReceiveAble:del")
	@RequestMapping(value = "delete")
	public String delete(FiReceiveAble fiReceiveAble, RedirectAttributes redirectAttributes) {
		fiReceiveAbleService.delete(fiReceiveAble);
		addMessage(redirectAttributes, "删除应收款成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
	}
	
	/**
	 * 批量删除应收款
	 */
	@RequiresPermissions("fi:fiReceiveAble:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiReceiveAbleService.delete(fiReceiveAbleService.get(id));
		}
		addMessage(redirectAttributes, "删除应收款成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiReceiveAble:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "应收款"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiReceiveAble> page = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response, -1), fiReceiveAble);
    		new ExportExcel("应收款", FiReceiveAble.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出应收款记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiReceiveAble:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiReceiveAble> list = ei.getDataList(FiReceiveAble.class);
			for (FiReceiveAble fiReceiveAble : list){
				try{
					fiReceiveAbleService.save(fiReceiveAble);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条应收款记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条应收款记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入应收款失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
    }
	
	/**
	 * 下载导入应收款数据模板
	 */
	@RequiresPermissions("fi:fiReceiveAble:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "应收款数据导入模板.xlsx";
    		List<FiReceiveAble> list = Lists.newArrayList(); 
    		new ExportExcel("应收款数据", FiReceiveAble.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiReceiveAble/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(fiReceiveAble, request, response, model);
        return "modules/fi/fiReceiveAbleSelectList";
	}
	
	/**
	 * 主页
	 */
	@RequiresPermissions(value="fi:fiReceiveAble:view")
	@RequestMapping(value = "index")
	public String index(FiReceiveAble fiReceiveAble, Model model) {
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, fiReceiveAble.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		//查询跟进记录
		CrmContactRecord conCrmContactRecord = new CrmContactRecord();
		conCrmContactRecord.setTargetId(fiReceiveAble.getId());
		List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
		model.addAttribute("crmContactRecordList", crmContactRecordList);
				
		//新增跟进记录
		CrmContactRecord contactRecord = new CrmContactRecord();
		contactRecord.setTargetType(Contants.OBJECT_FI_TYPE_RECEIVABLE);
		contactRecord.setTargetId(fiReceiveAble.getId());
		contactRecord.setTargetName(fiReceiveAble.getNo());
		contactRecord.setContactDate(new Date());
		model.addAttribute("crmContactRecord", contactRecord);
		
		return "modules/fi/fiReceiveAbleIndex";
	}
}