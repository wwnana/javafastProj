/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.javafast.modules.kms.web;

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
import com.javafast.modules.kms.entity.KmsCategory;
import com.javafast.modules.kms.service.KmsCategoryService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 * @author javafast
 * @version 2017-08-03
 */
@Controller
@RequestMapping(value = "${adminPath}/kms/kmsCategory")
public class KmsCategoryController extends BaseController {

	@Autowired
	private KmsCategoryService kmsCategoryService;
	
	@ModelAttribute
	public KmsCategory get(@RequestParam(required=false) String id) {
		KmsCategory entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = kmsCategoryService.get(id);
		}
		if (entity == null){
			entity = new KmsCategory();
		}
		return entity;
	}
	
	/**
	 * 栏目列表页面
	 */
	@RequiresPermissions("kms:kmsArticle:list")
	@RequestMapping(value = {"list", ""})
	public String list(KmsCategory kmsCategory, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<KmsCategory> list = kmsCategoryService.findList(kmsCategory); 
		model.addAttribute("list", list);
		return "modules/kms/kmsCategoryList";
	}

	/**
	 * 查看，增加，编辑栏目表单页面
	 */
	@RequiresPermissions(value={"kms:kmsArticle:view","kms:kmsArticle:add","kms:kmsArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(KmsCategory kmsCategory, Model model) {
		if (kmsCategory.getParent()!=null && StringUtils.isNotBlank(kmsCategory.getParent().getId())){
			kmsCategory.setParent(kmsCategoryService.get(kmsCategory.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(kmsCategory.getId())){
				KmsCategory kmsCategoryChild = new KmsCategory();
				kmsCategoryChild.setParent(new KmsCategory(kmsCategory.getParent().getId()));
				List<KmsCategory> list = kmsCategoryService.findList(kmsCategory); 
				if (list.size() > 0){
					kmsCategory.setSort(list.get(list.size()-1).getSort());
					if (kmsCategory.getSort() != null){
						kmsCategory.setSort(kmsCategory.getSort() + 30);
					}
				}
			}
		}
		if (kmsCategory.getSort() == null){
			kmsCategory.setSort(30);
		}
		model.addAttribute("kmsCategory", kmsCategory);
		return "modules/kms/kmsCategoryForm";
	}

	/**
	 * 保存栏目
	 */
	@RequiresPermissions(value={"kms:kmsArticle:add","kms:kmsArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(KmsCategory kmsCategory, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, kmsCategory)){
			return form(kmsCategory, model);
		}
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsCategory/?repage";
		}
		try{
			
			if(!kmsCategory.getIsNewRecord()){//编辑表单保存
				KmsCategory t = kmsCategoryService.get(kmsCategory.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(kmsCategory, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				kmsCategoryService.save(t);//保存
			}else{//新增表单保存
				kmsCategoryService.save(kmsCategory);//保存
			}
			addMessage(redirectAttributes, "保存栏目成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存栏目失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/kms/kmsCategory/?repage";
		}
	}
	
	/**
	 * 删除栏目
	 */
	@RequiresPermissions("kms:kmsArticle:del")
	@RequestMapping(value = "delete")
	public String delete(KmsCategory kmsCategory, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsCategory/?repage";
		}
		kmsCategoryService.delete(kmsCategory);
		addMessage(redirectAttributes, "删除栏目成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsCategory/?repage";
	}

	/**
	 * 栏目树形选择器
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		KmsCategory conKmsCategory = new KmsCategory();
		conKmsCategory.setInMenu("1");
		List<KmsCategory> list = kmsCategoryService.findList(conKmsCategory);
		for (int i=0; i<list.size(); i++){
			KmsCategory e = list.get(i);
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