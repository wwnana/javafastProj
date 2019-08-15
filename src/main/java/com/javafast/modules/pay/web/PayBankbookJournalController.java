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
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
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
import com.javafast.modules.pay.entity.PayBankbookJournal;
import com.javafast.modules.pay.service.PayBankbookJournalService;

/**
 * 电子钱包交易明细Controller
 * @author javafast
 * @version 2018-05-15
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payBankbookJournal")
public class PayBankbookJournalController extends BaseController {

	@Autowired
	private PayBankbookJournalService payBankbookJournalService;
	
	@ModelAttribute
	public PayBankbookJournal get(@RequestParam(required=false) String id) {
		PayBankbookJournal entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payBankbookJournalService.get(id);
		}
		if (entity == null){
			entity = new PayBankbookJournal();
		}
		return entity;
	}
	
	/**
	 * 电子钱包交易明细列表页面
	 */
	@RequiresPermissions("pay:payBankbookJournal:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayBankbookJournal payBankbookJournal, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayBankbookJournal> page = payBankbookJournalService.findPage(new Page<PayBankbookJournal>(request, response), payBankbookJournal); 
		model.addAttribute("page", page);
		return "modules/pay/payBankbookJournalList";
	}

	/**
	 * 编辑电子钱包交易明细表单页面
	 */
	@RequiresPermissions(value={"pay:payBankbookJournal:view","pay:payBankbookJournal:add","pay:payBankbookJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayBankbookJournal payBankbookJournal, Model model) {
		model.addAttribute("payBankbookJournal", payBankbookJournal);
		return "modules/pay/payBankbookJournalForm";
	}
	
	/**
	 * 查看电子钱包交易明细页面
	 */
	@RequiresPermissions(value="pay:payBankbookJournal:view")
	@RequestMapping(value = "view")
	public String view(PayBankbookJournal payBankbookJournal, Model model) {
		model.addAttribute("payBankbookJournal", payBankbookJournal);
		return "modules/pay/payBankbookJournalView";
	}

	/**
	 * 保存电子钱包交易明细
	 */
	@RequiresPermissions(value={"pay:payBankbookJournal:add","pay:payBankbookJournal:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayBankbookJournal payBankbookJournal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payBankbookJournal)){
			return form(payBankbookJournal, model);
		}
		
		try{
		
			if(!payBankbookJournal.getIsNewRecord()){//编辑表单保存				
				PayBankbookJournal t = payBankbookJournalService.get(payBankbookJournal.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payBankbookJournal, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payBankbookJournalService.save(t);//保存
			}else{//新增表单保存
				payBankbookJournalService.save(payBankbookJournal);//保存
			}
			addMessage(redirectAttributes, "保存电子钱包交易明细成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存电子钱包交易明细失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
		}
	}
	
	/**
	 * 删除电子钱包交易明细
	 */
	@RequiresPermissions("pay:payBankbookJournal:del")
	@RequestMapping(value = "delete")
	public String delete(PayBankbookJournal payBankbookJournal, RedirectAttributes redirectAttributes) {
		payBankbookJournalService.delete(payBankbookJournal);
		addMessage(redirectAttributes, "删除电子钱包交易明细成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
	}
	
	/**
	 * 批量删除电子钱包交易明细
	 */
	@RequiresPermissions("pay:payBankbookJournal:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payBankbookJournalService.delete(payBankbookJournalService.get(id));
		}
		addMessage(redirectAttributes, "删除电子钱包交易明细成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payBankbookJournal:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayBankbookJournal payBankbookJournal, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "电子钱包交易明细"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayBankbookJournal> page = payBankbookJournalService.findPage(new Page<PayBankbookJournal>(request, response, -1), payBankbookJournal);
    		new ExportExcel("电子钱包交易明细", PayBankbookJournal.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出电子钱包交易明细记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payBankbookJournal:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayBankbookJournal> list = ei.getDataList(PayBankbookJournal.class);
			for (PayBankbookJournal payBankbookJournal : list){
				try{
					payBankbookJournalService.save(payBankbookJournal);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条电子钱包交易明细记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条电子钱包交易明细记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入电子钱包交易明细失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
    }
	
	/**
	 * 下载导入电子钱包交易明细数据模板
	 */
	@RequiresPermissions("pay:payBankbookJournal:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "电子钱包交易明细数据导入模板.xlsx";
    		List<PayBankbookJournal> list = Lists.newArrayList(); 
    		new ExportExcel("电子钱包交易明细数据", PayBankbookJournal.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookJournal/?repage";
    }
	
	/**
	 * 电子钱包交易明细列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayBankbookJournal payBankbookJournal, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payBankbookJournal, request, response, model);
        return "modules/pay/payBankbookJournalSelectList";
	}
	
}