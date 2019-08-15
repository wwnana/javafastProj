package com.javafast.modules.sys.web;

import java.util.List;
import java.util.Map;

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
import com.javafast.common.config.Global;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.service.MenuService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 菜单Controller
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/menu")
public class MenuController extends BaseController {

	@Autowired
	private MenuService menuService;

	@ModelAttribute
	public Menu get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return menuService.get(id);
		} else {
			return new Menu();
		}
	}

	/**
	 * 菜单 列表页面
	 */
	@RequiresPermissions("sys:menu:list")
	@RequestMapping(value = { "list", "" })
	public String list(Model model) {
		
		List<Menu> list = Lists.newArrayList();
		List<Menu> sourcelist = menuService.findAllMenu();
		Menu.sortList(list, sourcelist, Menu.getRootId(), true);
		model.addAttribute("list", list);
		return "modules/sys/menuList";
	}

	/**
	 * 菜单 查询子列表页面
	 */
	@RequiresPermissions("sys:menu:list")
	@RequestMapping(value = "getChildenList")
	public String getChildenList(Model model, String id) {
		List<Menu> list = menuService.getChildrenMenu(id);
		model.addAttribute("list", list);
		return "modules/sys/menuChildrenList";
	}

	/**
	 * 查看，增加，编辑菜单 表单页面
	 */
	@RequiresPermissions(value = { "sys:menu:view", "sys:menu:add", "sys:menu:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(Menu menu, Model model) {
		if (menu.getParent() == null || menu.getParent().getId() == null) {
			menu.setParent(new Menu(Menu.getRootId()));
		}
		
		//查询上级菜单
		menu.setParent(menuService.get(menu.getParent().getId()));
		
		// 获取排序号，最末节点排序号+30
		if (StringUtils.isBlank(menu.getId())) {
			List<Menu> list = Lists.newArrayList();
			List<Menu> sourcelist = menuService.findAllMenu();
			Menu.sortList(list, sourcelist, menu.getParentId(), false);
			if (list.size() > 0) {
				menu.setSort(list.get(list.size() - 1).getSort() + 30);
			}
		}
		
		model.addAttribute("menu", menu);
		return "modules/sys/menuForm";
	}

	/**
	 * 保存菜单
	 */
	@RequiresPermissions(value = { "sys:menu:add", "sys:menu:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(Menu menu, Model model, RedirectAttributes redirectAttributes) {
		
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
		if (!beanValidator(model, menu)) {
			return form(menu, model);
		}
		menuService.save(menu);
		addMessage(redirectAttributes, "保存菜单'" + menu.getName() + "'成功");
		return "redirect:" + adminPath + "/sys/menu/";
	}

	/**
	 * 删除菜单
	 */
	@RequiresPermissions("sys:menu:del")
	@RequestMapping(value = "delete")
	public String delete(Menu menu, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}

		menuService.delete(menu);
		addMessage(redirectAttributes, "删除菜单成功");
		return "redirect:" + adminPath + "/sys/menu/";
	}

	/**
	 * 批量删除菜单
	 */
	@RequiresPermissions("sys:menu:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
		String idArray[] = ids.split(",");
		for (String id : idArray) {
			Menu menu = menuService.get(id);
			if (menu != null) {
				menuService.delete(menuService.get(id));
			}
		}
		addMessage(redirectAttributes, "批量删除菜单成功");
		return "redirect:" + adminPath + "/sys/menu/";
	}

	/**
	 * 树形菜单列表
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "tree")
	public String tree() {
		return "modules/sys/menuTree";
	}

	@RequiresPermissions("user")
	@RequestMapping(value = "treeAce")
	public String treeAce() {
		return "modules/sys/menuTreeAce";
	}

	/**
	 * 菜单选择器
	 * @param parentId
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "treeselect")
	public String treeselect(String parentId, Model model) {
		model.addAttribute("parentId", parentId);
		return "modules/sys/menuTreeselect";
	}

	/**
	 * 批量修改菜单排序
	 */
	@RequiresPermissions("sys:menu:updateSort")
	@RequestMapping(value = "updateSort")
	public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/menu/";
		}
		for (int i = 0; i < ids.length; i++) {
			Menu menu = new Menu(ids[i]);
			menu.setSort(sorts[i]);
			menuService.updateMenuSort(menu);
		}
		addMessage(redirectAttributes, "保存菜单排序成功!");
		return "redirect:" + adminPath + "/sys/menu/";
	}

	/**
	 * 查询菜单数据
	 * @param extId
	 * @param isShowHide 是否显示隐藏菜单
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String isShowHide, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Menu> list = menuService.findAllMenu();
		for (int i = 0; i < list.size(); i++) {
			Menu e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId != null && !extId.equals(e.getId())
					&& e.getParentIds().indexOf("," + extId + ",") == -1)) {
				if (isShowHide != null && isShowHide.equals("0") && e.getIsShow().equals("0")) {
					continue;
				}
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				map.put("href", e.getHref());
				mapList.add(map);
			}
		}
		return mapList;
	}
}
