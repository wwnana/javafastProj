/**
 * Copyright 2015-2020
 */
package com.javafast.modules.oa.web;

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

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonBorrow;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonBorrowService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 借款单Controller
 * @author javafast
 * @version 2017-08-25
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonBorrow")
public class OaCommonBorrowController extends BaseController {

	@Autowired
	private OaCommonBorrowService oaCommonBorrowService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@ModelAttribute
	public OaCommonBorrow get(@RequestParam(required=false) String id) {
		OaCommonBorrow entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonBorrowService.get(id);
		}
		if (entity == null){
			entity = new OaCommonBorrow();
		}
		return entity;
	}
	
	/**
	 * 借款单列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonBorrow oaCommonBorrow, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommonBorrow> page = oaCommonBorrowService.findPage(new Page<OaCommonBorrow>(request, response), oaCommonBorrow); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonBorrowList";
	}

	/**
	 * 编辑借款单表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaCommonBorrow oaCommonBorrow, Model model) {
		model.addAttribute("oaCommonBorrow", oaCommonBorrow);
		return "modules/oa/oaCommonBorrowForm";
	}
	
	/**
	 * 查看借款单页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonBorrow oaCommonBorrow, Model model) {
		model.addAttribute("oaCommonBorrow", oaCommonBorrow);
		return "modules/oa/oaCommonBorrowView";
	}

	/**
	 * 提交借款单
	 */
	@RequestMapping(value = "save")
	public String save(OaCommonBorrow oaCommonBorrow, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, oaCommonBorrow)){
			return form(oaCommonBorrow, model);
		}
		
		try{
		
			if(!oaCommonBorrow.getIsNewRecord()){//编辑表单提交				
				OaCommonBorrow t = oaCommonBorrowService.get(oaCommonBorrow.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonBorrow, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonBorrowService.save(t);//提交
			}else{//新增表单提交
				
				oaCommonBorrowService.save(oaCommonBorrow);//提交
				
				//获取审批主体
				OaCommonAudit oaCommonAudit = oaCommonAuditService.get(oaCommonBorrow.getId());
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			addMessage(redirectAttributes, "提交借款单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交借款单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
		}
	}
	
	/**
	 * 删除借款单
	 */
	@RequestMapping(value = "delete")
	public String delete(OaCommonBorrow oaCommonBorrow, RedirectAttributes redirectAttributes) {
		oaCommonBorrowService.delete(oaCommonBorrow);
		addMessage(redirectAttributes, "删除借款单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
	}
	
	/**
	 * 批量删除借款单
	 */
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonBorrowService.delete(oaCommonBorrowService.get(id));
		}
		addMessage(redirectAttributes, "删除借款单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonBorrow/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonAudit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonBorrow oaCommonBorrow, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "借款单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonBorrow> page = oaCommonBorrowService.findPage(new Page<OaCommonBorrow>(request, response, -1), oaCommonBorrow);
    		new ExportExcel("借款单", OaCommonBorrow.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出借款单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonBorrow/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaCommonBorrow> list = ei.getDataList(OaCommonBorrow.class);
			for (OaCommonBorrow oaCommonBorrow : list){
				try{
					oaCommonBorrowService.save(oaCommonBorrow);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条借款单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条借款单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入借款单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonBorrow/?repage";
    }
	
	/**
	 * 下载导入借款单数据模板
	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "借款单数据导入模板.xlsx";
    		List<OaCommonBorrow> list = Lists.newArrayList(); 
    		new ExportExcel("借款单数据", OaCommonBorrow.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonBorrow/?repage";
    }
	
	/**
	 * 借款单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonBorrow oaCommonBorrow, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonBorrow, request, response, model);
        return "modules/oa/oaCommonBorrowSelectList";
	}
	
}