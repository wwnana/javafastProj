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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;

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
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.wms.entity.WmsSupplier;
import com.javafast.modules.wms.entity.WmsWarehouse;
import com.javafast.modules.wms.service.WmsWarehouseService;

/**
 * 仓库Controller
 * @author javafast
 * @version 2017-07-04
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsWarehouse")
public class WmsWarehouseController extends BaseController {

	@Autowired
	private WmsWarehouseService wmsWarehouseService;
	
	@ModelAttribute
	public WmsWarehouse get(@RequestParam(required=false) String id) {
		WmsWarehouse entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsWarehouseService.get(id);
		}
		if (entity == null){
			entity = new WmsWarehouse();
		}
		return entity;
	}
	
	/**
	 * 仓库列表页面
	 */
	@RequiresPermissions("wms:wmsWarehouse:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsWarehouse wmsWarehouse, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsWarehouse> page = wmsWarehouseService.findPage(new Page<WmsWarehouse>(request, response), wmsWarehouse); 
		model.addAttribute("page", page);
		return "modules/wms/wmsWarehouseList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsWarehouse:view")
	@RequestMapping(value = "view")
	public String view(WmsWarehouse wmsWarehouse, Model model) {
		model.addAttribute("wmsWarehouse", wmsWarehouse);
		return "modules/wms/wmsWarehouseView";
	}
	
	/**
	 * 查看，增加，编辑仓库表单页面
	 */
	@RequiresPermissions(value={"wms:wmsWarehouse:view","wms:wmsWarehouse:add","wms:wmsWarehouse:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsWarehouse wmsWarehouse, Model model) {
		
		if(wmsWarehouse.getIsNewRecord()){
			wmsWarehouse.setIsDefault("0");
			wmsWarehouse.setStatus("0");
		}
		model.addAttribute("wmsWarehouse", wmsWarehouse);
		return "modules/wms/wmsWarehouseForm";
	}

	/**
	 * 保存仓库
	 */
	@RequiresPermissions(value={"wms:wmsWarehouse:add","wms:wmsWarehouse:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsWarehouse wmsWarehouse, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsWarehouse)){
			return form(wmsWarehouse, model);
		}
		
		try{
			
			if(!wmsWarehouse.getIsNewRecord()){//编辑表单保存
				WmsWarehouse t = wmsWarehouseService.get(wmsWarehouse.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsWarehouse, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsWarehouseService.save(t);//保存
			}else{//新增表单保存
				wmsWarehouseService.save(wmsWarehouse);//保存
			}
			addMessage(redirectAttributes, "保存仓库成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存仓库失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
		}
	}
	
	/**
	 * 删除仓库
	 */
	@RequiresPermissions("wms:wmsWarehouse:del")
	@RequestMapping(value = "delete")
	public String delete(WmsWarehouse wmsWarehouse, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
		}
		wmsWarehouseService.delete(wmsWarehouse);
		addMessage(redirectAttributes, "删除仓库成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
	}
	
	/**
	 * 批量删除仓库
	 */
	@RequiresPermissions("wms:wmsWarehouse:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsWarehouseService.delete(wmsWarehouseService.get(id));
		}
		addMessage(redirectAttributes, "删除仓库成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsWarehouse:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsWarehouse wmsWarehouse, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "仓库"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsWarehouse> page = wmsWarehouseService.findPage(new Page<WmsWarehouse>(request, response, -1), wmsWarehouse);
    		new ExportExcel("仓库", WmsWarehouse.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出仓库记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsWarehouse:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsWarehouse> list = ei.getDataList(WmsWarehouse.class);
			for (WmsWarehouse wmsWarehouse : list){
				try{
					wmsWarehouseService.save(wmsWarehouse);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条仓库记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条仓库记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入仓库失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
    }
	
	/**
	 * 下载导入仓库数据模板
	 */
	@RequiresPermissions("wms:wmsWarehouse:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "仓库数据导入模板.xlsx";
    		List<WmsWarehouse> list = Lists.newArrayList(); 
    		new ExportExcel("仓库数据", WmsWarehouse.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsWarehouse/?repage";
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
	public String selectList(WmsWarehouse wmsWarehouse, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsWarehouse.setStatus("0");
        list(wmsWarehouse, request, response, model);
        return "modules/wms/wmsWarehouseSelectList";
	}
	
	/**
	 * 获取下拉菜单数据
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getSelectData")
	public String getSelectData(){
		List<WmsWarehouse> list = wmsWarehouseService.findList(new WmsWarehouse());
		String json = JsonMapper.getInstance().toJson(list);
		return json;
	}
}