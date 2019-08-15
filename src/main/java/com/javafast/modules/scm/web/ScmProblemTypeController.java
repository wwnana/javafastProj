/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.javafast.modules.scm.web;

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
import com.javafast.modules.scm.entity.ScmProblemType;
import com.javafast.modules.scm.service.ScmProblemTypeService;

/**
 * 常见问题分类Controller
 * @author javafast
 * @version 2017-08-18
 */
@Controller
@RequestMapping(value = "${adminPath}/scm/scmProblemType")
public class ScmProblemTypeController extends BaseController {

	@Autowired
	private ScmProblemTypeService scmProblemTypeService;
	
	@ModelAttribute
	public ScmProblemType get(@RequestParam(required=false) String id) {
		ScmProblemType entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmProblemTypeService.get(id);
		}
		if (entity == null){
			entity = new ScmProblemType();
		}
		return entity;
	}
	
	/**
	 * 常见问题分类列表页面
	 */
	@RequiresPermissions("scm:scmProblem:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmProblemType scmProblemType, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<ScmProblemType> list = scmProblemTypeService.findList(scmProblemType); 
		model.addAttribute("list", list);
		return "modules/scm/scmProblemTypeList";
	}

	/**
	 * 查看，增加，编辑常见问题分类表单页面
	 */
	@RequiresPermissions(value={"scm:scmProblem:view","scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmProblemType scmProblemType, Model model) {
		if (scmProblemType.getParent()!=null && StringUtils.isNotBlank(scmProblemType.getParent().getId())){
			scmProblemType.setParent(scmProblemTypeService.get(scmProblemType.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(scmProblemType.getId())){
				ScmProblemType scmProblemTypeChild = new ScmProblemType();
				scmProblemTypeChild.setParent(new ScmProblemType(scmProblemType.getParent().getId()));
				List<ScmProblemType> list = scmProblemTypeService.findList(scmProblemType); 
				if (list.size() > 0){
					scmProblemType.setSort(list.get(list.size()-1).getSort());
					if (scmProblemType.getSort() != null){
						scmProblemType.setSort(scmProblemType.getSort() + 30);
					}
				}
			}
		}
		if (scmProblemType.getSort() == null){
			scmProblemType.setSort(30);
		}
		model.addAttribute("scmProblemType", scmProblemType);
		return "modules/scm/scmProblemTypeForm";
	}

	/**
	 * 保存常见问题分类
	 */
	@RequiresPermissions(value={"scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmProblemType scmProblemType, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmProblemType)){
			return form(scmProblemType, model);
		}
		
		try{
		
			if(!scmProblemType.getIsNewRecord()){//编辑表单保存
				ScmProblemType t = scmProblemTypeService.get(scmProblemType.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmProblemType, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmProblemTypeService.save(t);//保存
			}else{//新增表单保存
				scmProblemTypeService.save(scmProblemType);//保存
			}
			addMessage(redirectAttributes, "保存常见问题分类成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存常见问题分类失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/scm/scmProblemType/?repage";
		}
	}
	
	/**
	 * 删除常见问题分类
	 */
	@RequiresPermissions("scm:scmProblem:del")
	@RequestMapping(value = "delete")
	public String delete(ScmProblemType scmProblemType, RedirectAttributes redirectAttributes) {
		scmProblemTypeService.delete(scmProblemType);
		addMessage(redirectAttributes, "删除常见问题分类成功");
		return "redirect:"+Global.getAdminPath()+"/scm/scmProblemType/?repage";
	}

	/**
	 * 常见问题分类树形选择器
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<ScmProblemType> list = scmProblemTypeService.findList(new ScmProblemType());
		for (int i=0; i<list.size(); i++){
			ScmProblemType e = list.get(i);
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