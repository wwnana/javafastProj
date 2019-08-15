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
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.entity.WmsOutstockDetail;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.service.WmsOutstockService;
import com.javafast.modules.wms.service.WmsStockJournalService;

/**
 * 出库单Controller
 * @author javafast
 * @version 2017-07-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsOutstock")
public class WmsOutstockController extends BaseController {

	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@Autowired
	private WmsStockJournalService wmsStockJournalService;
		
	@ModelAttribute
	public WmsOutstock get(@RequestParam(required=false) String id) {
		WmsOutstock entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsOutstockService.get(id);
		}
		if (entity == null){
			entity = new WmsOutstock();
		}
		return entity;
	}
	
	/**
	 * 出库单列表页面
	 */
	@RequiresPermissions("wms:wmsOutstock:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsOutstock wmsOutstock, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsOutstock> page = wmsOutstockService.findPage(new Page<WmsOutstock>(request, response), wmsOutstock); 
		model.addAttribute("page", page);
		return "modules/wms/wmsOutstockList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsOutstock:view")
	@RequestMapping(value = "view")
	public String view(WmsOutstock wmsOutstock, Model model) {
		model.addAttribute("wmsOutstock", wmsOutstock);
		return "modules/wms/wmsOutstockView";
	}
	
	/**
	 * 打印
	 * @param wmsOutstock
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="wms:wmsOutstock:view")
	@RequestMapping(value = "print")
	public String print(WmsOutstock wmsOutstock, Model model) {
		model.addAttribute("wmsOutstock", wmsOutstock);
		return "modules/wms/wmsOutstockPrint";
	}
	
	/**
	 * 查看，增加，编辑出库单表单页面
	 */
	@RequiresPermissions(value={"wms:wmsOutstock:view","wms:wmsOutstock:add","wms:wmsOutstock:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsOutstock wmsOutstock, Model model) {
		if(wmsOutstock.getIsNewRecord()){
			wmsOutstock.setNo("RK"+IdUtils.getId());
		}
		if(wmsOutstock.getDealBy() == null){
			wmsOutstock.setDealBy(UserUtils.getUser());
		}
		if(wmsOutstock.getDealDate() == null){
			wmsOutstock.setDealDate(new Date());
		}
		model.addAttribute("wmsOutstock", wmsOutstock);
		return "modules/wms/wmsOutstockForm";
	}

	/**
	 * 保存出库单
	 */
	@RequiresPermissions(value={"wms:wmsOutstock:add","wms:wmsOutstock:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsOutstock wmsOutstock, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsOutstock)){
			return form(wmsOutstock, model);
		}
		
		try{
		
			if(!wmsOutstock.getIsNewRecord()){//编辑表单保存		
								
				//检查库存是否足够
				String checkResult = checkStock(wmsOutstock);
				if(StringUtils.isNotBlank(checkResult)){
					addMessage(redirectAttributes, "审核出库单失败，原因："+checkResult);
					return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
				}
				
				WmsOutstock t = wmsOutstockService.get(wmsOutstock.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsOutstock, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsOutstockService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_STOKBILL_OUT, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{//新增表单保存
				wmsOutstockService.save(wmsOutstock);//保存
			}
			addMessage(redirectAttributes, "保存出库单成功");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存出库单失败");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
		}
	}
	
	/**
	 * 删除出库单
	 */
	@RequiresPermissions("wms:wmsOutstock:del")
	@RequestMapping(value = "delete")
	public String delete(WmsOutstock wmsOutstock, RedirectAttributes redirectAttributes) {
		wmsOutstockService.delete(wmsOutstock);
		addMessage(redirectAttributes, "删除出库单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
	}
	
	/**
	 * 批量删除出库单
	 */
	@RequiresPermissions("wms:wmsOutstock:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsOutstockService.delete(wmsOutstockService.get(id));
		}
		addMessage(redirectAttributes, "删除出库单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsOutstock:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsOutstock wmsOutstock, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "出库单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsOutstock> page = wmsOutstockService.findPage(new Page<WmsOutstock>(request, response, -1), wmsOutstock);
    		new ExportExcel("出库单", WmsOutstock.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出出库单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsOutstock:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsOutstock> list = ei.getDataList(WmsOutstock.class);
			for (WmsOutstock wmsOutstock : list){
				try{
					wmsOutstockService.save(wmsOutstock);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条出库单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条出库单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入出库单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
    }
	
	/**
	 * 下载导入出库单数据模板
	 */
	@RequiresPermissions("wms:wmsOutstock:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "出库单数据导入模板.xlsx";
    		List<WmsOutstock> list = Lists.newArrayList(); 
    		new ExportExcel("出库单数据", WmsOutstock.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
    }
	
	/**
	 * 列表选择器
	 * @param wmsOutstock
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectList")
	public String selectList(WmsOutstock wmsOutstock, HttpServletRequest request, HttpServletResponse response, Model model) {
		
        list(wmsOutstock, request, response, model);
        return "modules/wms/wmsOutstockSelectList";
	}
	
	/**
	 * 检查库存是否足够
	 * @param wmsOutstock
	 * @return
	 */
	public String checkStock(WmsOutstock wmsOutstock){
		
		String checkResult = "";
		//检查库存是否足够
		for(WmsOutstockDetail wmsOutstockDetail : wmsOutstock.getWmsOutstockDetailList()){
			
			//查询库存
			WmsStock wmsStock = wmsStockJournalService.getProductStock(wmsOutstockDetail.getProduct().getId(), wmsOutstock.getWarehouse().getId());
			if(wmsStock == null){
				
				checkResult+="产品"+wmsOutstockDetail.getProduct().getName()+"无库存，";
			}else{
				if(wmsStock.getStockNum() - wmsOutstockDetail.getOutstockNum() < 0){
					
					checkResult+="产品"+wmsOutstockDetail.getProduct().getName()+"库存不足，";
				}
			}
		}
		
		return checkResult;
	}
	
	/**
	 * 审核出库单
	 * @param wmsOutstock
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("wms:wmsOutstock:audit")
	@RequestMapping(value = "audit")
	public String audit(WmsOutstock wmsOutstock, RedirectAttributes redirectAttributes) {
		
		try {
			
			//检查库存是否足够
			String checkResult = checkStock(wmsOutstock);
			if(StringUtils.isNotBlank(checkResult)){
				addMessage(redirectAttributes, "审核出库单失败，原因："+checkResult);
				return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
			}
			
			wmsOutstockService.audit(wmsOutstock);
			DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_STOKBILL_OUT, Contants.ACTION_TYPE_AUDIT, wmsOutstock.getId(), wmsOutstock.getNo(), null);
			
			addMessage(redirectAttributes, "审核出库单成功");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "审核出库单失败");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsOutstock/?repage";
		}
	}
}