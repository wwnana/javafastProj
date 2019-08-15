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
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.service.WmsProductService;
import com.javafast.modules.wms.service.WmsProductTypeService;

/**
 * 产品Controller
 * @author javafast
 * @version 2017-07-04
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsProduct")
public class WmsProductController extends BaseController {

	@Autowired
	private WmsProductService wmsProductService;
	
	@Autowired
	private WmsProductTypeService wmsProductTypeService;
	
	@ModelAttribute
	public WmsProduct get(@RequestParam(required=false) String id) {
		WmsProduct entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsProductService.get(id);
		}
		if (entity == null){
			entity = new WmsProduct();
		}
		return entity;
	}
	
	/**
	 * 产品管理
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("wms:wmsProduct:list")
	@RequestMapping(value = "index")
	public String index(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/wms/wmsProductIndex";
	}
	
	/**
	 * 产品列表页面
	 */
	@RequiresPermissions("wms:wmsProduct:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsProduct> page = wmsProductService.findPage(new Page<WmsProduct>(request, response), wmsProduct); 
		model.addAttribute("page", page);
		return "modules/wms/wmsProductList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="wms:wmsProduct:view")
	@RequestMapping(value = "view")
	public String view(WmsProduct wmsProduct, Model model) {
		model.addAttribute("wmsProduct", wmsProduct);
		return "modules/wms/wmsProductView";
	}
	
	/**
	 * 查看，增加，编辑产品表单页面
	 */
	@RequiresPermissions(value={"wms:wmsProduct:view","wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsProduct wmsProduct, Model model) {
		if(wmsProduct.getIsNewRecord()){
			wmsProduct.setNo("SP"+IdUtils.getId());
			wmsProduct.setStatus("0");
			if(wmsProduct.getProductType()!=null && wmsProduct.getProductType().getId()!=null){
				wmsProduct.setProductType(wmsProductTypeService.get(wmsProduct.getProductType().getId()));
			}
		}
		model.addAttribute("wmsProduct", wmsProduct);
		return "modules/wms/wmsProductForm";
	}

	/**
	 * 保存产品
	 */
	@RequiresPermissions(value={"wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsProduct wmsProduct, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
		}
		if (!beanValidator(model, wmsProduct)){
			return form(wmsProduct, model);
		}
		
		try{
			
			if(!wmsProduct.getIsNewRecord()){//编辑表单保存
				WmsProduct t = wmsProductService.get(wmsProduct.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsProduct, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsProductService.save(t);//保存
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PRODUCT, Contants.ACTION_TYPE_UPDATE, wmsProduct.getId(), wmsProduct.getName(), null);
			}else{//新增表单保存
				wmsProductService.save(wmsProduct);//保存
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PRODUCT, Contants.ACTION_TYPE_ADD, wmsProduct.getId(), wmsProduct.getName(), null);
			}
			addMessage(redirectAttributes, "保存产品成功");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/view?id="+wmsProduct.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存产品失败");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
		}
	}
	
	/**
	 * 删除产品
	 */
	@RequiresPermissions("wms:wmsProduct:del")
	@RequestMapping(value = "delete")
	public String delete(WmsProduct wmsProduct, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
		}
		wmsProductService.delete(wmsProduct);
		addMessage(redirectAttributes, "删除产品成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/?repage";
	}
	
	/**
	 * 批量删除产品
	 */
	@RequiresPermissions("wms:wmsProduct:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			wmsProductService.delete(wmsProductService.get(id));
		}
		addMessage(redirectAttributes, "删除产品成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("wms:wmsProduct:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<WmsProduct> page = wmsProductService.findPage(new Page<WmsProduct>(request, response, -1), wmsProduct);
    		new ExportExcel("产品", WmsProduct.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出产品记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
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
			List<WmsProduct> list = ei.getDataList(WmsProduct.class);
			for (WmsProduct wmsProduct : list){
				try{
					wmsProductService.save(wmsProduct);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条产品记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条产品记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入产品失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
    }
	
	/**
	 * 下载导入产品数据模板
	 */
	@RequiresPermissions("wms:wmsProduct:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "产品数据导入模板.xlsx";
    		List<WmsProduct> list = Lists.newArrayList(); 
    		new ExportExcel("产品数据", WmsProduct.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProduct/list?repage";
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
	public String selectList(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsProduct.setStatus("0");
        list(wmsProduct, request, response, model);
        return "modules/wms/wmsProductSelectList";
	}

	/**
	 * 多选列表多项选择器（用途：报价单、合同）
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectListForMany")
	public String selectListForMany(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsProduct.setStatus("0");
        list(wmsProduct, request, response, model);
        return "modules/wms/wmsProductSelectListForMany";
	}
	
	/**
	 * 多选列表选择器（用途：采购单）
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectListForPur")
	public String selectListForPur(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsProduct.setStatus("0");
        list(wmsProduct, request, response, model);
        return "modules/wms/wmsProductSelectListForPur";
	}
	
	/**
	 * 多选列表选择器（通用，用途：调拨等）
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "selectListForCommon")
	public String selectListForCommon(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		wmsProduct.setStatus("0");
        list(wmsProduct, request, response, model);
        return "modules/wms/wmsProductSelectListForCommon";
	}
}