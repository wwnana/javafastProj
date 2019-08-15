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

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
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
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonExtra;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonExtraService;

/**
 * 加班单Controller
 * @author javafast
 * @version 2017-08-26
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommonExtra")
public class OaCommonExtraController extends BaseController {

	@Autowired
	private OaCommonExtraService oaCommonExtraService;
	
	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@ModelAttribute
	public OaCommonExtra get(@RequestParam(required=false) String id) {
		OaCommonExtra entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommonExtraService.get(id);
		}
		if (entity == null){
			entity = new OaCommonExtra();
		}
		return entity;
	}
	
	/**
	 * 加班单列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(OaCommonExtra oaCommonExtra, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommonExtra> page = oaCommonExtraService.findPage(new Page<OaCommonExtra>(request, response), oaCommonExtra); 
		model.addAttribute("page", page);
		return "modules/oa/oaCommonExtraList";
	}

	/**
	 * 编辑加班单表单页面
	 */
	@RequestMapping(value = "form")
	public String form(OaCommonExtra oaCommonExtra, Model model) {
		model.addAttribute("oaCommonExtra", oaCommonExtra);
		return "modules/oa/oaCommonExtraForm";
	}
	
	/**
	 * 查看加班单页面
	 */
	@RequestMapping(value = "view")
	public String view(OaCommonExtra oaCommonExtra, Model model) {
		model.addAttribute("oaCommonExtra", oaCommonExtra);
		return "modules/oa/oaCommonExtraView";
	}

	/**
	 * 保存加班单
	 */
	@RequestMapping(value = "save")
	public String save(OaCommonExtra oaCommonExtra, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, oaCommonExtra)){
			return form(oaCommonExtra, model);
		}
		
		try{
		
			if(!oaCommonExtra.getIsNewRecord()){//编辑表单保存				
				OaCommonExtra t = oaCommonExtraService.get(oaCommonExtra.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaCommonExtra, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaCommonExtraService.save(t);//保存
			}else{//新增表单保存
				oaCommonExtraService.save(oaCommonExtra);//保存
				
				//获取审批主体
				OaCommonAudit oaCommonAudit = oaCommonAuditService.get(oaCommonExtra.getId());
				
				//通知下一审批人
				oaCommonAuditService.sendMsgToAuditUser(oaCommonAudit);
				
				//通知查阅用户
				oaCommonAuditService.sendMsgToReadUser(oaCommonAudit);
			}
			addMessage(redirectAttributes, "保存加班单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存加班单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
		}
	}
	
	/**
	 * 删除加班单
	 */
	@RequestMapping(value = "delete")
	public String delete(OaCommonExtra oaCommonExtra, RedirectAttributes redirectAttributes) {
		oaCommonExtraService.delete(oaCommonExtra);
		addMessage(redirectAttributes, "删除加班单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonAudit/?repage";
	}
	
	/**
	 * 批量删除加班单
	 */
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaCommonExtraService.delete(oaCommonExtraService.get(id));
		}
		addMessage(redirectAttributes, "删除加班单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExtra/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaCommonAudit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaCommonExtra oaCommonExtra, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "加班单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaCommonExtra> page = oaCommonExtraService.findPage(new Page<OaCommonExtra>(request, response, -1), oaCommonExtra);
    		new ExportExcel("加班单", OaCommonExtra.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出加班单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExtra/?repage";
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
			List<OaCommonExtra> list = ei.getDataList(OaCommonExtra.class);
			for (OaCommonExtra oaCommonExtra : list){
				try{
					oaCommonExtraService.save(oaCommonExtra);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条加班单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条加班单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入加班单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExtra/?repage";
    }
	
	/**
	 * 下载导入加班单数据模板
	 */
	@RequiresPermissions("oa:oaCommonAudit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "加班单数据导入模板.xlsx";
    		List<OaCommonExtra> list = Lists.newArrayList(); 
    		new ExportExcel("加班单数据", OaCommonExtra.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommonExtra/?repage";
    }
	
	/**
	 * 加班单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaCommonExtra oaCommonExtra, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaCommonExtra, request, response, model);
        return "modules/oa/oaCommonExtraSelectList";
	}
	
}