package com.javafast.mobile.crm.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;

/**
 * 报价单Controller（手机端）
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmQuote")
public class MobileCrmQuoteController extends BaseController{

	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmQuote get(@RequestParam(required=false) String id) {
		CrmQuote entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmQuoteService.get(id);
		}
		if (entity == null){
			entity = new CrmQuote();
		}
		return entity;
	}
	
	/**
	 * 报价单列表页面
	 * @param crmQuote
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmQuote:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmQuote crmQuote, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmQuoteList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmQuote
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmQuote crmQuote, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CrmQuote> page = crmQuoteService.findPage(new Page<CrmQuote>(request, response), crmQuote); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmQuote
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmQuote crmQuote, Model model) {		
		model.addAttribute("crmQuote", crmQuote);
		return "modules/crm/crmQuoteSearch";
	}
	
	/**
	 * 报价单详情页面
	 * @param crmQuote
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmQuote:view")
	@RequestMapping(value = "view")
	public String view(CrmQuote crmQuote, Model model) {
		model.addAttribute("crmQuote", crmQuote);
		return "modules/crm/crmQuoteView";
	}
}
