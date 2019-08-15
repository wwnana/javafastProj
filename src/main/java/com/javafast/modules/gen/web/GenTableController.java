package com.javafast.modules.gen.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.Menu;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.MenuService;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.gen.entity.GenTable;
import com.javafast.modules.gen.service.GenTableService;
import com.javafast.modules.gen.util.GenUtils;

/**
 * 业务表Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genTable")
public class GenTableController extends BaseController {

	@Autowired
	private GenTableService genTableService;

	@Autowired
	private MenuService menuService;

	@ModelAttribute
	public GenTable get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return genTableService.get(id);
		} else {
			return new GenTable();
		}
	}

	@RequiresPermissions("gen:genTable:view")
	@RequestMapping(value = { "list", "" })
	public String list(GenTable genTable, HttpServletRequest request, HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		if (!user.isAdmin()) {
			genTable.setCreateBy(user);
		}
		Page<GenTable> page = genTableService.find(new Page<GenTable>(request, response), genTable);
		model.addAttribute("page", page);
		return "modules/gen/genTableList";
	}

	/**
	 * 表单设计页面
	 * @param genTable
	 * @param model
	 * @return
	 */
	@RequiresPermissions("gen:genTable:view")
	@RequestMapping(value = "form")
	public String form(GenTable genTable, Model model) {

		// 获取物理表列表
		List<GenTable> tableList = genTableService.findTableListFormDb(new GenTable());
		model.addAttribute("tableList", tableList);

		// 验证表是否存在
		if (StringUtils.isBlank(genTable.getId()) && !genTableService.checkTableName(genTable.getName())) {
			addMessage(model, "下一步失败！" + genTable.getName() + " 表已经添加！");
			genTable.setName("");
		} else {
			// 获取物理表字段
			genTable = genTableService.getTableFormDb(genTable);
		}

		if (genTable != null && StringUtils.isNotBlank(genTable.getName())) {
			
			if(StringUtils.isBlank(genTable.getFunctionName()))
				genTable.setFunctionName(genTable.getComments());
			
			if(StringUtils.isBlank(genTable.getFunctionNameSimple()))
				genTable.setFunctionNameSimple(genTable.getComments());
			
			if(StringUtils.isBlank(genTable.getFunctionAuthor()))
				genTable.setFunctionAuthor("javafast");
			
			if(StringUtils.isBlank(genTable.getModuleName())){
				
				if(genTable.getName().contains("_")){
					genTable.setModuleName(genTable.getName().split("_")[0]);
				}else{
					if (genTable.getName().length() > 2) {
						genTable.setModuleName(genTable.getName().substring(0, 2));
					}
				}
			}
			
			if(StringUtils.isBlank(genTable.getPackageName()))
				genTable.setPackageName("com.javafast.modules");
		}

		model.addAttribute("genTable", genTable);
		model.addAttribute("config", GenUtils.getConfig());
		return "modules/gen/genTableForm";
	}

	/**
	 * 表单设计保存
	 * @param genTable
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("gen:genTable:edit")
	@RequestMapping(value = "save")
	public String save(GenTable genTable, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, genTable)) {
			return form(genTable, model);
		}

		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/gen/genTable/?repage";
		}

		// 验证表是否已经存在
		if (StringUtils.isBlank(genTable.getId()) && !genTableService.checkTableName(genTable.getName())) {
			addMessage(model, "保存失败！" + genTable.getName() + " 表已经存在！");
			genTable.setName("");
			return form(genTable, model);
		}

		genTableService.save(genTable);
		addMessage(redirectAttributes, "保存业务表'" + genTable.getName() + "'成功");
		return "redirect:" + adminPath + "/gen/genTable/?repage";
	}

	/**
	 * 生成代码到工程 提交
	 * @param genTable
	 * @param model
	 * @param redirectAttributes
	 * @param request
	 * @param response
	 * @return
	 */
	@RequiresPermissions("gen:genTable:edit")
	@RequestMapping(value = "genCode")
	public String genCode(GenTable genTable, Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response) {
		if (!beanValidator(model, genTable)) {
			return form(genTable, model);
		}

		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/gen/genTable/?repage";
		}

		// 保存
		genTableService.save(genTable);

		// 生成代码
		if ("1".equals(genTable.getFlag())) {

			String result = genTableService.generateCode(genTable);
			addMessage(redirectAttributes, "生成代码'" + genTable.getName() + "'成功<br/>" + result);
		} else {
			addMessage(redirectAttributes, "保存'" + genTable.getName() + "'成功");
		}

		return "redirect:" + adminPath + "/gen/genTable/?repage";
	}

	/**
	 * 删除
	 * @param genTable
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("gen:genTable:edit")
	@RequestMapping(value = "delete")
	public String delete(GenTable genTable, RedirectAttributes redirectAttributes) {

		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/gen/genTable/?repage";
		}

		genTableService.delete(genTable);
		addMessage(redirectAttributes, "删除业务表成功");
		return "redirect:" + adminPath + "/gen/genTable/?repage";
	}

	/**
	 * 批量删除
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("hr:hrApproval:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {

		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/gen/genTable/?repage";
		}

		String idArray[] = ids.split(",");
		for (String id : idArray) {
			genTableService.delete(genTableService.get(id));
		}

		addMessage(redirectAttributes, "删除业务表成功");
		return "redirect:" + adminPath + "/gen/genTable/?repage";
	}

	@RequestMapping(value = "javaTypeForm")
	public String javaTypeForm() {
		return "modules/gen/genJavaTypeForm";
	}

	/**
	 * 生成菜单页面
	 * @param genTableId
	 * @param menu
	 * @param model
	 * @return
	 */
	@RequiresPermissions("gen:genTable:edit")
	@RequestMapping(value = "menuForm")
	public String menuForm(String genTableId, Menu menu, Model model) {

		if ((menu.getParent() == null) || (menu.getParent().getId() == null)) {
			menu.setParent(new Menu(Menu.getRootId()));
		}
		String menuId = menu.getParent().getId();
		Menu rootMenu = this.menuService.get(menuId);
		menu.setParent(rootMenu);

		if (StringUtils.isBlank(menu.getId())) {
			List list = (List) Lists.newArrayList();
			List sourcelist = this.menuService.findAllMenu();
			Menu.sortList(list, sourcelist, menu.getParentId(), false);
			if (list.size() > 0)
				menu.setSort(Integer.valueOf(((Menu) list.get(list.size() - 1)).getSort().intValue() + 30));
		}
		GenTable table = genTableService.get(genTableId);
		menu.setName(table.getFunctionName());

		model.addAttribute("menu", menu);
		model.addAttribute("genTableId", genTableId);
		return "modules/gen/genMenuForm";
	}

	/**
	 * 生成菜单 提交
	 * @param menu
	 * @param redirectAttributes
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "createMenu")
	public String createMenu(Menu menu, RedirectAttributes redirectAttributes, HttpServletRequest request) {

		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/gen/genTable/?repage";
		}
		String genTableId = request.getParameter("genTableId");
		GenTable table = genTableService.get(genTableId);
		if (table == null) {
			addMessage(redirectAttributes, new String[] { "生成菜单失败,请先生成代码!" });
			return "redirect:" + this.adminPath + "/gen/genTable/?repage";
		}
		
		this.genTableService.createMenu(table, menu);
		addMessage(redirectAttributes, new String[] { "生成菜单'" + table.getFunctionName() + "'成功<br/>" });
		return "redirect:" + this.adminPath + "/gen/genTable/?repage";
	}

	/**
	 * 生成代码并压缩打包
	 * @param genTable
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "createCodeRar")
	public void createCodeRar(GenTable genTable, Model model, HttpServletRequest request,
			HttpServletResponse response) {
		if (!beanValidator(model, genTable)) {

		}

		try {
			// 立即生成代码
			genTable.setFlag("1");
			// 生成代码并打包RAR下载
			byte[] data = genTableService.generatorCode(genTable);
			if (data != null) {

				response.reset();
				response.setHeader("Content-Disposition", "attachment; filename=\"code.zip\"");
				response.addHeader("Content-Length", "" + data.length);
				response.setContentType("application/octet-stream; charset=UTF-8");
				IOUtils.write(data, response.getOutputStream());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
