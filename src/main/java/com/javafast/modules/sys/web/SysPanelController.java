package com.javafast.modules.sys.web;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.sys.entity.SysPanel;
import com.javafast.modules.sys.service.SysPanelService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 面板设置Controller
 * @author javafast
 * @version 2018-07-09
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysPanel")
public class SysPanelController extends BaseController {

	@Autowired
	private SysPanelService sysPanelService;
	
	@ModelAttribute
	public SysPanel get(@RequestParam(required=false) String id) {
		SysPanel entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysPanelService.get(id);
		}
		if (entity == null){
			entity = new SysPanel();
		}
		return entity;
	}
	
	/**
	 * 编辑面板设置表单页面
	 */
	@RequestMapping(value = "form")
	public String form(Model model) {
		
		List<SysPanel> sysPanelList = sysPanelService.findList(new SysPanel());		
		model.addAttribute("sysPanelList", sysPanelList);
		return "modules/sys/sysPanelForm";
	}

	/**
	 * 保存面板设置
	 */
	@RequestMapping(value = "save")
	public String save(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/home/?repage";
		}
		
		try{
		
			String[] panelIds = request.getParameterValues("panelId");
			if(panelIds != null){
				sysPanelService.saveUserPanels(panelIds);
			}

			addMessage(redirectAttributes, "保存面板设置成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存面板设置失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/home/?repage";
		}
	}
	
	/**
	 * 删除面板设置
	 */
	@RequestMapping(value = "delete")
	public String delete(SysPanel sysPanel, RedirectAttributes redirectAttributes) {
		sysPanelService.delete(sysPanel);
		addMessage(redirectAttributes, "删除面板设置成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysPanel/?repage";
	}
}