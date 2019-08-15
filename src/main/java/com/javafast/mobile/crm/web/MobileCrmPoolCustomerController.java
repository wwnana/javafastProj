package com.javafast.mobile.crm.web;

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
import com.javafast.modules.crm.service.CrmCustomerService;

/**
 * 客户Controller(手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmCustomerPool")
public class MobileCrmPoolCustomerController extends BaseController {

	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmCustomer get(@RequestParam(required=false) String id) {
		CrmCustomer entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmCustomerService.get(id);
		}
		if (entity == null){
			entity = new CrmCustomer();
		}
		return entity;
	}
	
	/**
	 * 客户列表页面
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmCustomer:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmCustomerPoolList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmCustomer
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmCustomer crmCustomer, HttpServletRequest request, HttpServletResponse response){
		crmCustomer.setIsPool("1");
		Page<CrmCustomer> page = crmCustomerService.findPage(new Page<CrmCustomer>(request, response), crmCustomer); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmCustomer
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmCustomer crmCustomer, Model model) {		
		model.addAttribute("crmCustomer", crmCustomer);
		return "modules/crm/crmCustomerPoolSearch";
	}	
}
