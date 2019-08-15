/**
 * Copyright 2015-2020
 */
package com.javafast.modules.wms.web;

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

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

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
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsPurchase;
import com.javafast.modules.wms.service.WmsPurchaseService;

/**
 * 采购单Controller
 * @author javafast
 * @version 2017-07-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsPurchase")
public class WmsPurchaseController extends BaseController {

	@Autowired
	private WmsPurchaseService wmsPurchaseService;
	
	@ModelAttribute
	public WmsPurchase get(@RequestParam(required=false) String id) {
		WmsPurchase entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsPurchaseService.get(id);
		}
		if (entity == null){
			entity = new WmsPurchase();
		}
		return entity;
	}
	
	/**
	 * 采购单列表页面
	 */
	@RequiresPermissions("wms:wmsPurchase:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsPurchase wmsPurchase, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsPurchase> page = wmsPurchaseService.findPage(new Page<WmsPurchase>(request, response), wmsPurchase); 
		model.addAttribute("page", page);
		return "modules/wms/wmsPurchaseList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsPurchase:view")
	@RequestMapping(value = "view")
	public String view(WmsPurchase wmsPurchase, Model model) {
		model.addAttribute("wmsPurchase", wmsPurchase);
		return "modules/wms/wmsPurchaseView";
	}
	
	/**
	 * 打印
	 */
	@RequiresPermissions(value="wms:wmsPurchase:view")
	@RequestMapping(value = "print")
	public String print(WmsPurchase wmsPurchase, Model model) {
		model.addAttribute("wmsPurchase", wmsPurchase);
		return "modules/wms/wmsPurchasePrint";
	}
	
	/**
	 * 查看，增加，编辑采购单表单页面
	 */
	@RequiresPermissions(value={"wms:wmsPurchase:view","wms:wmsPurchase:add","wms:wmsPurchase:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsPurchase wmsPurchase, Model model) {
		
		if(wmsPurchase.getIsNewRecord()){
			wmsPurchase.setNo("JH"+IdUtils.getId());
			wmsPurchase.setStatus("0");
			wmsPurchase.setOtherAmt(BigDecimal.ZERO);
		}		
		if(wmsPurchase.getDealBy() == null){
			wmsPurchase.setDealBy(UserUtils.getUser());
		}
		if(wmsPurchase.getDealDate() == null){
			wmsPurchase.setDealDate(new Date());
		}
		
		model.addAttribute("wmsPurchase", wmsPurchase);
		return "modules/wms/wmsPurchaseForm";
	}

	/**
	 * 保存采购单
	 */
	@RequiresPermissions(value={"wms:wmsPurchase:add","wms:wmsPurchase:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsPurchase wmsPurchase, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsPurchase)){
			return form(wmsPurchase, model);
		}
		
		try{
		
			if(!wmsPurchase.getIsNewRecord()){//编辑表单保存				
				WmsPurchase t = wmsPurchaseService.get(wmsPurchase.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsPurchase, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsPurchaseService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PURCHASE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{//新增表单保存
				wmsPurchase.setStatus("0");
				wmsPurchaseService.save(wmsPurchase);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PURCHASE, Contants.ACTION_TYPE_ADD, wmsPurchase.getId(), wmsPurchase.getNo(), null);
			}
			addMessage(redirectAttributes, "保存采购单成功");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存采购单失败");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
		}
	}
	
	/**
	 * 删除采购单
	 */
	@RequiresPermissions("wms:wmsPurchase:del")
	@RequestMapping(value = "delete")
	public String delete(WmsPurchase wmsPurchase, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
		}
		wmsPurchaseService.delete(wmsPurchase);
		addMessage(redirectAttributes, "删除采购单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
	}
	
	/**
	 * 批量删除采购单
	 */
	@RequiresPermissions("wms:wmsPurchase:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsPurchaseService.delete(wmsPurchaseService.get(id));
		}
		addMessage(redirectAttributes, "删除采购单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsPurchase:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsPurchase wmsPurchase, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "采购单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsPurchase> page = wmsPurchaseService.findPage(new Page<WmsPurchase>(request, response, -1), wmsPurchase);
    		new ExportExcel("采购单", WmsPurchase.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出采购单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsPurchase:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsPurchase> list = ei.getDataList(WmsPurchase.class);
			for (WmsPurchase wmsPurchase : list){
				try{
					wmsPurchaseService.save(wmsPurchase);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条采购单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条采购单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入采购单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
    }
	
	/**
	 * 下载导入采购单数据模板
	 */
	@RequiresPermissions("wms:wmsPurchase:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "采购单数据导入模板.xlsx";
    		List<WmsPurchase> list = Lists.newArrayList(); 
    		new ExportExcel("采购单数据", WmsPurchase.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
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
	public String selectList(WmsPurchase wmsPurchase, HttpServletRequest request, HttpServletResponse response, Model model) {

        list(wmsPurchase, request, response, model);
        return "modules/wms/wmsPurchaseSelectList";
	}
	
	/**
	 * 审核
	 * @param wmsPurchase
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("wms:wmsPurchase:audit")
	@RequestMapping(value = "audit")
	public String audit(WmsPurchase wmsPurchase, RedirectAttributes redirectAttributes) {
		
		try {
			
			wmsPurchaseService.audit(wmsPurchase);
			DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PURCHASE, Contants.ACTION_TYPE_AUDIT, wmsPurchase.getId(), wmsPurchase.getNo(), null);
			addMessage(redirectAttributes, "审核采购单成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "审核采购单失败！");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsPurchase/?repage";
		}
	}
	
}