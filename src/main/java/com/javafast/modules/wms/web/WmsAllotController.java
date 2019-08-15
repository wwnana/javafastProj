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
import com.javafast.modules.wms.entity.WmsAllot;
import com.javafast.modules.wms.service.WmsAllotService;

/**
 * 调拨单Controller
 * @author javafast
 * @version 2018-01-11
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsAllot")
public class WmsAllotController extends BaseController {

	@Autowired
	private WmsAllotService wmsAllotService;
	
	@ModelAttribute
	public WmsAllot get(@RequestParam(required=false) String id) {
		WmsAllot entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsAllotService.get(id);
		}
		if (entity == null){
			entity = new WmsAllot();
		}
		return entity;
	}
	
	/**
	 * 调拨单列表页面
	 */
	@RequiresPermissions("wms:wmsAllot:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsAllot wmsAllot, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsAllot> page = wmsAllotService.findPage(new Page<WmsAllot>(request, response), wmsAllot); 
		model.addAttribute("page", page);
		return "modules/wms/wmsAllotList";
	}

	/**
	 * 编辑调拨单表单页面
	 */
	@RequiresPermissions(value={"wms:wmsAllot:view","wms:wmsAllot:add","wms:wmsAllot:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsAllot wmsAllot, Model model) {
		
		if(wmsAllot.getIsNewRecord()){
			wmsAllot.setNo("DB"+IdUtils.getId());
			wmsAllot.setStatus("0");
		}		
		if(wmsAllot.getDealBy() == null){
			wmsAllot.setDealBy(UserUtils.getUser());
		}
		if(wmsAllot.getDealDate() == null){
			wmsAllot.setDealDate(new Date());
		}
		
		model.addAttribute("wmsAllot", wmsAllot);
		return "modules/wms/wmsAllotForm";
	}
	
	/**
	 * 查看调拨单页面
	 */
	@RequiresPermissions(value="wms:wmsAllot:view")
	@RequestMapping(value = "view")
	public String view(WmsAllot wmsAllot, Model model) {
		model.addAttribute("wmsAllot", wmsAllot);
		return "modules/wms/wmsAllotView";
	}

	/**
	 * 保存调拨单
	 */
	@RequiresPermissions(value={"wms:wmsAllot:add","wms:wmsAllot:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsAllot wmsAllot, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsAllot)){
			return form(wmsAllot, model);
		}
		
		try{
		
			//校验
			if(wmsAllot.getOutWarehouse().getId().equals(wmsAllot.getInWarehouse().getId())){
				addMessage(redirectAttributes, "提交失败！调出仓库和调入仓库不能为同一仓库！");
				return form(wmsAllot, model);
			}
			
			if(!wmsAllot.getIsNewRecord()){//编辑表单保存				
				WmsAllot t = wmsAllotService.get(wmsAllot.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsAllot, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsAllotService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_ALLOT, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{//新增表单保存
				wmsAllot.setStatus("0");
				wmsAllotService.save(wmsAllot);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_ALLOT, Contants.ACTION_TYPE_ADD, wmsAllot.getId(), wmsAllot.getNo(), null);
			}
			addMessage(redirectAttributes, "保存调拨单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存调拨单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
		}
	}
	
	/**
	 * 删除调拨单
	 */
	@RequiresPermissions("wms:wmsAllot:del")
	@RequestMapping(value = "delete")
	public String delete(WmsAllot wmsAllot, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
		}
		
		wmsAllotService.delete(wmsAllot);
		addMessage(redirectAttributes, "删除调拨单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
	}
	
	/**
	 * 批量删除调拨单
	 */
	@RequiresPermissions("wms:wmsAllot:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsAllotService.delete(wmsAllotService.get(id));
		}
		addMessage(redirectAttributes, "删除调拨单成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsAllot:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsAllot wmsAllot, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调拨单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsAllot> page = wmsAllotService.findPage(new Page<WmsAllot>(request, response, -1), wmsAllot);
    		new ExportExcel("调拨单", WmsAllot.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出调拨单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("wms:wmsAllot:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<WmsAllot> list = ei.getDataList(WmsAllot.class);
			for (WmsAllot wmsAllot : list){
				try{
					wmsAllotService.save(wmsAllot);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条调拨单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条调拨单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入调拨单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
    }
	
	/**
	 * 下载导入调拨单数据模板
	 */
	@RequiresPermissions("wms:wmsAllot:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "调拨单数据导入模板.xlsx";
    		List<WmsAllot> list = Lists.newArrayList(); 
    		new ExportExcel("调拨单数据", WmsAllot.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
    }
	
	/**
	 * 调拨单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(WmsAllot wmsAllot, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(wmsAllot, request, response, model);
        return "modules/wms/wmsAllotSelectList";
	}
	
	/**
	 * 审核
	 * @param wmsPurchase
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("wms:wmsAllot:audit")
	@RequestMapping(value = "audit")
	public String audit(WmsAllot wmsAllot, RedirectAttributes redirectAttributes) {
		
		try {
			
			wmsAllotService.audit(wmsAllot);
			DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_ALLOT, Contants.ACTION_TYPE_AUDIT, wmsAllot.getId(), wmsAllot.getNo(), null);
			addMessage(redirectAttributes, "审核调拨单成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "审核调拨单失败！");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsAllot/?repage";
		}
	}
}