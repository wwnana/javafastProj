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
import com.javafast.modules.wms.entity.WmsSupplierType;
import com.javafast.modules.wms.service.WmsSupplierTypeService;

/**
 * 供应商分类Controller
 * @author javafast
 * @version 2017-07-04
 */
@Controller
@RequestMapping(value = "${adminPath}/wms/wmsSupplierType")
public class WmsSupplierTypeController extends BaseController {

	@Autowired
	private WmsSupplierTypeService wmsSupplierTypeService;
	
	@ModelAttribute
	public WmsSupplierType get(@RequestParam(required=false) String id) {
		WmsSupplierType entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = wmsSupplierTypeService.get(id);
		}
		if (entity == null){
			entity = new WmsSupplierType();
		}
		return entity;
	}
	
	/**
	 * 供应商分类列表页面
	 */
	@RequiresPermissions("wms:wmsSupplier:list")
	@RequestMapping(value = {"list", ""})
	public String list(WmsSupplierType wmsSupplierType, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<WmsSupplierType> list = wmsSupplierTypeService.findList(wmsSupplierType); 
		model.addAttribute("list", list);
		return "modules/wms/wmsSupplierTypeList";
	}

	/**
	 * 查看，增加，编辑供应商分类表单页面
	 */
	@RequiresPermissions(value={"wms:wmsSupplier:view","wms:wmsSupplier:add","wms:wmsSupplier:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(WmsSupplierType wmsSupplierType, Model model) {
		if (wmsSupplierType.getParent()!=null && StringUtils.isNotBlank(wmsSupplierType.getParent().getId())){
			wmsSupplierType.setParent(wmsSupplierTypeService.get(wmsSupplierType.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(wmsSupplierType.getId())){
				WmsSupplierType wmsSupplierTypeChild = new WmsSupplierType();
				wmsSupplierTypeChild.setParent(new WmsSupplierType(wmsSupplierType.getParent().getId()));
				List<WmsSupplierType> list = wmsSupplierTypeService.findList(wmsSupplierType); 
				if (list.size() > 0){
					wmsSupplierType.setSort(list.get(list.size()-1).getSort());
					if (wmsSupplierType.getSort() != null){
						wmsSupplierType.setSort(wmsSupplierType.getSort() + 30);
					}
				}
			}
		}
		if (wmsSupplierType.getSort() == null){
			wmsSupplierType.setSort(30);
		}
		model.addAttribute("wmsSupplierType", wmsSupplierType);
		return "modules/wms/wmsSupplierTypeForm";
	}

	/**
	 * 保存供应商分类
	 */
	@RequiresPermissions(value={"wms:wmsSupplier:add","wms:wmsSupplier:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(WmsSupplierType wmsSupplierType, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, wmsSupplierType)){
			return form(wmsSupplierType, model);
		}
		try{
			
			if(!wmsSupplierType.getIsNewRecord()){//编辑表单保存
				WmsSupplierType t = wmsSupplierTypeService.get(wmsSupplierType.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(wmsSupplierType, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				wmsSupplierTypeService.save(t);//保存
			}else{//新增表单保存
				wmsSupplierTypeService.save(wmsSupplierType);//保存
			}
			addMessage(redirectAttributes, "保存供应商分类成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存供应商分类失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplierType/?repage";
		}
	}
	
	/**
	 * 删除供应商分类
	 */
	@RequiresPermissions("wms:wmsSupplier:del")
	@RequestMapping(value = "delete")
	public String delete(WmsSupplierType wmsSupplierType, RedirectAttributes redirectAttributes) {
		wmsSupplierTypeService.delete(wmsSupplierType);
		addMessage(redirectAttributes, "删除供应商分类成功");
		return "redirect:"+Global.getAdminPath()+"/wms/wmsSupplierType/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<WmsSupplierType> list = wmsSupplierTypeService.findList(new WmsSupplierType());
		for (int i=0; i<list.size(); i++){
			WmsSupplierType e = list.get(i);
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