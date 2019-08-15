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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.kms.entity.KmsComment;
import com.javafast.modules.kms.service.KmsCommentService;

/**
 * 知识评论Controller
 * @author javafast
 * @version 2018-05-14
 */
@Controller
@RequestMapping(value = "${adminPath}/kms/kmsComment")
public class KmsCommentController extends BaseController {

	@Autowired
	private KmsCommentService kmsCommentService;
	
	@ModelAttribute
	public KmsComment get(@RequestParam(required=false) String id) {
		KmsComment entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = kmsCommentService.get(id);
		}
		if (entity == null){
			entity = new KmsComment();
		}
		return entity;
	}
	
	/**
	 * 知识评论列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(KmsComment kmsComment, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<KmsComment> page = kmsCommentService.findPage(new Page<KmsComment>(request, response), kmsComment); 
		model.addAttribute("page", page);
		return "modules/kms/kmsCommentList";
	}

	/**
	 * 编辑知识评论表单页面
	 */
	@RequestMapping(value = "form")
	public String form(KmsComment kmsComment, Model model) {
		model.addAttribute("kmsComment", kmsComment);
		return "modules/kms/kmsCommentForm";
	}
	
	/**
	 * 查看知识评论页面
	 */
	@RequestMapping(value = "view")
	public String view(KmsComment kmsComment, Model model) {
		model.addAttribute("kmsComment", kmsComment);
		return "modules/kms/kmsCommentView";
	}

	/**
	 * 保存知识评论
	 */
	@RequestMapping(value = "save")
	public String save(KmsComment kmsComment, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, kmsComment)){
			return form(kmsComment, model);
		}
		
		try{
		
			if(!kmsComment.getIsNewRecord()){//编辑表单保存				
				KmsComment t = kmsCommentService.get(kmsComment.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(kmsComment, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				kmsCommentService.save(t);//保存
			}else{//新增表单保存
				kmsCommentService.save(kmsComment);//保存
			}
			addMessage(redirectAttributes, "保存知识评论成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存知识评论失败");
		}finally{
//			return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
			return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/view?id="+kmsComment.getArticleId();
		}
	}
	
	/**
	 * 删除知识评论
	 */
	@RequestMapping(value = "delete")
	public String delete(KmsComment kmsComment, RedirectAttributes redirectAttributes) {
		
		String articleId = kmsComment.getArticleId();
		kmsCommentService.delete(kmsComment);
		addMessage(redirectAttributes, "删除知识评论成功");
//		return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
		return "redirect:"+Global.getAdminPath()+"/kms/kmsArticle/view?id="+articleId;
	}
	
	/**
	 * 批量删除知识评论
	 */
	@RequiresPermissions("kms:kmsComment:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			kmsCommentService.delete(kmsCommentService.get(id));
		}
		addMessage(redirectAttributes, "删除知识评论成功");
		return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("kms:kmsComment:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(KmsComment kmsComment, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "知识评论"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<KmsComment> page = kmsCommentService.findPage(new Page<KmsComment>(request, response, -1), kmsComment);
    		new ExportExcel("知识评论", KmsComment.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出知识评论记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("kms:kmsComment:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<KmsComment> list = ei.getDataList(KmsComment.class);
			for (KmsComment kmsComment : list){
				try{
					kmsCommentService.save(kmsComment);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条知识评论记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条知识评论记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入知识评论失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
    }
	
	/**
	 * 下载导入知识评论数据模板
	 */
	@RequiresPermissions("kms:kmsComment:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "知识评论数据导入模板.xlsx";
    		List<KmsComment> list = Lists.newArrayList(); 
    		new ExportExcel("知识评论数据", KmsComment.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/kms/kmsComment/?repage";
    }
	
	/**
	 * 知识评论列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(KmsComment kmsComment, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(kmsComment, request, response, model);
        return "modules/kms/kmsCommentSelectList";
	}
	
}