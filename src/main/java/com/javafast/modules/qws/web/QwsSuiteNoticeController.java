package com.javafast.modules.qws.web;

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
import com.javafast.modules.sys.entity.User;
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
import com.javafast.modules.qws.entity.QwsSuiteNotice;
import com.javafast.modules.qws.service.QwsSuiteNoticeService;

/**
 * 指令回调消息Controller
 * @author javafast
 * @version 2018-06-12
 */
@Controller
@RequestMapping(value = "${adminPath}/qws/qwsSuiteNotice")
public class QwsSuiteNoticeController extends BaseController {

	@Autowired
	private QwsSuiteNoticeService qwsSuiteNoticeService;
	
	@ModelAttribute
	public QwsSuiteNotice get(@RequestParam(required=false) String id) {
		QwsSuiteNotice entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = qwsSuiteNoticeService.get(id);
		}
		if (entity == null){
			entity = new QwsSuiteNotice();
		}
		return entity;
	}
	
	/**
	 * 指令回调消息列表页面
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = {"list", ""})
	public String list(QwsSuiteNotice qwsSuiteNotice, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<QwsSuiteNotice> page = qwsSuiteNoticeService.findPage(new Page<QwsSuiteNotice>(request, response), qwsSuiteNotice); 
		model.addAttribute("page", page);
		return "modules/qws/qwsSuiteNoticeList";
	}

	/**
	 * 编辑指令回调消息表单页面
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = "form")
	public String form(QwsSuiteNotice qwsSuiteNotice, Model model) {
		model.addAttribute("qwsSuiteNotice", qwsSuiteNotice);
		return "modules/qws/qwsSuiteNoticeForm";
	}
	
	/**
	 * 查看指令回调消息页面
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = "view")
	public String view(QwsSuiteNotice qwsSuiteNotice, Model model) {
		model.addAttribute("qwsSuiteNotice", qwsSuiteNotice);
		return "modules/qws/qwsSuiteNoticeView";
	}

	/**
	 * 保存指令回调消息
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = "save")
	public String save(QwsSuiteNotice qwsSuiteNotice, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, qwsSuiteNotice)){
			return form(qwsSuiteNotice, model);
		}
		
		try{
		
			if(!qwsSuiteNotice.getIsNewRecord()){//编辑表单保存				
				QwsSuiteNotice t = qwsSuiteNoticeService.get(qwsSuiteNotice.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(qwsSuiteNotice, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				qwsSuiteNoticeService.save(t);//保存
			}else{//新增表单保存
				qwsSuiteNoticeService.save(qwsSuiteNotice);//保存
			}
			addMessage(redirectAttributes, "保存指令回调消息成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存指令回调消息失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
		}
	}
	
	/**
	 * 删除指令回调消息
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = "delete")
	public String delete(QwsSuiteNotice qwsSuiteNotice, RedirectAttributes redirectAttributes) {
		qwsSuiteNoticeService.delete(qwsSuiteNotice);
		addMessage(redirectAttributes, "删除指令回调消息成功");
		return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
	}
	
	/**
	 * 批量删除指令回调消息
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			qwsSuiteNoticeService.delete(qwsSuiteNoticeService.get(id));
		}
		addMessage(redirectAttributes, "删除指令回调消息成功");
		return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(QwsSuiteNotice qwsSuiteNotice, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "指令回调消息"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<QwsSuiteNotice> page = qwsSuiteNoticeService.findPage(new Page<QwsSuiteNotice>(request, response, -1), qwsSuiteNotice);
    		new ExportExcel("指令回调消息", QwsSuiteNotice.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出指令回调消息记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<QwsSuiteNotice> list = ei.getDataList(QwsSuiteNotice.class);
			for (QwsSuiteNotice qwsSuiteNotice : list){
				try{
					qwsSuiteNoticeService.save(qwsSuiteNotice);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条指令回调消息记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条指令回调消息记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入指令回调消息失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
    }
	
	/**
	 * 下载导入指令回调消息数据模板
	 */
	@RequiresPermissions("qws:qwsSuiteNotice:list")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "指令回调消息数据导入模板.xlsx";
    		List<QwsSuiteNotice> list = Lists.newArrayList(); 
    		new ExportExcel("指令回调消息数据", QwsSuiteNotice.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/qws/qwsSuiteNotice/?repage";
    }
	
	/**
	 * 指令回调消息列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(QwsSuiteNotice qwsSuiteNotice, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(qwsSuiteNotice, request, response, model);
        return "modules/qws/qwsSuiteNoticeSelectList";
	}
	
}