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
import com.javafast.modules.pay.entity.PayWxpayLog;
import com.javafast.modules.pay.service.PayWxpayLogService;

/**
 * 微信支付通知Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payWxpayLog")
public class PayWxpayLogController extends BaseController {

	@Autowired
	private PayWxpayLogService payWxpayLogService;
	
	@ModelAttribute
	public PayWxpayLog get(@RequestParam(required=false) String id) {
		PayWxpayLog entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payWxpayLogService.get(id);
		}
		if (entity == null){
			entity = new PayWxpayLog();
		}
		return entity;
	}
	
	/**
	 * 微信支付通知列表页面
	 */
	@RequiresPermissions("pay:payWxpayLog:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayWxpayLog payWxpayLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayWxpayLog> page = payWxpayLogService.findPage(new Page<PayWxpayLog>(request, response), payWxpayLog); 
		model.addAttribute("page", page);
		return "modules/pay/payWxpayLogList";
	}

	/**
	 * 编辑微信支付通知表单页面
	 */
	@RequiresPermissions(value={"pay:payWxpayLog:view","pay:payWxpayLog:add","pay:payWxpayLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayWxpayLog payWxpayLog, Model model) {
		model.addAttribute("payWxpayLog", payWxpayLog);
		return "modules/pay/payWxpayLogForm";
	}
	
	/**
	 * 查看微信支付通知页面
	 */
	@RequiresPermissions(value="pay:payWxpayLog:view")
	@RequestMapping(value = "view")
	public String view(PayWxpayLog payWxpayLog, Model model) {
		model.addAttribute("payWxpayLog", payWxpayLog);
		return "modules/pay/payWxpayLogView";
	}

	/**
	 * 保存微信支付通知
	 */
	@RequiresPermissions(value={"pay:payWxpayLog:add","pay:payWxpayLog:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayWxpayLog payWxpayLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payWxpayLog)){
			return form(payWxpayLog, model);
		}
		
		try{
		
			if(!payWxpayLog.getIsNewRecord()){//编辑表单保存				
				PayWxpayLog t = payWxpayLogService.get(payWxpayLog.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payWxpayLog, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payWxpayLogService.save(t);//保存
			}else{//新增表单保存
				payWxpayLogService.save(payWxpayLog);//保存
			}
			addMessage(redirectAttributes, "保存微信支付通知成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存微信支付通知失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
		}
	}
	
	/**
	 * 删除微信支付通知
	 */
	@RequiresPermissions("pay:payWxpayLog:del")
	@RequestMapping(value = "delete")
	public String delete(PayWxpayLog payWxpayLog, RedirectAttributes redirectAttributes) {
		payWxpayLogService.delete(payWxpayLog);
		addMessage(redirectAttributes, "删除微信支付通知成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
	}
	
	/**
	 * 批量删除微信支付通知
	 */
	@RequiresPermissions("pay:payWxpayLog:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payWxpayLogService.delete(payWxpayLogService.get(id));
		}
		addMessage(redirectAttributes, "删除微信支付通知成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payWxpayLog:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayWxpayLog payWxpayLog, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "微信支付通知"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayWxpayLog> page = payWxpayLogService.findPage(new Page<PayWxpayLog>(request, response, -1), payWxpayLog);
    		new ExportExcel("微信支付通知", PayWxpayLog.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出微信支付通知记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payWxpayLog:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayWxpayLog> list = ei.getDataList(PayWxpayLog.class);
			for (PayWxpayLog payWxpayLog : list){
				try{
					payWxpayLogService.save(payWxpayLog);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条微信支付通知记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条微信支付通知记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入微信支付通知失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
    }
	
	/**
	 * 下载导入微信支付通知数据模板
	 */
	@RequiresPermissions("pay:payWxpayLog:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "微信支付通知数据导入模板.xlsx";
    		List<PayWxpayLog> list = Lists.newArrayList(); 
    		new ExportExcel("微信支付通知数据", PayWxpayLog.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payWxpayLog/?repage";
    }
	
	/**
	 * 微信支付通知列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayWxpayLog payWxpayLog, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payWxpayLog, request, response, model);
        return "modules/pay/payWxpayLogSelectList";
	}
	
}