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

import javax.validation.constraints.NotNull;

import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

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
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.service.FiFinanceAccountService;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.om.entity.OmOrderDetail;
import com.javafast.modules.om.entity.OmReturnorder;
import com.javafast.modules.om.entity.OmReturnorderDetail;
import com.javafast.modules.om.service.OmOrderService;
import com.javafast.modules.om.service.OmReturnorderService;

/**
 * 销售退单Controller
 * @author javafast
 * @version 2017-07-08
 */
@Controller
@RequestMapping(value = "${adminPath}/om/omReturnorder")
public class OmReturnorderController extends BaseController {

	@Autowired
	private OmReturnorderService omReturnorderService;
	
	@Autowired
	private FiFinanceAccountService fiFinanceAccountService;
	
	@Autowired
	private OmOrderService omOrderService;
	
	@ModelAttribute
	public OmReturnorder get(@RequestParam(required=false) String id) {
		OmReturnorder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = omReturnorderService.get(id);
		}
		if (entity == null){
			entity = new OmReturnorder();
		}
		return entity;
	}
	
	/**
	 * 销售退单列表页面
	 */
	@RequiresPermissions("om:omReturnorder:list")
	@RequestMapping(value = {"list", ""})
	public String list(OmReturnorder omReturnorder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OmReturnorder> page = omReturnorderService.findPage(new Page<OmReturnorder>(request, response), omReturnorder); 
		model.addAttribute("page", page);
		return "modules/om/omReturnorderList";
	}

	/**
	 * 查看
	 */
	@RequiresPermissions(value="om:omReturnorder:view")
	@RequestMapping(value = "view")
	public String view(OmReturnorder omReturnorder, Model model) {
		model.addAttribute("omReturnorder", omReturnorder);
		return "modules/om/omReturnorderView";
	}
	
	/**
	 * 打印
	 * @param omReturnorder
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="om:omReturnorder:view")
	@RequestMapping(value = "print")
	public String print(OmReturnorder omReturnorder, Model model) {
		model.addAttribute("omReturnorder", omReturnorder);
		return "modules/om/omReturnorderPrint";
	}
	
	/**
	 * 查看，增加，编辑销售退单表单页面
	 */
	@RequiresPermissions(value={"om:omReturnorder:view","om:omReturnorder:add","om:omReturnorder:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(OmReturnorder omReturnorder, Model model) {
		
		if(omReturnorder.getIsNewRecord()){
			omReturnorder.setNo("TH"+IdUtils.getId());
			omReturnorder.setStatus("0");
			
			//订单生成退货单
			if(StringUtils.isNotBlank(omReturnorder.getOrder().getId())){
				
				OmOrder order = omOrderService.get(omReturnorder.getOrder().getId());
				order.setName(order.getNo());
				omReturnorder.setOrder(order);
				omReturnorder.setSaleType(order.getSaleType());
				omReturnorder.setCustomer(order.getCustomer());				
				omReturnorder.setNum(order.getNum());
				omReturnorder.setAmount(order.getAmount());
				//omReturnorder.setTaxAmt(order.getTaxAmt());
				omReturnorder.setOtherAmt(order.getOtherAmt());
				omReturnorder.setTotalAmt(order.getTotalAmt());
				omReturnorder.setFiAccount(order.getFiAccount());
				
				List<OmReturnorderDetail> omReturnorderDetailList = Lists.newArrayList();
				
				for(OmOrderDetail omOrderDetail:order.getOmOrderDetailList()){
					
					OmReturnorderDetail omReturnorderDetail = new OmReturnorderDetail();
					
					omReturnorderDetail.setProduct(omOrderDetail.getProduct());
					omReturnorderDetail.setUnitType(omOrderDetail.getUnitType());
					omReturnorderDetail.setPrice(omOrderDetail.getPrice());
					omReturnorderDetail.setNum(omOrderDetail.getNum());
					omReturnorderDetail.setAmount(omOrderDetail.getAmount());
					//omReturnorderDetail.setTaxRate(omOrderDetail.getTaxRate());
					//omReturnorderDetail.setTaxAmt(omOrderDetail.getTaxAmt());
					omReturnorderDetail.setSort(omOrderDetail.getSort());
					
					omReturnorderDetailList.add(omReturnorderDetail);
				}
				omReturnorder.setOmReturnorderDetailList(omReturnorderDetailList);
			}
		}
		
		if(omReturnorder.getDealBy() == null){
			omReturnorder.setDealBy(UserUtils.getUser());
		}
		if(omReturnorder.getDealDate() == null){
			omReturnorder.setDealDate(new Date());
		}
		
		model.addAttribute("omReturnorder", omReturnorder);
		return "modules/om/omReturnorderForm";
	}

	/**
	 * 保存销售退单
	 */
	@RequiresPermissions(value={"om:omReturnorder:add","om:omReturnorder:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(OmReturnorder omReturnorder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, omReturnorder)){
			return form(omReturnorder, model);
		}
		
		try{
		
			if(!omReturnorder.getIsNewRecord()){//编辑表单保存				
				OmReturnorder t = omReturnorderService.get(omReturnorder.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(omReturnorder, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				omReturnorderService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RETURN_ORDER, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getNo(), t.getCustomer().getId());
			}else{//新增表单保存
				omReturnorderService.save(omReturnorder);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RETURN_ORDER, Contants.ACTION_TYPE_ADD, omReturnorder.getId(), omReturnorder.getNo(), omReturnorder.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存销售退单成功");
			return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存销售退单失败");
			return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
		}
	}
	
	/**
	 * 删除销售退单
	 */
	@RequiresPermissions("om:omReturnorder:del")
	@RequestMapping(value = "delete")
	public String delete(OmReturnorder omReturnorder, RedirectAttributes redirectAttributes) {
		omReturnorderService.delete(omReturnorder);
		addMessage(redirectAttributes, "删除销售退单成功");
		return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
	}
	
	/**
	 * 批量删除销售退单
	 */
	@RequiresPermissions("om:omReturnorder:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			omReturnorderService.delete(omReturnorderService.get(id));
		}
		addMessage(redirectAttributes, "删除销售退单成功");
		return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("om:omReturnorder:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(OmReturnorder omReturnorder, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售退单"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<OmReturnorder> page = omReturnorderService.findPage(new Page<OmReturnorder>(request, response, -1), omReturnorder);
    		new ExportExcel("销售退单", OmReturnorder.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出销售退单记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("om:omReturnorder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<OmReturnorder> list = ei.getDataList(OmReturnorder.class);
			for (OmReturnorder omReturnorder : list){
				try{
					omReturnorderService.save(omReturnorder);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条销售退单记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条销售退单记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入销售退单失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
    }
	
	/**
	 * 下载导入销售退单数据模板
	 */
	@RequiresPermissions("om:omReturnorder:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "销售退单数据导入模板.xlsx";
    		List<OmReturnorder> list = Lists.newArrayList(); 
    		new ExportExcel("销售退单数据", OmReturnorder.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
    }
	
	/**
	 * 审核销售退单
	 * @param omReturnorder
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("om:omReturnorder:audit")
	@RequestMapping(value = "audit")
	public String audit(OmReturnorder omReturnorder, RedirectAttributes redirectAttributes) {
		try{
			omReturnorderService.audit(omReturnorder);
			addMessage(redirectAttributes, " 审核销售退单成功");
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RETURN_ORDER, Contants.ACTION_TYPE_AUDIT, omReturnorder.getId(), omReturnorder.getNo(), omReturnorder.getCustomer().getId());
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "审核销售退单失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/om/omReturnorder/?repage";
		}
	}
	

}