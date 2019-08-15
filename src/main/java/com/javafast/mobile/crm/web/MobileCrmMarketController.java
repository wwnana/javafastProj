package com.javafast.mobile.crm.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmMarketService;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 市场活动Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmMarket")
public class MobileCrmMarketController extends BaseController {

	@Autowired
	private CrmMarketService crmMarketService;
	
	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public CrmMarket get(@RequestParam(required=false) String id) {
		CrmMarket entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmMarketService.get(id);
		}
		if (entity == null){
			entity = new CrmMarket();
		}
		return entity;
	}
	
	/**
	 * 市场活动列表页面
	 * @param crmMarket
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmMarket:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmMarketList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmMarket
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmMarket crmMarket, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			crmMarket.setOwnBy(new User(ownById));
		Page<CrmMarket> page = crmMarketService.findPage(new Page<CrmMarket>(request, response), crmMarket); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmMarket
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmMarket crmMarket, Model model) {		
		model.addAttribute("crmMarket", crmMarket);
		return "modules/crm/crmMarketSearch";
	}
	
	/**
	 * 市场活动详情页面
	 * @param crmMarket
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmMarket:view")
	@RequestMapping(value = "view")
	public String view(CrmMarket crmMarket, Model model, HttpServletRequest request, HttpServletResponse response) {
		model.addAttribute("crmMarket", crmMarket);
		
		CrmClue conCrmClue = new CrmClue();
		conCrmClue.setCrmMarket(crmMarket);
		Page<CrmClue> crmCluePage = crmClueService.findPage(new Page<CrmClue>(request, response), conCrmClue); 
		model.addAttribute("crmCluePage", crmCluePage);
		
		return "modules/crm/crmMarketView";
	}
	
	/**
	 * 编辑市场活动表单页面
	 */
	@RequiresPermissions(value={"crm:crmMarket:view","crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmMarket crmMarket, Model model) {

		if(crmMarket.getOwnBy() == null){
			crmMarket.setOwnBy(UserUtils.getUser());
		}
		
		if(crmMarket.getIsNewRecord()){
		}
		
		model.addAttribute("crmMarket", crmMarket);
		return "modules/crm/crmMarketForm";
	}
	
	/**
	 * 保存市场活动
	 */
	@RequiresPermissions(value={"crm:crmMarket:add","crm:crmMarket:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmMarket crmMarket, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmMarket)){
			return form(crmMarket, model);
		}
		
		try{
		
			if(!crmMarket.getIsNewRecord()){//编辑表单保存				
				CrmMarket t = crmMarketService.get(crmMarket.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmMarket, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmMarketService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_MARKET, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				crmMarketService.save(crmMarket);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_MARKET, Contants.ACTION_TYPE_ADD, crmMarket.getId(), crmMarket.getName(), null);
			}
			addMessage(redirectAttributes, "保存市场活动成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmMarket/view?id="+crmMarket.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存市场活动失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmMarket/?repage";
		}
	}
}
