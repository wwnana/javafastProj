package com.javafast.mobile.wms.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.service.WmsProductService;
import com.javafast.modules.wms.service.WmsProductTypeService;

/**
 * 产品Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/wms/wmsProduct")
public class MobileWmsProductController extends BaseController {

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
	 * 产品列表页面
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"list", ""})
	public String list(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/wms/wmsProductList";
	}
	
	/**
	 * 查询数据列表
	 * @param wmsProduct
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WmsProduct> page = wmsProductService.findPage(new Page<WmsProduct>(request, response), wmsProduct); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param wmsProduct
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(WmsProduct wmsProduct, Model model) {		
		model.addAttribute("wmsProduct", wmsProduct);
		List<WmsProductType> wmsProductTypeList = wmsProductTypeService.findList(new WmsProductType()); 
		model.addAttribute("wmsProductTypeList", wmsProductTypeList);
		return "modules/wms/wmsProductSearch";
	}
	
	/**
	 * 产品详情页面
	 * @param wmsProduct
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="wms:wmsProduct:view")
	@RequestMapping(value = "view")
	public String view(WmsProduct wmsProduct, Model model) {
		model.addAttribute("wmsProduct", wmsProduct);
		
		return "modules/wms/wmsProductView";
	}
	
	/**
	 * 编辑产品表单页面
	 */
	@RequestMapping(value = "form")
	public String form(WmsProduct wmsProduct, Model model) {
		
		model.addAttribute("wmsProduct", wmsProduct);
		
		List<WmsProductType> wmsProductTypeList = wmsProductTypeService.findList(new WmsProductType()); 
		model.addAttribute("wmsProductTypeList", wmsProductTypeList);
		
		return "modules/wms/wmsProductForm";
	}
	
	/**
	 * 保存产品
	 */
	@RequiresPermissions(value={"wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsProduct wmsProduct, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsProduct)){
			return form(wmsProduct, model);
		}
		
		try{
		
			if(!wmsProduct.getIsNewRecord()){//编辑表单保存				
				WmsProduct t = wmsProductService.get(wmsProduct.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsProduct, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsProductService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PRODUCT, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				wmsProductService.save(wmsProduct);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PRODUCT, Contants.ACTION_TYPE_ADD, wmsProduct.getId(), wmsProduct.getName(), null);
			}
			addMessage(redirectAttributes, "保存产品成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/wms/wmsProduct/view?id="+wmsProduct.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存产品失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/wms/wmsProduct/?repage";
		}
	}
	
	@RequestMapping(value = "selectList")
	public String selectList(WmsProduct wmsProduct, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/wms/wmsProductSelectList";
	}
}
