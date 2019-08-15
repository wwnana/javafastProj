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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
import com.javafast.modules.hr.entity.HrSalaryDetail;
import com.javafast.modules.hr.service.HrSalaryDetailService;

/**
 * 工资明细Controller
 * @author javafast
 * @version 2018-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrSalaryDetail")
public class HrSalaryDetailController extends BaseController {

	@Autowired
	private HrSalaryDetailService hrSalaryDetailService;
	
	@ModelAttribute
	public HrSalaryDetail get(@RequestParam(required=false) String id) {
		HrSalaryDetail entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrSalaryDetailService.get(id);
		}
		if (entity == null){
			entity = new HrSalaryDetail();
		}
		return entity;
	}
	
	/**
	 * 工资明细列表页面
	 */
	@RequiresPermissions("hr:hrSalary:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrSalaryDetail hrSalaryDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrSalaryDetail> page = hrSalaryDetailService.findPage(new Page<HrSalaryDetail>(request, response), hrSalaryDetail); 
		model.addAttribute("page", page);
		return "modules/hr/hrSalaryDetailList";
	}

	/**
	 * 编辑工资明细表单页面
	 */
	@RequiresPermissions(value={"hr:hrSalary:view","hr:hrSalary:add","hr:hrSalary:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrSalaryDetail hrSalaryDetail, Model model) {
		model.addAttribute("hrSalaryDetail", hrSalaryDetail);
		return "modules/hr/hrSalaryDetailForm";
	}
	
	/**
	 * 查看工资明细页面
	 */
	@RequiresPermissions(value="hr:hrSalary:view")
	@RequestMapping(value = "view")
	public String view(HrSalaryDetail hrSalaryDetail, Model model) {
		model.addAttribute("hrSalaryDetail", hrSalaryDetail);
		return "modules/hr/hrSalaryDetailView";
	}

	/**
	 * 保存工资明细
	 */
	@RequiresPermissions(value={"hr:hrSalary:add","hr:hrSalary:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrSalaryDetail hrSalaryDetail, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrSalaryDetail)){
			return form(hrSalaryDetail, model);
		}
		
		try{
		
			if(!hrSalaryDetail.getIsNewRecord()){//编辑表单保存				
				HrSalaryDetail t = hrSalaryDetailService.get(hrSalaryDetail.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrSalaryDetail, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrSalaryDetailService.save(t);//保存
			}else{//新增表单保存
				hrSalaryDetailService.save(hrSalaryDetail);//保存
			}
			addMessage(redirectAttributes, "保存工资明细成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存工资明细失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
		}
	}
	
	/**
	 * 删除工资明细
	 */
	@RequiresPermissions("hr:hrSalary:del")
	@RequestMapping(value = "delete")
	public String delete(HrSalaryDetail hrSalaryDetail, RedirectAttributes redirectAttributes) {
		hrSalaryDetailService.delete(hrSalaryDetail);
		addMessage(redirectAttributes, "删除工资明细成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
	}
	
	/**
	 * 批量删除工资明细
	 */
	@RequiresPermissions("hr:hrSalary:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrSalaryDetailService.delete(hrSalaryDetailService.get(id));
		}
		addMessage(redirectAttributes, "删除工资明细成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrSalary:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrSalaryDetail hrSalaryDetail, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工资明细"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrSalaryDetail> page = hrSalaryDetailService.findPage(new Page<HrSalaryDetail>(request, response, -1), hrSalaryDetail);
    		new ExportExcel("工资明细", HrSalaryDetail.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出工资明细记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrSalary:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrSalaryDetail> list = ei.getDataList(HrSalaryDetail.class);
			for (HrSalaryDetail hrSalaryDetail : list){
				try{
					hrSalaryDetailService.save(hrSalaryDetail);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条工资明细记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条工资明细记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入工资明细失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
    }
	
	/**
	 * 下载导入工资明细数据模板
	 */
	@RequiresPermissions("hr:hrSalary:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "工资明细数据导入模板.xlsx";
    		List<HrSalaryDetail> list = Lists.newArrayList(); 
    		new ExportExcel("工资明细数据", HrSalaryDetail.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrSalaryDetail/?repage";
    }
	
	/**
	 * 工资明细列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrSalaryDetail hrSalaryDetail, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrSalaryDetail, request, response, model);
        return "modules/hr/hrSalaryDetailSelectList";
	}
	
}