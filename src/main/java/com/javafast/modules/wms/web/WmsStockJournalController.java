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

import java.util.Date;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.wms.entity.WmsStockJournal;
import com.javafast.modules.wms.service.WmsStockJournalService;

/**
 * 库存流水Controller
 * @author javafast
 * @version 2017-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsStockJournal")
public class WmsStockJournalController extends BaseController {

	@Autowired
	private WmsStockJournalService wmsStockJournalService;
	
	@ModelAttribute
	public WmsStockJournal get(@RequestParam(required=false) String id) {
		WmsStockJournal entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsStockJournalService.get(id);
		}
		if (entity == null){
			entity = new WmsStockJournal();
		}
		return entity;
	}
	
	/**
	 * 库存流水列表页面
	 */
	@RequiresPermissions("wms:wmsStockJournal:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsStockJournal wmsStockJournal, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsStockJournal> page = wmsStockJournalService.findPage(new Page<WmsStockJournal>(request, response), wmsStockJournal); 
		model.addAttribute("page", page);
		return "modules/wms/wmsStockJournalList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsStockJournal:view")
	@RequestMapping(value = "view")
	public String view(WmsStockJournal wmsStockJournal, Model model) {
		model.addAttribute("wmsStockJournal", wmsStockJournal);
		return "modules/wms/wmsStockJournalView";
	}
	
	/**
	 * 查看，增加，编辑库存流水表单页面
	 */
	@RequiresPermissions(value={"wms:wmsStockJournal:view","wms:wmsStockJournal:add","wms:wmsStockJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsStockJournal wmsStockJournal, Model model) {
		model.addAttribute("wmsStockJournal", wmsStockJournal);
		return "modules/wms/wmsStockJournalForm";
	}

	/**
	 * 保存库存流水
	 */
	@RequiresPermissions(value={"wms:wmsStockJournal:add","wms:wmsStockJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsStockJournal wmsStockJournal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsStockJournal)){
			return form(wmsStockJournal, model);
		}
		
		try{
			if(!wmsStockJournal.getIsNewRecord()){//编辑表单保存
				WmsStockJournal t = wmsStockJournalService.get(wmsStockJournal.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsStockJournal, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsStockJournalService.save(t);//保存
			}else{//新增表单保存
				wmsStockJournalService.save(wmsStockJournal);//保存
			}
			addMessage(redirectAttributes, "保存库存流水成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存库存流水失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
		}
	}
	
	/**
	 * 删除库存流水
	 */
	@RequiresPermissions("wms:wmsStockJournal:del")
	@RequestMapping(value = "delete")
	public String delete(WmsStockJournal wmsStockJournal, RedirectAttributes redirectAttributes) {
		wmsStockJournalService.delete(wmsStockJournal);
		addMessage(redirectAttributes, "删除库存流水成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
	}
	
	/**
	 * 批量删除库存流水
	 */
	@RequiresPermissions("wms:wmsStockJournal:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsStockJournalService.delete(wmsStockJournalService.get(id));
		}
		addMessage(redirectAttributes, "删除库存流水成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsStockJournal:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsStockJournal wmsStockJournal, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "库存流水"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsStockJournal> page = wmsStockJournalService.findPage(new Page<WmsStockJournal>(request, response, -1), wmsStockJournal);
    		new ExportExcel("库存流水", WmsStockJournal.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出库存流水记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsStockJournal:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsStockJournal> list = ei.getDataList(WmsStockJournal.class);
			for (WmsStockJournal wmsStockJournal : list){
				try{
					wmsStockJournalService.save(wmsStockJournal);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条库存流水记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条库存流水记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入库存流水失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
    }
	
	/**
	 * 下载导入库存流水数据模板
	 */
	@RequiresPermissions("wms:wmsStockJournal:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "库存流水数据导入模板.xlsx";
    		List<WmsStockJournal> list = Lists.newArrayList(); 
    		new ExportExcel("库存流水数据", WmsStockJournal.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsStockJournal/?repage";
    }
	
	
	

}