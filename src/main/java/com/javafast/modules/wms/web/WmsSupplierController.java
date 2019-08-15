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
import java.util.Date;

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
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.modules.wms.service.WmsSupplierService;

/**
 * 供应商Controller
 * @author javafast
 * @version 2017-07-04
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsSupplier")
public class WmsSupplierController extends BaseController {

	@Autowired
	private WmsSupplierService wmsSupplierService;
	
	@ModelAttribute
	public WmsSupplier get(@RequestParam(required=false) String id) {
		WmsSupplier entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsSupplierService.get(id);
		}
		if (entity == null){
			entity = new WmsSupplier();
		}
		return entity;
	}
	
	/**
	 * 供应商管理
	 * @param wmsSupplier
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("wms:wmsSupplier:list")
	@RequestMapping(value = "index")
	public String index(WmsSupplier wmsSupplier, HttpServletRequest request, HttpServletResponse response, Model model) {

		return "modules/wms/wmsSupplierIndex";
	}
	
	/**
	 * 供应商列表页面
	 */
	@RequiresPermissions("wms:wmsSupplier:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsSupplier wmsSupplier, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsSupplier> page = wmsSupplierService.findPage(new Page<WmsSupplier>(request, response), wmsSupplier); 
		model.addAttribute("page", page);
		return "modules/wms/wmsSupplierList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsSupplier:view")
	@RequestMapping(value = "view")
	public String view(WmsSupplier wmsSupplier, Model model) {
		model.addAttribute("wmsSupplier", wmsSupplier);
		return "modules/wms/wmsSupplierView";
	}
	
	/**
	 * 查看，增加，编辑供应商表单页面
	 */
	@RequiresPermissions(value={"wms:wmsSupplier:view","wms:wmsSupplier:add","wms:wmsSupplier:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsSupplier wmsSupplier, Model model) {
		if(wmsSupplier.getIsNewRecord()){
			wmsSupplier.setNo("GY"+IdUtils.getId());
		}
		model.addAttribute("wmsSupplier", wmsSupplier);
		return "modules/wms/wmsSupplierForm";
	}

	/**
	 * 保存供应商
	 */
	@RequiresPermissions(value={"wms:wmsSupplier:add","wms:wmsSupplier:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsSupplier wmsSupplier, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsSupplier)){
			return form(wmsSupplier, model);
		}
		
		try{
			
			if(!wmsSupplier.getIsNewRecord()){//编辑表单保存
				WmsSupplier t = wmsSupplierService.get(wmsSupplier.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsSupplier, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsSupplierService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_SUPPLIER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				wmsSupplierService.save(wmsSupplier);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_SUPPLIER, Contants.ACTION_TYPE_ADD, wmsSupplier.getId(), wmsSupplier.getName(), null);
			}
			addMessage(redirectAttributes, "保存供应商成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存供应商失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
		}
		
		
	}
	
	/**
	 * 删除供应商
	 */
	@RequiresPermissions("wms:wmsSupplier:del")
	@RequestMapping(value = "delete")
	public String delete(WmsSupplier wmsSupplier, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
		}
		wmsSupplierService.delete(wmsSupplier);
		addMessage(redirectAttributes, "删除供应商成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
	}
	
	/**
	 * 批量删除供应商
	 */
	@RequiresPermissions("wms:wmsSupplier:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsSupplierService.delete(wmsSupplierService.get(id));
		}
		addMessage(redirectAttributes, "删除供应商成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsSupplier:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsSupplier wmsSupplier, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "供应商"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsSupplier> page = wmsSupplierService.findPage(new Page<WmsSupplier>(request, response, -1), wmsSupplier);
    		new ExportExcel("供应商", WmsSupplier.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出供应商记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsSupplier:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsSupplier> list = ei.getDataList(WmsSupplier.class);
			for (WmsSupplier wmsSupplier : list){
				try{
					wmsSupplierService.save(wmsSupplier);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条供应商记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条供应商记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入供应商失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
    }
	
	/**
	 * 下载导入供应商数据模板
	 */
	@RequiresPermissions("wms:wmsSupplier:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "供应商数据导入模板.xlsx";
    		List<WmsSupplier> list = Lists.newArrayList(); 
    		new ExportExcel("供应商数据", WmsSupplier.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplier/?repage";
    }
	
	/**
	 * 列表选择器
	 * @param wmsSupplier
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(WmsSupplier wmsSupplier, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsSupplier.setStatus("0");
        list(wmsSupplier, request, response, model);
        return "modules/wms/wmsSupplierSelectList";
	}

}