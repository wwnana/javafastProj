/**
 * Copyright 2015-2020
 */
package com.javafast.modules.kms.web;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.kms.entity.KmsArticle;
import com.javafast.modules.kms.entity.KmsCategory;
import com.javafast.modules.kms.entity.KmsComment;
import com.javafast.modules.kms.service.KmsArticleService;
import com.javafast.modules.kms.service.KmsCategoryService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 知识Controller
 * @author javafast
 * @version 2017-08-03
 */
@Controller
@RequestMapping(value = "${adminPath}/kms/kmsArticle")
public class KmsArticleController extends BaseController {

	@Autowired
	private KmsArticleService kmsArticleService;
	
	@Autowired
	private KmsCategoryService kmsCategoryService;
	
	@ModelAttribute
	public KmsArticle get(@RequestParam(required=false) String id) {
		KmsArticle entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = kmsArticleService.get(id);
		}
		if (entity == null){
			entity = new KmsArticle();
		}
		return entity;
	}
	
	/**
	 * 知识列表页面
	 */
	@RequiresPermissions("kms:kmsArticle:list")
	@RequestMapping(value = {"index", ""})
	public String index(KmsArticle kmsArticle, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/kms/kmsArticleIndex";
	}
	
	/**
	 * 知识列表页面
	 */
	@RequiresPermissions("kms:kmsArticle:list")
	@RequestMapping(value = "list")
	public String list(KmsArticle kmsArticle, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		if(StringUtils.isBlank(kmsArticle.getStatus())){
			kmsArticle.setStatus("1");
		}else{
			if("0".equals(kmsArticle.getStatus())){
				kmsArticle.setCreateBy(UserUtils.getUser());
			}
		}
		
		Page<KmsArticle> page = kmsArticleService.findPage(new Page<KmsArticle>(request, response), kmsArticle); 
		model.addAttribute("page", page);
		return "modules/kms/kmsArticleList";
	}

	/**
	 * 编辑知识表单页面
	 */
	@RequiresPermissions(value={"kms:kmsArticle:view","kms:kmsArticle:add","kms:kmsArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(KmsArticle kmsArticle, Model model) {
		
		if(kmsArticle.getIsNewRecord()){
			
			if(kmsArticle.getKmsCategory() != null && kmsArticle.getKmsCategory().getId() != null){
				KmsCategory kmsCategory = kmsCategoryService.get(kmsArticle.getKmsCategory().getId());
				kmsArticle.setKmsCategory(kmsCategory);
			}
		}
		model.addAttribute("kmsArticle", kmsArticle);
		return "modules/kms/kmsArticleForm";
	}
	
	/**
	 * 查看知识页面
	 */
	@RequiresPermissions(value="kms:kmsArticle:view")
	@RequestMapping(value = "view")
	public String view(KmsArticle kmsArticle, Model model) {
		
		kmsArticle = kmsArticleService.get(kmsArticle.getId());//从数据库取出记录的值
		if(kmsArticle.getHits() == null)
			kmsArticle.setHits(0);
		kmsArticle.setHits(kmsArticle.getHits() + 1);
		kmsArticleService.save(kmsArticle);//保存
		
		model.addAttribute("kmsArticle", kmsArticle);
		
		KmsComment kmsComment = new KmsComment();
		kmsComment.setArticleId(kmsArticle.getId());
		model.addAttribute("kmsComment", kmsComment);
		return "modules/kms/kmsArticleView";
	}

	/**
	 * 保存知识
	 */
	@RequiresPermissions(value={"kms:kmsArticle:add","kms:kmsArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(KmsArticle kmsArticle, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, kmsArticle)){
			return form(kmsArticle, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsArticle/list?repage";
		}
		
		try{
		
			System.out.println(kmsArticle.getStatus());
			if(!kmsArticle.getIsNewRecord()){//编辑表单保存				
				KmsArticle t = kmsArticleService.get(kmsArticle.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(kmsArticle, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				kmsArticleService.save(t);//保存
			}else{//新增表单保存
				
				kmsArticle.setHits(0);
				kmsArticleService.save(kmsArticle);//保存
			}
			addMessage(redirectAttributes, "保存知识成功");
			return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/view?id="+kmsArticle.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存知识失败");
			return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
		}
	}
	
	/**
	 * 删除知识
	 */
	@RequiresPermissions("kms:kmsArticle:del")
	@RequestMapping(value = "delete")
	public String delete(KmsArticle kmsArticle, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsArticle/?repage";
		}
		kmsArticleService.delete(kmsArticle);
		addMessage(redirectAttributes, "删除知识成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
	}
	
	/**
	 * 批量删除知识
	 */
	@RequiresPermissions("kms:kmsArticle:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsArticle/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			kmsArticleService.delete(kmsArticleService.get(id));
		}
		addMessage(redirectAttributes, "删除知识成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("kms:kmsArticle:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(KmsArticle kmsArticle, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "知识"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<KmsArticle> page = kmsArticleService.findPage(new Page<KmsArticle>(request, response, -1), kmsArticle);
    		new ExportExcel("知识", KmsArticle.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出知识记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("kms:kmsArticle:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<KmsArticle> list = ei.getDataList(KmsArticle.class);
			for (KmsArticle kmsArticle : list){
				try{
					kmsArticleService.save(kmsArticle);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条知识记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条知识记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入知识失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
    }
	
	/**
	 * 下载导入知识数据模板
	 */
	@RequiresPermissions("kms:kmsArticle:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "知识数据导入模板.xlsx";
    		List<KmsArticle> list = Lists.newArrayList(); 
    		new ExportExcel("知识数据", KmsArticle.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/?repage";
    }
	
	/**
	 * 知识列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(KmsArticle kmsArticle, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(kmsArticle, request, response, model);
        return "modules/kms/kmsArticleSelectList";
	}
	
	/**
	 * 审核知识
	 */
	@RequiresPermissions("kms:kmsArticle:audit")
	@RequestMapping(value = "audit")
	public String audit(KmsArticle kmsArticle, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsArticle/?repage";
		}
		KmsArticle t = kmsArticleService.get(kmsArticle.getId());//从数据库取出记录的值		
		kmsArticleService.audit(t);
		addMessage(redirectAttributes, "发布成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/view?id="+kmsArticle.getId();
	}
	
	/**
	 * 反审核知识
	 */
	@RequiresPermissions("kms:kmsArticle:audit")
	@RequestMapping(value = "unAudit")
	public String unAudit(KmsArticle kmsArticle, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/kms/kmsArticle/?repage";
		}
		KmsArticle t = kmsArticleService.get(kmsArticle.getId());//从数据库取出记录的值		
		kmsArticleService.unAudit(t);
		addMessage(redirectAttributes, "撤销成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/view?id="+kmsArticle.getId();
	}
}