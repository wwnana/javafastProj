package com.javafast.modules.crm.web;

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
import com.javafast.modules.crm.entity.CrmCustomerType;
import com.javafast.modules.crm.service.CrmCustomerTypeService;

/**
 * 客户分类Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/crm/crmCustomerType")
public class CrmCustomerTypeController extends BaseController {

	@Autowired
	private CrmCustomerTypeService crmCustomerTypeService;
	
	@ModelAttribute
	public CrmCustomerType get(@RequestParam(required=false) String id) {
		CrmCustomerType entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmCustomerTypeService.get(id);
		}
		if (entity == null){
			entity = new CrmCustomerType();
		}
		return entity;
	}
	
	/**
	 * 客户分类列表页面
	 */
	@RequiresPermissions("crm:crmCustomerType:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmCustomerType crmCustomerType, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CrmCustomerType> list = crmCustomerTypeService.findList(crmCustomerType); 
		model.addAttribute("list", list);
		return "modules/crm/crmCustomerTypeList";
	}

	/**
	 * 查看，增加，编辑客户分类表单页面
	 */
	@RequiresPermissions(value={"crm:crmCustomerType:view","crm:crmCustomerType:add","crm:crmCustomerType:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmCustomerType crmCustomerType, Model model) {
		if (crmCustomerType.getParent()!=null && StringUtils.isNotBlank(crmCustomerType.getParent().getId())){
			crmCustomerType.setParent(crmCustomerTypeService.get(crmCustomerType.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(crmCustomerType.getId())){
				CrmCustomerType crmCustomerTypeChild = new CrmCustomerType();
				crmCustomerTypeChild.setParent(new CrmCustomerType(crmCustomerType.getParent().getId()));
				List<CrmCustomerType> list = crmCustomerTypeService.findList(crmCustomerType); 
				if (list.size() > 0){
					crmCustomerType.setSort(list.get(list.size()-1).getSort());
					if (crmCustomerType.getSort() != null){
						crmCustomerType.setSort(crmCustomerType.getSort() + 30);
					}
				}
			}
		}
		if (crmCustomerType.getSort() == null){
			crmCustomerType.setSort(30);
		}
		model.addAttribute("crmCustomerType", crmCustomerType);
		return "modules/crm/crmCustomerTypeForm";
	}

	/**
	 * 保存客户分类
	 */
	@RequiresPermissions(value={"crm:crmCustomerType:add","crm:crmCustomerType:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmCustomerType crmCustomerType, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmCustomerType)){
			return form(crmCustomerType, model);
		}
		
		try{
			
			if(!crmCustomerType.getIsNewRecord()){//编辑表单保存
				CrmCustomerType t = crmCustomerTypeService.get(crmCustomerType.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmCustomerType, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmCustomerTypeService.save(t);//保存
			}else{//新增表单保存
				crmCustomerTypeService.save(crmCustomerType);//保存
			}
			addMessage(redirectAttributes, "保存客户分类成功");
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存客户分类失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerType/?repage";
		}
	}
	
	/**
	 * 删除客户分类
	 */
	@RequiresPermissions("crm:crmCustomerType:del")
	@RequestMapping(value = "delete")
	public String delete(CrmCustomerType crmCustomerType, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerType/?repage";
		}
		crmCustomerTypeService.delete(crmCustomerType);
		addMessage(redirectAttributes, "删除客户分类成功");
		return "redirect:"+Global.getAdminPath()+"/crm/crmCustomerType/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<CrmCustomerType> list = crmCustomerTypeService.findList(new CrmCustomerType());
		for (int i=0; i<list.size(); i++){
			CrmCustomerType e = list.get(i);
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