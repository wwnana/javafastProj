/**
 * Copyright 2015-2020
 */
package com.javafast.modules.fi.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.google.gson.JsonObject;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.service.FiFinanceAccountService;

/**
 * 结算账户Controller
 * @author javafast
 * @version 2017-07-07
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiFinanceAccount")
public class FiFinanceAccountController extends BaseController {

	@Autowired
	private FiFinanceAccountService fiFinanceAccountService;
	
	@ModelAttribute
	public FiFinanceAccount get(@RequestParam(required=false) String id) {
		FiFinanceAccount entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiFinanceAccountService.get(id);
		}
		if (entity == null){
			entity = new FiFinanceAccount();
		}
		return entity;
	}
	
	/**
	 * 结算账户列表页面
	 */
	@RequiresPermissions("fi:fiFinanceAccount:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiFinanceAccount fiFinanceAccount, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiFinanceAccount> page = fiFinanceAccountService.findPage(new Page<FiFinanceAccount>(request, response), fiFinanceAccount); 
		model.addAttribute("page", page);
		return "modules/fi/fiFinanceAccountList";
	}
	
	@RequestMapping(value = "list2")
	public String list2(FiFinanceAccount fiFinanceAccount, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiFinanceAccount> page = fiFinanceAccountService.findPage(new Page<FiFinanceAccount>(request, response), fiFinanceAccount); 
		model.addAttribute("page", page);
		return "modules/fi/fiFinanceAccountList2";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="fi:fiFinanceAccount:view")
	@RequestMapping(value = "view")
	public String view(FiFinanceAccount fiFinanceAccount, Model model) {
		model.addAttribute("fiFinanceAccount", fiFinanceAccount);
		return "modules/fi/fiFinanceAccountView";
	}
	
	/**
	 * 查看，增加，编辑结算账户表单页面
	 */
	@RequiresPermissions(value={"fi:fiFinanceAccount:view","fi:fiFinanceAccount:add","fi:fiFinanceAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiFinanceAccount fiFinanceAccount, Model model) {
		
		if(fiFinanceAccount.getIsNewRecord()){
			fiFinanceAccount.setBalance(BigDecimal.ZERO);
			fiFinanceAccount.setIsDefault("0");
			fiFinanceAccount.setStatus("0");
		}
		
		model.addAttribute("fiFinanceAccount", fiFinanceAccount);
		return "modules/fi/fiFinanceAccountForm";
	}

	/**
	 * 保存结算账户
	 */
	@RequiresPermissions(value={"fi:fiFinanceAccount:add","fi:fiFinanceAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiFinanceAccount fiFinanceAccount, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiFinanceAccount)){
			return form(fiFinanceAccount, model);
		}
		
		try{
		
			if(!fiFinanceAccount.getIsNewRecord()){//编辑表单保存				
				FiFinanceAccount t = fiFinanceAccountService.get(fiFinanceAccount.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiFinanceAccount, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiFinanceAccountService.save(t);//保存
			}else{//新增表单保存
				fiFinanceAccountService.save(fiFinanceAccount);//保存
			}
			addMessage(redirectAttributes, "保存结算账户成功");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存结算账户失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
		}
	}
	
	/**
	 * 删除结算账户
	 */
	@RequiresPermissions("fi:fiFinanceAccount:del")
	@RequestMapping(value = "delete")
	public String delete(FiFinanceAccount fiFinanceAccount, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
		}
		if("1".equals(fiFinanceAccount.getIsDefault())){
			addMessage(redirectAttributes, "默认结算账户，不允许删除！");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
		}
		fiFinanceAccountService.delete(fiFinanceAccount);
		addMessage(redirectAttributes, "删除结算账户成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
	}
	
	/**
	 * 批量删除结算账户
	 */
	@RequiresPermissions("fi:fiFinanceAccount:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiFinanceAccountService.delete(fiFinanceAccountService.get(id));
		}
		addMessage(redirectAttributes, "删除结算账户成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiFinanceAccount:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiFinanceAccount fiFinanceAccount, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "结算账户"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiFinanceAccount> page = fiFinanceAccountService.findPage(new Page<FiFinanceAccount>(request, response, -1), fiFinanceAccount);
    		new ExportExcel("结算账户", FiFinanceAccount.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出结算账户记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiFinanceAccount:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiFinanceAccount> list = ei.getDataList(FiFinanceAccount.class);
			for (FiFinanceAccount fiFinanceAccount : list){
				try{
					fiFinanceAccountService.save(fiFinanceAccount);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条结算账户记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条结算账户记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入结算账户失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
    }
	
	/**
	 * 下载导入结算账户数据模板
	 */
	@RequiresPermissions("fi:fiFinanceAccount:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "结算账户数据导入模板.xlsx";
    		List<FiFinanceAccount> list = Lists.newArrayList(); 
    		new ExportExcel("结算账户数据", FiFinanceAccount.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceAccount/?repage";
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
	public String selectList(FiFinanceAccount fiAccount, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		fiAccount.setStatus("0");
        list(fiAccount, request, response, model);
        return "modules/fi/fiFinanceAccountSelectList";
	}
	
	/**
	 * 获取下拉菜单数据
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getSelectData")
	public String getSelectData(){
		List<FiFinanceAccount> list = fiFinanceAccountService.findList(new FiFinanceAccount());		
		String json = JsonMapper.getInstance().toJson(list);
		return json;
	}
	
}