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
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.pay.entity.PayRechargeOrder;
import com.javafast.modules.pay.service.PayRechargeOrderService;

/**
 * 充值订单Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payRechargeOrder")
public class PayRechargeOrderController extends BaseController {

	@Autowired
	private PayRechargeOrderService payRechargeOrderService;
	
	@ModelAttribute
	public PayRechargeOrder get(@RequestParam(required=false) String id) {
		PayRechargeOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payRechargeOrderService.get(id);
		}
		if (entity == null){
			entity = new PayRechargeOrder();
		}
		return entity;
	}
	
	/**
	 * 充值订单列表页面
	 */
	@RequiresPermissions("pay:payRechargeOrder:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayRechargeOrder payRechargeOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayRechargeOrder> page = payRechargeOrderService.findPage(new Page<PayRechargeOrder>(request, response), payRechargeOrder); 
		model.addAttribute("page", page);
		return "modules/pay/payRechargeOrderList";
	}

	/**
	 * 编辑充值订单表单页面
	 */
	@RequiresPermissions(value={"pay:payRechargeOrder:view","pay:payRechargeOrder:add","pay:payRechargeOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayRechargeOrder payRechargeOrder, Model model) {
		
		if(payRechargeOrder.getIsNewRecord()){
			
			payRechargeOrder.setNo(IdUtils.getId());
		}
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/payRechargeOrderForm";
	}
	
	/**
	 * 查看充值订单页面
	 */
	@RequiresPermissions(value="pay:payRechargeOrder:view")
	@RequestMapping(value = "view")
	public String view(PayRechargeOrder payRechargeOrder, Model model) {
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/payRechargeOrderView";
	}

	/**
	 * 保存充值订单
	 */
	@RequiresPermissions(value={"pay:payRechargeOrder:add","pay:payRechargeOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayRechargeOrder payRechargeOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payRechargeOrder)){
			return form(payRechargeOrder, model);
		}
		
		try{
		
			payRechargeOrder.setNotes("JavaFast平台在线充值");
			if(!payRechargeOrder.getIsNewRecord()){//编辑表单保存				
				PayRechargeOrder t = payRechargeOrderService.get(payRechargeOrder.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payRechargeOrder, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payRechargeOrderService.save(t);//保存
			}else{//新增表单保存
				payRechargeOrder.setStatus("0");
				payRechargeOrderService.save(payRechargeOrder);//保存
			}
			addMessage(redirectAttributes, "保存充值订单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存充值订单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
		}
	}
	
	/**
	 * 删除充值订单
	 */
	@RequiresPermissions("pay:payRechargeOrder:del")
	@RequestMapping(value = "delete")
	public String delete(PayRechargeOrder payRechargeOrder, RedirectAttributes redirectAttributes) {
		payRechargeOrderService.delete(payRechargeOrder);
		addMessage(redirectAttributes, "删除充值订单成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
	}
	
	/**
	 * 批量删除充值订单
	 */
	@RequiresPermissions("pay:payRechargeOrder:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payRechargeOrderService.delete(payRechargeOrderService.get(id));
		}
		addMessage(redirectAttributes, "删除充值订单成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payRechargeOrder:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayRechargeOrder payRechargeOrder, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "充值订单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayRechargeOrder> page = payRechargeOrderService.findPage(new Page<PayRechargeOrder>(request, response, -1), payRechargeOrder);
    		new ExportExcel("充值订单", PayRechargeOrder.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出充值订单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payRechargeOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayRechargeOrder> list = ei.getDataList(PayRechargeOrder.class);
			for (PayRechargeOrder payRechargeOrder : list){
				try{
					payRechargeOrderService.save(payRechargeOrder);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条充值订单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条充值订单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入充值订单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
    }
	
	/**
	 * 下载导入充值订单数据模板
	 */
	@RequiresPermissions("pay:payRechargeOrder:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "充值订单数据导入模板.xlsx";
    		List<PayRechargeOrder> list = Lists.newArrayList(); 
    		new ExportExcel("充值订单数据", PayRechargeOrder.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/?repage";
    }
	
	/**
	 * 充值订单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayRechargeOrder payRechargeOrder, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payRechargeOrder, request, response, model);
        return "modules/pay/payRechargeOrderSelectList";
	}
	
	/**
	 * 微信支付页面
	 * @param payRechargeOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "wxPayForm")
	public String wxPayForm(PayRechargeOrder payRechargeOrder, Model model) {
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/wxPayForm";
	}
	
	/**
	 * 阿里支付页面
	 * @param payRechargeOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "aliPayForm")
	public String aliPayForm(PayRechargeOrder payRechargeOrder, Model model) {
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/aliPayForm";
	}
	
	/**
	 * 企业充值
	 * @param payRechargeOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "rechargeForm")
	public String rechargeForm(PayRechargeOrder payRechargeOrder, Model model) {
		
		if(payRechargeOrder.getIsNewRecord()){
			payRechargeOrder.setNo(IdUtils.getId());
		}
		
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/rechargeForm";
	}
	
	/**
	 * 创建企业充值订单
	 * @param payRechargeOrder
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "rechargeSave")
	public String rechargeSave(PayRechargeOrder payRechargeOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payRechargeOrder)){
			return form(payRechargeOrder, model);
		}
		
		try{
		
			payRechargeOrder.setNotes("企酷CRM平台充值");
			payRechargeOrder.setStatus("0");
			payRechargeOrderService.save(payRechargeOrder);//保存
			
			return "redirect:"+Global.getAdminPath()+"/pay/payRechargeOrder/rechargeWxPayForm?id="+payRechargeOrder.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "创建充值订单失败");
			return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/sysAccountBankbokInfo";
		}
	}
	
	/**
	 * 企业充值微信支付
	 * @param payRechargeOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "rechargeWxPayForm")
	public String rechargeWxPayForm(PayRechargeOrder payRechargeOrder, Model model) {
		model.addAttribute("payRechargeOrder", payRechargeOrder);
		return "modules/pay/rechargeWxPayForm";
	}
}