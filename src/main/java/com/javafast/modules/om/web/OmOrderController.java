/**
 * Copyright 2015-2020
 */
package com.javafast.modules.om.web;

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

import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.service.WmsOutstockService;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;
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
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.service.OmOrderService;

/**
 * 销售订单Controller
 * @author javafast
 * @version 2017-07-14
 */
@Controller
@RequestMapping(value = "${adminPath}/om/omOrder")
public class OmOrderController extends BaseController {

	@Autowired
	private OmOrderService omOrderService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
	@ModelAttribute
	public OmOrder get(@RequestParam(required=false) String id) {
		OmOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = omOrderService.get(id);
		}
		if (entity == null){
			entity = new OmOrder();
		}
		return entity;
	}
	
	/**
	 * 销售订单列表页面
	 */
	@RequiresPermissions("om:omOrder:list")
	@RequestMapping(value = {"list", ""})
	public String list(OmOrder omOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OmOrder> page = omOrderService.findPage(new Page<OmOrder>(request, response), omOrder); 
		model.addAttribute("page", page);
		return "modules/om/omOrderList";
	}

	/**
	 * 编辑销售订单销售订单表单页面
	 */
	@RequiresPermissions(value={"om:omOrder:view","om:omOrder:add","om:omOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OmOrder omOrder, Model model) {
		
		if(omOrder.getIsNewRecord()){
			omOrder.setNo("DD"+IdUtils.getId());
			omOrder.setSaleType("0");
		}
		
		if(omOrder.getDealBy() == null){
			omOrder.setDealBy(UserUtils.getUser());
		}
		if(omOrder.getDealDate() == null){
			omOrder.setDealDate(new Date());
		}
		
		omOrder.setStatus("0");
		
		model.addAttribute("omOrder", omOrder);
		return "modules/om/omOrderForm";
	}
	
	/**
	 * 查看销售订单页面
	 */
	@RequiresPermissions(value="om:omOrder:view")
	@RequestMapping(value = "view")
	public String view(OmOrder omOrder, Model model) {
		model.addAttribute("omOrder", omOrder);
		return "modules/om/omOrderView";
	}
	
	/**
	 * 打印
	 * @param omOrder
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="om:omOrder:view")
	@RequestMapping(value = "print")
	public String print(OmOrder omOrder, Model model) {
		model.addAttribute("omOrder", omOrder);
		return "modules/om/omOrderPrint";
	}

	/**
	 * 保存销售订单
	 */
	@RequiresPermissions(value={"om:omOrder:add","om:omOrder:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(OmOrder omOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omOrder)){
			return form(omOrder, model);
		}
		
		try{
			
			if(omOrder.getInvoiceAmt() != null){
				omOrder.setIsInvoice("1");
			}
		
			if(!omOrder.getIsNewRecord()){//编辑表单保存				
				OmOrder t = omOrderService.get(omOrder.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(omOrder, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				omOrderService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				omOrderService.save(omOrder);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDER, Contants.ACTION_TYPE_ADD, omOrder.getId(), omOrder.getNo(), omOrder.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存销售订单成功");
			return "redirect:"+Global.getAdminPath()+"/om/omOrder/index?id="+omOrder.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存销售订单失败");
			return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
		}
	}
	
	/**
	 * 删除销售订单
	 */
	@RequiresPermissions("om:omOrder:del")
	@RequestMapping(value = "delete")
	public String delete(OmOrder omOrder, RedirectAttributes redirectAttributes) {
		omOrderService.delete(omOrder);
		addMessage(redirectAttributes, "删除销售订单成功");
		return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
	}
	
	/**
	 * 批量删除销售订单
	 */
	@RequiresPermissions("om:omOrder:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			omOrderService.delete(omOrderService.get(id));
		}
		addMessage(redirectAttributes, "删除销售订单成功");
		return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("om:omOrder:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OmOrder omOrder, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售订单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OmOrder> page = omOrderService.findPage(new Page<OmOrder>(request, response, -1), omOrder);
    		new ExportExcel("销售订单", OmOrder.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出销售订单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("om:omOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OmOrder> list = ei.getDataList(OmOrder.class);
			for (OmOrder omOrder : list){
				try{
					omOrderService.save(omOrder);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条销售订单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条销售订单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入销售订单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
    }
	
	/**
	 * 下载导入销售订单数据模板
	 */
	@RequiresPermissions("om:omOrder:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售订单数据导入模板.xlsx";
    		List<OmOrder> list = Lists.newArrayList(); 
    		new ExportExcel("销售订单数据", OmOrder.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omOrder/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(OmOrder omOrder, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(omOrder, request, response, model);
        return "modules/om/omOrderSelectList";
	}
	
	/**
	 * 审核
	 * @param omOrder
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("om:omOrder:audit")
	@RequestMapping(value = "audit")
	public String audit(OmOrder omOrder, RedirectAttributes redirectAttributes) {
		try {
			
			omOrderService.audit(omOrder.getId());
			addMessage(redirectAttributes, "审核销售订单成功");
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_ORDER, Contants.ACTION_TYPE_AUDIT, omOrder.getId(), omOrder.getNo(), omOrder.getCustomer().getId());
		} catch (Exception e) {
			addMessage(redirectAttributes, "审核失败！失败信息："+e.getMessage());
		}finally {
			return "redirect:"+Global.getAdminPath()+"/om/omOrder/index?id="+omOrder.getId();
		}
	}

	@RequiresPermissions(value="om:omOrder:view")
	@RequestMapping(value = "index")
	public String index(OmOrder omOrder, Model model) {
		model.addAttribute("omOrder", omOrder);
		
		//如果是已经审核的合同，还需要查询关联的应收款、出库单
		//查询应收款
		FiReceiveAble fiReceiveAble = new FiReceiveAble();
		//fiReceiveAble.setCustomer(crmCustomer);
		fiReceiveAble.setOrder(omOrder);
		List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findFiReceiveAbleList(fiReceiveAble);
		model.addAttribute("fiReceiveAbleList", fiReceiveAbleList);
		
		//查询收款记录
		if(fiReceiveAbleList != null && fiReceiveAbleList.size() > 0) {
			FiReceiveBill conFiReceiveBill = new FiReceiveBill();
			conFiReceiveBill.setFiReceiveAble(fiReceiveAbleList.get(0));
			List<FiReceiveBill> fiReceiveBillList = fiReceiveBillService.findFiReceiveBillList(conFiReceiveBill);
			model.addAttribute("fiReceiveBillList", fiReceiveBillList);
		}		
		
		//查询出库单
		WmsOutstock conWmsOutstock = new WmsOutstock();
		conWmsOutstock.setOrder(omOrder);
		List<WmsOutstock> wmsOutstockList = wmsOutstockService.findList(conWmsOutstock);
		model.addAttribute("wmsOutstockList", wmsOutstockList);
		
		//查询日志
		SysDynamic conSysDynamic = new SysDynamic();
		conSysDynamic.setTargetId(omOrder.getId());
		List<SysDynamic> sysDynamicList = sysDynamicService.findList(conSysDynamic);
		model.addAttribute("sysDynamicList", sysDynamicList);
				
		return "modules/om/omOrderIndex";
	}
}