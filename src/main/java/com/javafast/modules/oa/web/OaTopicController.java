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

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;
import com.google.common.collect.Lists;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaTopic;
import com.javafast.modules.oa.entity.OaTopicRecord;
import com.javafast.modules.oa.service.OaTopicService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 话题Controller
 * @author javafast
 * @version 2018-06-12
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaTopic")
public class OaTopicController extends BaseController {

	@Autowired
	private OaTopicService oaTopicService;
	
	@ModelAttribute
	public OaTopic get(@RequestParam(required=false) String id) {
		OaTopic entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaTopicService.get(id);
		}
		if (entity == null){
			entity = new OaTopic();
		}
		return entity;
	}
	
	/**
	 * 话题列表页面
	 */
	@RequiresPermissions("oa:oaTopic:list")
	@RequestMapping(value = {"list", ""})
	public String list(OaTopic oaTopic, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaTopic> page = oaTopicService.findPage(new Page<OaTopic>(request, response), oaTopic); 
		model.addAttribute("page", page);
		return "modules/oa/oaTopicList";
	}

	/**
	 * 编辑话题表单页面
	 */
	@RequiresPermissions("oa:oaTopic:list")
	@RequestMapping(value = "form")
	public String form(OaTopic oaTopic, Model model) {
		model.addAttribute("oaTopic", oaTopic);
		return "modules/oa/oaTopicForm";
	}
	
	/**
	 * 查看话题页面
	 */
	@RequiresPermissions("oa:oaTopic:list")
	@RequestMapping(value = "view")
	public String view(OaTopic oaTopic, Model model) {
		model.addAttribute("oaTopic", oaTopic);
		return "modules/oa/oaTopicView";
	}

	/**
	 * 保存话题
	 */
	@RequiresPermissions("oa:oaTopic:list")
	@RequestMapping(value = "save")
	public String save(OaTopic oaTopic, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaTopic)){
			return form(oaTopic, model);
		}
		
		try{
		
			if(!oaTopic.getIsNewRecord()){//编辑表单保存				
				OaTopic t = oaTopicService.get(oaTopic.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(oaTopic, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				oaTopicService.save(t);//保存
			}else{//新增表单保存
				oaTopicService.save(oaTopic);//保存
			}
			addMessage(redirectAttributes, "保存话题成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存话题失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
		}
	}
	
	/**
	 * 删除话题
	 */
	@RequiresPermissions("oa:oaTopic:list")
	@RequestMapping(value = "delete")
	public String delete(OaTopic oaTopic, RedirectAttributes redirectAttributes) {
		oaTopicService.delete(oaTopic);
		addMessage(redirectAttributes, "删除话题成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
	}
	
	/**
	 * 批量删除话题
	 */
	@RequiresPermissions("oa:oaTopic:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			oaTopicService.delete(oaTopicService.get(id));
		}
		addMessage(redirectAttributes, "删除话题成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("oa:oaTopic:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OaTopic oaTopic, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "话题"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OaTopic> page = oaTopicService.findPage(new Page<OaTopic>(request, response, -1), oaTopic);
    		new ExportExcel("话题", OaTopic.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出话题记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("oa:oaTopic:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OaTopic> list = ei.getDataList(OaTopic.class);
			for (OaTopic oaTopic : list){
				try{
					oaTopicService.save(oaTopic);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条话题记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条话题记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入话题失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
    }
	
	/**
	 * 下载导入话题数据模板
	 */
	@RequiresPermissions("oa:oaTopic:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "话题数据导入模板.xlsx";
    		List<OaTopic> list = Lists.newArrayList(); 
    		new ExportExcel("话题数据", OaTopic.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/?repage";
    }
	
	/**
	 * 话题列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OaTopic oaTopic, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(oaTopic, request, response, model);
        return "modules/oa/oaTopicSelectList";
	}
	
	/**
	 * 发表讨论
	 * @param oaTopic
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "addOaTopicRecord")
	public String addOaTopicRecord(OaTopic oaTopic, Model model, RedirectAttributes redirectAttributes) {
		
		try {
			
			OaTopicRecord oaTopicRecord = new OaTopicRecord();
			oaTopicRecord.setOaTopic(oaTopic);
			oaTopicRecord.setNotes(oaTopic.getNotes());
			oaTopicRecord.setUser(UserUtils.getUser());
			oaTopicService.saveOaTopicRecord(oaTopicRecord);
		} catch (Exception e) {
			addMessage(redirectAttributes, "评论失败：");
		}
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/view?id="+oaTopic.getId();
	}
	
	/**
	 * 点赞
	 * @param id
	 * @param recordId
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "thumbOaTopicRecord")
	public String thumbOaTopicRecord(String id, String recordId, RedirectAttributes redirectAttributes) {
		
		oaTopicService.thumbOaTopicRecord(new OaTopicRecord(recordId));
		addMessage(redirectAttributes, "点赞成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/view?id="+id;
	}
	
	/**
	 * 删除讨论
	 * @param id
	 * @param recordId
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "deleteOaTopicRecord")
	public String deleteOaTopicRecord(String id, String recordId, RedirectAttributes redirectAttributes) {
		
		oaTopicService.deleteOaTopicRecord(new OaTopicRecord(recordId));
		addMessage(redirectAttributes, "删除讨论成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaTopic/view?id="+id;
	}
}