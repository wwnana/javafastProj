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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.service.WmsStockService;

/**
 * 产品库存Controller
 * @author javafast
 * @version 2017-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsStock")
public class WmsStockController extends BaseController {

	@Autowired
	private WmsStockService wmsStockService;
	
	@ModelAttribute
	public WmsStock get(@RequestParam(required=false) String id) {
		WmsStock entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsStockService.get(id);
		}
		if (entity == null){
			entity = new WmsStock();
		}
		return entity;
	}
	
	/**
	 * 产品库存列表页面
	 */
	@RequiresPermissions("wms:wmsStock:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsStock wmsStock, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsStock> page = wmsStockService.findPage(new Page<WmsStock>(request, response), wmsStock); 
		model.addAttribute("page", page);
		return "modules/wms/wmsStockList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsStock:view")
	@RequestMapping(value = "view")
	public String view(WmsStock wmsStock, Model model) {
		model.addAttribute("wmsStock", wmsStock);
		return "modules/wms/wmsStockView";
	}
	
	/**
	 * 查看，增加，编辑产品库存表单页面
	 */
	@RequiresPermissions(value={"wms:wmsStock:view","wms:wmsStock:add","wms:wmsStock:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsStock wmsStock, Model model) {
		model.addAttribute("wmsStock", wmsStock);
		return "modules/wms/wmsStockForm";
	}

	/**
	 * 保存产品库存
	 */
	@RequiresPermissions(value={"wms:wmsStock:add","wms:wmsStock:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsStock wmsStock, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsStock)){
			return form(wmsStock, model);
		}
		try{
			
			if(!wmsStock.getIsNewRecord()){//编辑表单保存
				WmsStock t = wmsStockService.get(wmsStock.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsStock, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsStockService.save(t);//保存
			}else{//新增表单保存
				wmsStockService.save(wmsStock);//保存
			}
			addMessage(redirectAttributes, "保存产品库存成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存产品库存失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
		}
	}
	
	/**
	 * 删除产品库存
	 */
	@RequiresPermissions("wms:wmsStock:del")
	@RequestMapping(value = "delete")
	public String delete(WmsStock wmsStock, RedirectAttributes redirectAttributes) {
		wmsStockService.delete(wmsStock);
		addMessage(redirectAttributes, "删除产品库存成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
	}
	
	/**
	 * 批量删除产品库存
	 */
	@RequiresPermissions("wms:wmsStock:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsStockService.delete(wmsStockService.get(id));
		}
		addMessage(redirectAttributes, "删除产品库存成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsStock:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsStock wmsStock, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品库存"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsStock> page = wmsStockService.findPage(new Page<WmsStock>(request, response, -1), wmsStock);
    		new ExportExcel("产品库存", WmsStock.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出产品库存记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsStock:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsStock> list = ei.getDataList(WmsStock.class);
			for (WmsStock wmsStock : list){
				try{
					wmsStockService.save(wmsStock);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条产品库存记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条产品库存记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入产品库存失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
    }
	
	/**
	 * 下载导入产品库存数据模板
	 */
	@RequiresPermissions("wms:wmsStock:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品库存数据导入模板.xlsx";
    		List<WmsStock> list = Lists.newArrayList(); 
    		new ExportExcel("产品库存数据", WmsStock.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
    }
	
	/**
	 * 预警设置页面
	 * @param wmsStock
	 * @param model
	 * @return
	 */
	@RequiresPermissions("wms:wmsStock:edit")
	@RequestMapping(value = "warnForm")
	public String warnForm(WmsStock wmsStock, Model model) {
		model.addAttribute("wmsStock", wmsStock);
		return "modules/wms/wmsStockWarnForm";
	}
	
	/**
	 * 更新预警
	 * @param wmsStock
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("wms:wmsStock:edit")
	@RequestMapping(value = "saveWarn")
	public String saveWarn(WmsStock wmsStock, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsStock)){
			return form(wmsStock, model);
		}
		
		WmsStock t = wmsStockService.get(wmsStock.getId());//从数据库取出记录的值
		t.setWarnNum(wmsStock.getWarnNum());
		wmsStockService.save(t);//保存
		
		addMessage(redirectAttributes, "更新产品库存预警成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStock/?repage";
	}
}