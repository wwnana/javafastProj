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


import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.wms.entity.WmsProductData;
import com.javafast.modules.wms.service.WmsProductDataService;

/**
 * 产品详情表Controller
 * @author javafast
 * @version 2017-10-24
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsProductData")
public class WmsProductDataController extends BaseController {

	@Autowired
	private WmsProductDataService wmsProductDataService;
	
	@ModelAttribute
	public WmsProductData get(@RequestParam(required=false) String id) {
		WmsProductData entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsProductDataService.get(id);
		}
		if (entity == null){
			entity = new WmsProductData();
		}
		return entity;
	}
	
	/**
	 * 产品详情表列表页面
	 */
	@RequiresPermissions("wms:wmsProduct:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsProductData wmsProductData, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsProductData> page = wmsProductDataService.findPage(new Page<WmsProductData>(request, response), wmsProductData); 
		model.addAttribute("page", page);
		return "modules/wms/wmsProductDataList";
	}

	/**
	 * 编辑产品详情表表单页面
	 */
	@RequiresPermissions(value={"wms:wmsProduct:view","wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsProductData wmsProductData, Model model) {
		model.addAttribute("wmsProductData", wmsProductData);
		return "modules/wms/wmsProductDataForm";
	}
	
	/**
	 * 查看产品详情表页面
	 */
	@RequiresPermissions(value="wms:wmsProduct:view")
	@RequestMapping(value = "view")
	public String view(WmsProductData wmsProductData, Model model) {
		model.addAttribute("wmsProductData", wmsProductData);
		return "modules/wms/wmsProductDataView";
	}

	/**
	 * 保存产品详情表
	 */
	@RequiresPermissions(value={"wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsProductData wmsProductData, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsProductData)){
			return form(wmsProductData, model);
		}
		
		try{
		
			if(!wmsProductData.getIsNewRecord()){//编辑表单保存				
				WmsProductData t = wmsProductDataService.get(wmsProductData.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsProductData, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsProductDataService.save(t);//保存
			}else{//新增表单保存
				wmsProductDataService.save(wmsProductData);//保存
			}
			addMessage(redirectAttributes, "保存产品详情表成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存产品详情表失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
		}
	}
	
	/**
	 * 删除产品详情表
	 */
	@RequiresPermissions("wms:wmsProduct:del")
	@RequestMapping(value = "delete")
	public String delete(WmsProductData wmsProductData, RedirectAttributes redirectAttributes) {
		wmsProductDataService.delete(wmsProductData);
		addMessage(redirectAttributes, "删除产品详情表成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
	}
	
	/**
	 * 批量删除产品详情表
	 */
	@RequiresPermissions("wms:wmsProduct:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsProductDataService.delete(wmsProductDataService.get(id));
		}
		addMessage(redirectAttributes, "删除产品详情表成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsProduct:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsProductData wmsProductData, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品详情表"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsProductData> page = wmsProductDataService.findPage(new Page<WmsProductData>(request, response, -1), wmsProductData);
    		new ExportExcel("产品详情表", WmsProductData.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出产品详情表记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsProduct:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsProductData> list = ei.getDataList(WmsProductData.class);
			for (WmsProductData wmsProductData : list){
				try{
					wmsProductDataService.save(wmsProductData);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条产品详情表记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条产品详情表记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入产品详情表失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
    }
	
	/**
	 * 下载导入产品详情表数据模板
	 */
	@RequiresPermissions("wms:wmsProduct:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品详情表数据导入模板.xlsx";
    		List<WmsProductData> list = Lists.newArrayList(); 
    		new ExportExcel("产品详情表数据", WmsProductData.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductData/?repage";
    }
	
	/**
	 * 产品详情表列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(WmsProductData wmsProductData, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(wmsProductData, request, response, model);
        return "modules/wms/wmsProductDataSelectList";
	}
	
}