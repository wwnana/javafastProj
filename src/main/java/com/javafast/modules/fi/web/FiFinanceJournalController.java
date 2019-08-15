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
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.fi.entity.FiFinanceJournal;
import com.javafast.modules.fi.service.FiFinanceJournalService;

/**
 * 资金流水Controller
 * @author javafast
 * @version 2017-07-16
 */
@Controller
@RequestMapping(value = "${adminPath}/fi/fiFinanceJournal")
public class FiFinanceJournalController extends BaseController {

	@Autowired
	private FiFinanceJournalService fiFinanceJournalService;
	
	@ModelAttribute
	public FiFinanceJournal get(@RequestParam(required=false) String id) {
		FiFinanceJournal entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiFinanceJournalService.get(id);
		}
		if (entity == null){
			entity = new FiFinanceJournal();
		}
		return entity;
	}
	
	/**
	 * 资金流水列表页面
	 */
	@RequiresPermissions("fi:fiFinanceJournal:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiFinanceJournal fiFinanceJournal, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<FiFinanceJournal> page = fiFinanceJournalService.findPage(new Page<FiFinanceJournal>(request, response), fiFinanceJournal); 
		model.addAttribute("page", page);
		return "modules/fi/fiFinanceJournalList";
	}

	/**
	 * 编辑资金流水资金流水表单页面
	 */
	@RequiresPermissions(value={"fi:fiFinanceJournal:view","fi:fiFinanceJournal:add","fi:fiFinanceJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiFinanceJournal fiFinanceJournal, Model model) {
		model.addAttribute("fiFinanceJournal", fiFinanceJournal);
		return "modules/fi/fiFinanceJournalForm";
	}
	
	/**
	 * 查看资金流水页面
	 */
	@RequiresPermissions(value="fi:fiFinanceJournal:view")
	@RequestMapping(value = "view")
	public String view(FiFinanceJournal fiFinanceJournal, Model model) {
		model.addAttribute("fiFinanceJournal", fiFinanceJournal);
		return "modules/fi/fiFinanceJournalView";
	}

	/**
	 * 保存资金流水
	 */
	@RequiresPermissions(value={"fi:fiFinanceJournal:add","fi:fiFinanceJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiFinanceJournal fiFinanceJournal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiFinanceJournal)){
			return form(fiFinanceJournal, model);
		}
		
		try{
		
			if(!fiFinanceJournal.getIsNewRecord()){//编辑表单保存				
				FiFinanceJournal t = fiFinanceJournalService.get(fiFinanceJournal.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiFinanceJournal, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiFinanceJournalService.save(t);//保存
			}else{//新增表单保存
				fiFinanceJournalService.save(fiFinanceJournal);//保存
			}
			addMessage(redirectAttributes, "保存资金流水成功");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存资金流水失败");
			return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
		}
	}
	
	/**
	 * 删除资金流水
	 */
	@RequiresPermissions("fi:fiFinanceJournal:del")
	@RequestMapping(value = "delete")
	public String delete(FiFinanceJournal fiFinanceJournal, RedirectAttributes redirectAttributes) {
		fiFinanceJournalService.delete(fiFinanceJournal);
		addMessage(redirectAttributes, "删除资金流水成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
	}
	
	/**
	 * 批量删除资金流水
	 */
	@RequiresPermissions("fi:fiFinanceJournal:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			fiFinanceJournalService.delete(fiFinanceJournalService.get(id));
		}
		addMessage(redirectAttributes, "删除资金流水成功");
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("fi:fiFinanceJournal:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(FiFinanceJournal fiFinanceJournal, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "资金流水"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<FiFinanceJournal> page = fiFinanceJournalService.findPage(new Page<FiFinanceJournal>(request, response, -1), fiFinanceJournal);
    		new ExportExcel("资金流水", FiFinanceJournal.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出资金流水记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("fi:fiFinanceJournal:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<FiFinanceJournal> list = ei.getDataList(FiFinanceJournal.class);
			for (FiFinanceJournal fiFinanceJournal : list){
				try{
					fiFinanceJournalService.save(fiFinanceJournal);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条资金流水记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条资金流水记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入资金流水失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
    }
	
	/**
	 * 下载导入资金流水数据模板
	 */
	@RequiresPermissions("fi:fiFinanceJournal:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "资金流水数据导入模板.xlsx";
    		List<FiFinanceJournal> list = Lists.newArrayList(); 
    		new ExportExcel("资金流水数据", FiFinanceJournal.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/fi/fiFinanceJournal/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(FiFinanceJournal fiFinanceJournal, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(fiFinanceJournal, request, response, model);
        return "modules/fiFinanceJournalSelectList";
	}
	
	

}