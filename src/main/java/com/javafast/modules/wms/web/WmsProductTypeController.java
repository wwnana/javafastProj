/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.javafast.modules.wms.web;

import java.util.List;
import java.util.Map;

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

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.service.WmsProductTypeService;

/**
 * 产品分类Controller
 * @author javafast
 * @version 2017-07-04
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsProductType")
public class WmsProductTypeController extends BaseController {

	@Autowired
	private WmsProductTypeService wmsProductTypeService;
	
	@ModelAttribute
	public WmsProductType get(@RequestParam(required=false) String id) {
		WmsProductType entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsProductTypeService.get(id);
		}
		if (entity == null){
			entity = new WmsProductType();
		}
		return entity;
	}
	
	/**
	 * 产品分类列表页面
	 */
	@RequiresPermissions("wms:wmsProduct:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsProductType wmsProductType, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<WmsProductType> list = wmsProductTypeService.findList(wmsProductType); 
		model.addAttribute("list", list);
		return "modules/wms/wmsProductTypeList";
	}

	/**
	 * 查看，增加，编辑产品分类表单页面
	 */
	@RequiresPermissions(value={"wms:wmsProduct:view","wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsProductType wmsProductType, Model model) {
		if (wmsProductType.getParent()!=null && StringUtils.isNotBlank(wmsProductType.getParent().getId())){
			wmsProductType.setParent(wmsProductTypeService.get(wmsProductType.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(wmsProductType.getId())){
				WmsProductType wmsProductTypeChild = new WmsProductType();
				wmsProductTypeChild.setParent(new WmsProductType(wmsProductType.getParent().getId()));
				List<WmsProductType> list = wmsProductTypeService.findList(wmsProductType); 
				if (list.size() > 0){
					wmsProductType.setSort(list.get(list.size()-1).getSort());
					if (wmsProductType.getSort() != null){
						wmsProductType.setSort(wmsProductType.getSort() + 30);
					}
				}
			}
		}
		if (wmsProductType.getSort() == null){
			wmsProductType.setSort(30);
		}
		model.addAttribute("wmsProductType", wmsProductType);
		return "modules/wms/wmsProductTypeForm";
	}

	/**
	 * 保存产品分类
	 */
	@RequiresPermissions(value={"wms:wmsProduct:add","wms:wmsProduct:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsProductType wmsProductType, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProductType/?repage";
		}
		if (!beanValidator(model, wmsProductType)){
			return form(wmsProductType, model);
		}
		try{
			
			if(!wmsProductType.getIsNewRecord()){//编辑表单保存
				WmsProductType t = wmsProductTypeService.get(wmsProductType.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsProductType, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsProductTypeService.save(t);//保存
			}else{//新增表单保存
				wmsProductTypeService.save(wmsProductType);//保存
			}
			addMessage(redirectAttributes, "保存产品分类成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存产品分类失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProductType/?repage";
		}
	}
	
	/**
	 * 删除产品分类
	 */
	@RequiresPermissions("wms:wmsProduct:del")
	@RequestMapping(value = "delete")
	public String delete(WmsProductType wmsProductType, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/wms/wmsProductType/?repage";
		}
		wmsProductTypeService.delete(wmsProductType);
		addMessage(redirectAttributes, "删除产品分类成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsProductType/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<WmsProductType> list = wmsProductTypeService.findList(new WmsProductType());
		for (int i=0; i<list.size(); i++){
			WmsProductType e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}
	
}