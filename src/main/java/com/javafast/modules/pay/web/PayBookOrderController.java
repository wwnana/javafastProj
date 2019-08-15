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
import javax.validation.constraints.NotNull;
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
import com.javafast.modules.pay.entity.PayBookOrder;
import com.javafast.modules.pay.service.PayBookOrderService;

/**
 * 预定订单Controller
 * @author javafast
 * @version 2018-08-03
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payBookOrder")
public class PayBookOrderController extends BaseController {

	@Autowired
	private PayBookOrderService payBookOrderService;
	
	@ModelAttribute
	public PayBookOrder get(@RequestParam(required=false) String id) {
		PayBookOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payBookOrderService.get(id);
		}
		if (entity == null){
			entity = new PayBookOrder();
		}
		return entity;
	}
	
	/**
	 * 预定订单列表页面
	 */
	@RequiresPermissions("pay:payBookOrder:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayBookOrder payBookOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayBookOrder> page = payBookOrderService.findPage(new Page<PayBookOrder>(request, response), payBookOrder); 
		model.addAttribute("page", page);
		return "modules/pay/payBookOrderList";
	}

	/**
	 * 编辑预定订单表单页面
	 */
	@RequiresPermissions(value={"pay:payBookOrder:view","pay:payBookOrder:add","pay:payBookOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayBookOrder payBookOrder, Model model) {
		model.addAttribute("payBookOrder", payBookOrder);
		return "modules/pay/payBookOrderForm";
	}
	
	/**
	 * 查看预定订单页面
	 */
	@RequiresPermissions(value="pay:payBookOrder:view")
	@RequestMapping(value = "view")
	public String view(PayBookOrder payBookOrder, Model model) {
		model.addAttribute("payBookOrder", payBookOrder);
		return "modules/pay/payBookOrderView";
	}

	/**
	 * 保存预定订单
	 */
	@RequiresPermissions(value={"pay:payBookOrder:add","pay:payBookOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayBookOrder payBookOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payBookOrder)){
			return form(payBookOrder, model);
		}
		
		try{
		
			if(!payBookOrder.getIsNewRecord()){//编辑表单保存				
				PayBookOrder t = payBookOrderService.get(payBookOrder.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payBookOrder, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payBookOrderService.save(t);//保存
			}else{//新增表单保存
				payBookOrderService.save(payBookOrder);//保存
			}
			addMessage(redirectAttributes, "保存预定订单成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存预定订单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
		}
	}
	
	/**
	 * 删除预定订单
	 */
	@RequiresPermissions("pay:payBookOrder:del")
	@RequestMapping(value = "delete")
	public String delete(PayBookOrder payBookOrder, RedirectAttributes redirectAttributes) {
		payBookOrderService.delete(payBookOrder);
		addMessage(redirectAttributes, "删除预定订单成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
	}
	
	/**
	 * 批量删除预定订单
	 */
	@RequiresPermissions("pay:payBookOrder:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payBookOrderService.delete(payBookOrderService.get(id));
		}
		addMessage(redirectAttributes, "删除预定订单成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payBookOrder:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayBookOrder payBookOrder, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "预定订单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayBookOrder> page = payBookOrderService.findPage(new Page<PayBookOrder>(request, response, -1), payBookOrder);
    		new ExportExcel("预定订单", PayBookOrder.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出预定订单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payBookOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayBookOrder> list = ei.getDataList(PayBookOrder.class);
			for (PayBookOrder payBookOrder : list){
				try{
					payBookOrderService.save(payBookOrder);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条预定订单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条预定订单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入预定订单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
    }
	
	/**
	 * 下载导入预定订单数据模板
	 */
	@RequiresPermissions("pay:payBookOrder:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "预定订单数据导入模板.xlsx";
    		List<PayBookOrder> list = Lists.newArrayList(); 
    		new ExportExcel("预定订单数据", PayBookOrder.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/?repage";
    }
	
	/**
	 * 预定订单列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayBookOrder payBookOrder, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payBookOrder, request, response, model);
        return "modules/pay/payBookOrderSelectList";
	}
	
	/**
	 * 在线下单预定
	 * @param payBookOrder
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "orderForm")
	public String orderForm(PayBookOrder payBookOrder, Model model) {
		
		payBookOrder.setNo(IdUtils.getId());
		payBookOrder.setAmount(new BigDecimal(20000));
		if(StringUtils.isBlank(payBookOrder.getProductId())){
			payBookOrder.setProductId("0");
		}
		
		if("1".equals(payBookOrder.getProductId())){
			payBookOrder.setAmount(new BigDecimal(50000));
		}
		
		model.addAttribute("payBookOrder", payBookOrder);
		return "modules/pay/book/payBookOrderForm";
	}
	
	/**
	 * 在线下单预定提交
	 * @param payBookOrder
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveOrder")
	public String saveOrder(PayBookOrder payBookOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payBookOrder)){
			return form(payBookOrder, model);
		}
		
		try{
		
			payBookOrder.setStatus("0");
			payBookOrderService.createOrder(payBookOrder);//保存
			
			addMessage(redirectAttributes, "下单成功，工作人员会在24小时内与您取得联系");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "下单失败，请联系在线客服.");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payBookOrder/orderView?id="+payBookOrder.getId();
		}
	}
	@RequestMapping(value = "orderView")
	public String orderView(PayBookOrder payBookOrder, Model model) {
		model.addAttribute("payBookOrder", payBookOrder);
		return "modules/pay/book/payBookOrderView";
	}
}