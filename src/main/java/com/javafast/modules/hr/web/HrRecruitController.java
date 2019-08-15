package com.javafast.modules.hr.web;

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

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrRecruit;
import com.javafast.modules.hr.service.HrRecruitService;

/**
 * 招聘任务Controller
 * @author javafast
 * @version 2018-06-29
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrRecruit")
public class HrRecruitController extends BaseController {

	@Autowired
	private HrRecruitService hrRecruitService;
	
	@ModelAttribute
	public HrRecruit get(@RequestParam(required=false) String id) {
		HrRecruit entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrRecruitService.get(id);
		}
		if (entity == null){
			entity = new HrRecruit();
		}
		return entity;
	}
	
	/**
	 * 招聘任务列表页面
	 */
	@RequiresPermissions("hr:hrRecruit:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrRecruit hrRecruit, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrRecruit> page = hrRecruitService.findPage(new Page<HrRecruit>(request, response), hrRecruit); 
		model.addAttribute("page", page);
		return "modules/hr/hrRecruitList";
	}

	/**
	 * 编辑招聘任务表单页面
	 */
	@RequiresPermissions(value={"hr:hrRecruit:view","hr:hrRecruit:add","hr:hrRecruit:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrRecruit hrRecruit, Model model) {
		model.addAttribute("hrRecruit", hrRecruit);
		return "modules/hr/hrRecruitForm";
	}
	
	/**
	 * 查看招聘任务页面
	 */
	@RequiresPermissions(value="hr:hrRecruit:view")
	@RequestMapping(value = "view")
	public String view(HrRecruit hrRecruit, Model model) {
		model.addAttribute("hrRecruit", hrRecruit);
		return "modules/hr/hrRecruitView";
	}

	/**
	 * 保存招聘任务
	 */
	@RequiresPermissions(value={"hr:hrRecruit:add","hr:hrRecruit:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrRecruit hrRecruit, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrRecruit)){
			return form(hrRecruit, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
		}
		
		try{
		
			if(!hrRecruit.getIsNewRecord()){//编辑表单保存				
				HrRecruit t = hrRecruitService.get(hrRecruit.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrRecruit, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrRecruitService.save(t);//保存
			}else{
				//新增表单保存
				hrRecruit.setStatus("0");
				hrRecruitService.save(hrRecruit);//保存
			}
			addMessage(redirectAttributes, "保存招聘任务成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存招聘任务失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
		}
	}
	
	/**
	 * 删除招聘任务
	 */
	@RequiresPermissions("hr:hrRecruit:del")
	@RequestMapping(value = "delete")
	public String delete(HrRecruit hrRecruit, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
		}
		hrRecruitService.delete(hrRecruit);
		addMessage(redirectAttributes, "删除招聘任务成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
	}
	
	/**
	 * 批量删除招聘任务
	 */
	@RequiresPermissions("hr:hrRecruit:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrRecruitService.delete(hrRecruitService.get(id));
		}
		addMessage(redirectAttributes, "删除招聘任务成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrRecruit:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrRecruit hrRecruit, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "招聘任务"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrRecruit> page = hrRecruitService.findPage(new Page<HrRecruit>(request, response, -1), hrRecruit);
    		new ExportExcel("招聘任务", HrRecruit.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出招聘任务记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrRecruit:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrRecruit> list = ei.getDataList(HrRecruit.class);
			for (HrRecruit hrRecruit : list){
				try{
					hrRecruitService.save(hrRecruit);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条招聘任务记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条招聘任务记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入招聘任务失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
    }
	
	/**
	 * 下载导入招聘任务数据模板
	 */
	@RequiresPermissions("hr:hrRecruit:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "招聘任务数据导入模板.xlsx";
    		List<HrRecruit> list = Lists.newArrayList(); 
    		new ExportExcel("招聘任务数据", HrRecruit.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrRecruit/?repage";
    }
	
	/**
	 * 招聘任务列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrRecruit hrRecruit, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrRecruit, request, response, model);
        return "modules/hr/hrRecruitSelectList";
	}

	/**
	 * 获取下拉菜单数据
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getSelectData")
	public String getSelectData(){
		List<HrRecruit> list = hrRecruitService.findList(new HrRecruit());		
		String json = JsonMapper.getInstance().toJson(list);
		return json;
	}
}