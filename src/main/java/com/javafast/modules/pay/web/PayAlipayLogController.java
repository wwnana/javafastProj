package com.javafast.modules.pay.web;

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
import com.javafast.modules.pay.entity.PayAlipayLog;
import com.javafast.modules.pay.service.PayAlipayLogService;

/**
 * 支付宝支付通知Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payAlipayLog")
public class PayAlipayLogController extends BaseController {

	@Autowired
	private PayAlipayLogService payAlipayLogService;
	
	@ModelAttribute
	public PayAlipayLog get(@RequestParam(required=false) String id) {
		PayAlipayLog entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payAlipayLogService.get(id);
		}
		if (entity == null){
			entity = new PayAlipayLog();
		}
		return entity;
	}
	
	/**
	 * 支付宝支付通知列表页面
	 */
	@RequiresPermissions("pay:payAlipayLog:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayAlipayLog payAlipayLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayAlipayLog> page = payAlipayLogService.findPage(new Page<PayAlipayLog>(request, response), payAlipayLog); 
		model.addAttribute("page", page);
		return "modules/pay/payAlipayLogList";
	}

	/**
	 * 编辑支付宝支付通知表单页面
	 */
	@RequiresPermissions(value={"pay:payAlipayLog:view","pay:payAlipayLog:add","pay:payAlipayLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayAlipayLog payAlipayLog, Model model) {
		model.addAttribute("payAlipayLog", payAlipayLog);
		return "modules/pay/payAlipayLogForm";
	}
	
	/**
	 * 查看支付宝支付通知页面
	 */
	@RequiresPermissions(value="pay:payAlipayLog:view")
	@RequestMapping(value = "view")
	public String view(PayAlipayLog payAlipayLog, Model model) {
		model.addAttribute("payAlipayLog", payAlipayLog);
		return "modules/pay/payAlipayLogView";
	}

	/**
	 * 保存支付宝支付通知
	 */
	@RequiresPermissions(value={"pay:payAlipayLog:add","pay:payAlipayLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayAlipayLog payAlipayLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payAlipayLog)){
			return form(payAlipayLog, model);
		}
		
		try{
		
			if(!payAlipayLog.getIsNewRecord()){//编辑表单保存				
				PayAlipayLog t = payAlipayLogService.get(payAlipayLog.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payAlipayLog, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payAlipayLogService.save(t);//保存
			}else{//新增表单保存
				payAlipayLogService.save(payAlipayLog);//保存
			}
			addMessage(redirectAttributes, "保存支付宝支付通知成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存支付宝支付通知失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
		}
	}
	
	/**
	 * 删除支付宝支付通知
	 */
	@RequiresPermissions("pay:payAlipayLog:del")
	@RequestMapping(value = "delete")
	public String delete(PayAlipayLog payAlipayLog, RedirectAttributes redirectAttributes) {
		payAlipayLogService.delete(payAlipayLog);
		addMessage(redirectAttributes, "删除支付宝支付通知成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
	}
	
	/**
	 * 批量删除支付宝支付通知
	 */
	@RequiresPermissions("pay:payAlipayLog:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payAlipayLogService.delete(payAlipayLogService.get(id));
		}
		addMessage(redirectAttributes, "删除支付宝支付通知成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payAlipayLog:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayAlipayLog payAlipayLog, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "支付宝支付通知"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayAlipayLog> page = payAlipayLogService.findPage(new Page<PayAlipayLog>(request, response, -1), payAlipayLog);
    		new ExportExcel("支付宝支付通知", PayAlipayLog.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出支付宝支付通知记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payAlipayLog:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayAlipayLog> list = ei.getDataList(PayAlipayLog.class);
			for (PayAlipayLog payAlipayLog : list){
				try{
					payAlipayLogService.save(payAlipayLog);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条支付宝支付通知记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条支付宝支付通知记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入支付宝支付通知失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
    }
	
	/**
	 * 下载导入支付宝支付通知数据模板
	 */
	@RequiresPermissions("pay:payAlipayLog:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "支付宝支付通知数据导入模板.xlsx";
    		List<PayAlipayLog> list = Lists.newArrayList(); 
    		new ExportExcel("支付宝支付通知数据", PayAlipayLog.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payAlipayLog/?repage";
    }
	
	/**
	 * 支付宝支付通知列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayAlipayLog payAlipayLog, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payAlipayLog, request, response, model);
        return "modules/pay/payAlipayLogSelectList";
	}
	
}