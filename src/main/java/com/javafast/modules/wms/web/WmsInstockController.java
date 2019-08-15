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

import com.javafast.modules.crm.entity.CrmContacter;
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
import com.javafast.modules.wms.entity.WmsInstock;
import com.javafast.modules.wms.service.WmsInstockService;

/**
 * 入库单Controller
 * @author javafast
 * @version 2017-07-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsInstock")
public class WmsInstockController extends BaseController {

	@Autowired
	private WmsInstockService wmsInstockService;
	
	@ModelAttribute
	public WmsInstock get(@RequestParam(required=false) String id) {
		WmsInstock entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsInstockService.get(id);
		}
		if (entity == null){
			entity = new WmsInstock();
		}
		return entity;
	}
	
	/**
	 * 入库单列表页面
	 */
	@RequiresPermissions("wms:wmsInstock:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsInstock wmsInstock, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsInstock> page = wmsInstockService.findPage(new Page<WmsInstock>(request, response), wmsInstock); 
		model.addAttribute("page", page);
		return "modules/wms/wmsInstockList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsInstock:view")
	@RequestMapping(value = "view")
	public String view(WmsInstock wmsInstock, Model model) {
		model.addAttribute("wmsInstock", wmsInstock);
		return "modules/wms/wmsInstockView";
	}
	
	/**
	 * 打印
	 * @param wmsInstock
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="wms:wmsInstock:view")
	@RequestMapping(value = "print")
	public String print(WmsInstock wmsInstock, Model model) {
		model.addAttribute("wmsInstock", wmsInstock);
		return "modules/wms/wmsInstockPrint";
	}
	
	/**
	 * 查看，增加，编辑入库单表单页面
	 */
	@RequiresPermissions(value={"wms:wmsInstock:view","wms:wmsInstock:add","wms:wmsInstock:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsInstock wmsInstock, Model model) {
		
		if(wmsInstock.getIsNewRecord()){
			wmsInstock.setNo("RK"+IdUtils.getId());
		}
		if(wmsInstock.getDealBy() == null){
			wmsInstock.setDealBy(UserUtils.getUser());
		}
		if(wmsInstock.getDealDate() == null){
			wmsInstock.setDealDate(new Date());
		}
		
		model.addAttribute("wmsInstock", wmsInstock);
		return "modules/wms/wmsInstockForm";
	}

	/**
	 * 保存入库单
	 */
	@RequiresPermissions(value={"wms:wmsInstock:add","wms:wmsInstock:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsInstock wmsInstock, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsInstock)){
			return form(wmsInstock, model);
		}
		
		try{
		
			if(!wmsInstock.getIsNewRecord()){//编辑表单保存				
				WmsInstock t = wmsInstockService.get(wmsInstock.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsInstock, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsInstockService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_STOKBILL_IN, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{//新增表单保存
				wmsInstockService.save(wmsInstock);//保存
			}
			addMessage(redirectAttributes, "保存入库单成功");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存入库单失败");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
		}
	}
	
	/**
	 * 删除入库单
	 */
	@RequiresPermissions("wms:wmsInstock:del")
	@RequestMapping(value = "delete")
	public String delete(WmsInstock wmsInstock, RedirectAttributes redirectAttributes) {
		wmsInstockService.delete(wmsInstock);
		addMessage(redirectAttributes, "删除入库单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
	}
	
	/**
	 * 批量删除入库单
	 */
	@RequiresPermissions("wms:wmsInstock:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsInstockService.delete(wmsInstockService.get(id));
		}
		addMessage(redirectAttributes, "删除入库单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsInstock:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsInstock wmsInstock, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "入库单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsInstock> page = wmsInstockService.findPage(new Page<WmsInstock>(request, response, -1), wmsInstock);
    		new ExportExcel("入库单", WmsInstock.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出入库单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsInstock:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsInstock> list = ei.getDataList(WmsInstock.class);
			for (WmsInstock wmsInstock : list){
				try{
					wmsInstockService.save(wmsInstock);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条入库单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条入库单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入入库单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
    }
	
	/**
	 * 下载导入入库单数据模板
	 */
	@RequiresPermissions("wms:wmsInstock:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "入库单数据导入模板.xlsx";
    		List<WmsInstock> list = Lists.newArrayList(); 
    		new ExportExcel("入库单数据", WmsInstock.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
    }
	
	/**
	 * 列表选择器
	 * @param wmsInstock
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(WmsInstock wmsInstock, HttpServletRequest request, HttpServletResponse response, Model model) {
		
        list(wmsInstock, request, response, model);
        return "modules/wms/wmsInstockSelectList";
	}

	
	/**
	 * 审核入库单
	 * @param wmsInstock
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("wms:wmsInstock:audit")
	@RequestMapping(value = "audit")
	public String audit(WmsInstock wmsInstock, RedirectAttributes redirectAttributes) {
		try {
			
			wmsInstockService.audit(wmsInstock);
			addMessage(redirectAttributes, "审核入库单成功");
			DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_STOKBILL_IN, Contants.ACTION_TYPE_AUDIT, wmsInstock.getId(), wmsInstock.getNo(), null);
		} catch (Exception e) {
			addMessage(redirectAttributes, "审核入库单失败！");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsInstock/?repage";
		}
	}

}