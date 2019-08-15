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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.fi.entity.FiPaymentAble;
import com.javafast.modules.fi.service.FiPaymentAbleService;

/**
 * 应付款Controller
 * @author javafast
 * @version 2017-07-17
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiPaymentAble")
public class FiPaymentAbleController extends BaseController {

	@Autowired
	private FiPaymentAbleService fiPaymentAbleService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@ModelAttribute
	public FiPaymentAble get(@RequestParam(required=false) String id) {
		FiPaymentAble entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiPaymentAbleService.get(id);
		}
		if (entity == null){
			entity = new FiPaymentAble();
		}
		return entity;
	}
	
	/**
	 * 应付款列表页面
	 */
	@RequiresPermissions("fi:fiPaymentAble:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiPaymentAble fiPaymentAble, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiPaymentAble> page = fiPaymentAbleService.findPage(new Page<FiPaymentAble>(request, response), fiPaymentAble); 
		model.addAttribute("page", page);
		return "modules/fi/fiPaymentAbleList";
	}

	/**
	 * 编辑应付款应付款表单页面
	 */
	@RequiresPermissions(value={"fi:fiPaymentAble:view","fi:fiPaymentAble:add","fi:fiPaymentAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiPaymentAble fiPaymentAble, Model model) {
		
		if(fiPaymentAble.getIsNewRecord()){
			fiPaymentAble.setNo("YF"+IdUtils.getId());
		}
		if(fiPaymentAble.getOwnBy() == null){
			fiPaymentAble.setOwnBy(UserUtils.getUser());
		}
		if(fiPaymentAble.getStatus() == null){
			fiPaymentAble.setStatus("0");
		}
		model.addAttribute("fiPaymentAble", fiPaymentAble);
		return "modules/fi/fiPaymentAbleForm";
	}
	
	/**
	 * 编辑
	 */
	@RequiresPermissions(value={"fi:fiPaymentAble:view","fi:fiPaymentAble:add","fi:fiPaymentAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "editForm")
	public String editForm(FiPaymentAble fiPaymentAble, Model model) {
		
		if(fiPaymentAble.getIsNewRecord()){
			fiPaymentAble.setNo("YF"+IdUtils.getId());
		}
		if(fiPaymentAble.getOwnBy() == null){
			fiPaymentAble.setOwnBy(UserUtils.getUser());
		}
		if(fiPaymentAble.getStatus() == null){
			fiPaymentAble.setStatus("0");
		}
		model.addAttribute("fiPaymentAble", fiPaymentAble);
		return "modules/fi/fiPaymentAbleEditForm";
	}
	
	/**
	 * 查看应付款页面
	 */
	@RequiresPermissions(value="fi:fiPaymentAble:view")
	@RequestMapping(value = "view")
	public String view(FiPaymentAble fiPaymentAble, Model model) {
		model.addAttribute("fiPaymentAble", fiPaymentAble);
		return "modules/fi/fiPaymentAbleView";
	}

	/**
	 * 保存应付款
	 */
	@RequiresPermissions(value={"fi:fiPaymentAble:add","fi:fiPaymentAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiPaymentAble fiPaymentAble, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiPaymentAble)){
			return form(fiPaymentAble, model);
		}
		
		try{
		
			if(!fiPaymentAble.getIsNewRecord()){//编辑表单保存				
				FiPaymentAble t = fiPaymentAbleService.get(fiPaymentAble.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiPaymentAble, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiPaymentAbleService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_PAYMENTABLE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), null);
			}else{//新增表单保存
				fiPaymentAbleService.save(fiPaymentAble);//保存
			}
			addMessage(redirectAttributes, "保存应付款成功");
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/index?id="+fiPaymentAble.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存应付款失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
		}
	}
	
	/**
	 * 删除应付款
	 */
	@RequiresPermissions("fi:fiPaymentAble:del")
	@RequestMapping(value = "delete")
	public String delete(FiPaymentAble fiPaymentAble, RedirectAttributes redirectAttributes) {
		fiPaymentAbleService.delete(fiPaymentAble);
		addMessage(redirectAttributes, "删除应付款成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
	}
	
	/**
	 * 批量删除应付款
	 */
	@RequiresPermissions("fi:fiPaymentAble:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiPaymentAbleService.delete(fiPaymentAbleService.get(id));
		}
		addMessage(redirectAttributes, "删除应付款成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiPaymentAble:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiPaymentAble fiPaymentAble, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "应付款"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiPaymentAble> page = fiPaymentAbleService.findPage(new Page<FiPaymentAble>(request, response, -1), fiPaymentAble);
    		new ExportExcel("应付款", FiPaymentAble.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出应付款记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiPaymentAble:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiPaymentAble> list = ei.getDataList(FiPaymentAble.class);
			for (FiPaymentAble fiPaymentAble : list){
				try{
					fiPaymentAbleService.save(fiPaymentAble);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条应付款记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条应付款记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入应付款失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
    }
	
	/**
	 * 下载导入应付款数据模板
	 */
	@RequiresPermissions("fi:fiPaymentAble:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "应付款数据导入模板.xlsx";
    		List<FiPaymentAble> list = Lists.newArrayList(); 
    		new ExportExcel("应付款数据", FiPaymentAble.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiPaymentAble/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(FiPaymentAble fiPaymentAble, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(fiPaymentAble, request, response, model);
        return "modules/fi/fiPaymentAbleSelectList";
	}
	
	@RequiresPermissions(value="fi:fiPaymentAble:view")
	@RequestMapping(value = "index")
	public String index(FiPaymentAble fiPaymentAble, Model model) {
		
		model.addAttribute("fiPaymentAble", fiPaymentAble);
		
		//查询日志
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_FI_TYPE_PAYMENTABLE, fiPaymentAble.getId()));
		model.addAttribute("sysDynamicList", sysDynamicList);
		return "modules/fi/fiPaymentAbleIndex";
	}
}