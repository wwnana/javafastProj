package com.javafast.mobile.hd.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmMarketService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 
 * @author
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/wechat/hd")
public class MobileHdController extends BaseController{

	@Autowired
	private CrmMarketService crmMarketService;
	
	@Autowired
	private CrmClueService crmClueService;
	
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
		return "modules/hd/crmHdList";
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
		Page<CrmMarket> page = crmMarketService.findAllPage(new Page<CrmMarket>(request, response), crmMarket); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 活动填写表单
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "form")
	public String form(String id, Model model) {
		
		if(StringUtils.isBlank(id)) {
			return "error/404";
		}
		
		CrmMarket crmMarket = crmMarketService.get(id);
		if(crmMarket == null) {
			return "error/404";
		}
		
		CrmClue crmClue = new CrmClue();
		crmClue.setAccountId(crmMarket.getAccountId());
		crmClue.setOwnBy(crmMarket.getOwnBy());
		crmClue.setCrmMarket(crmMarket);
		model.addAttribute("crmClue", crmClue);
		
		return "modules/hd/form";
	}
	
	/**
	 * 保存
	 * @param crmClue
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save")
	public String save(CrmClue crmClue, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmClue)){
			return form(crmClue.getCrmMarket().getId(), model);
		}
		
		try{
			
			CrmMarket crmMarket = crmMarketService.get(crmClue.getCrmMarket());
			if(crmMarket == null) {
				addMessage(redirectAttributes, "活动可能已结束");
				return "modules/hd/fail";
			}
			
			//查询是否重复
			CrmClue conCrmClue = new CrmClue();
			conCrmClue.setIsApi(true);
			conCrmClue.setAccountId(crmMarket.getAccountId());
			conCrmClue.setCrmMarket(crmMarket);
			conCrmClue.setMobile(crmClue.getMobile());
			List<CrmClue> clueList = crmClueService.findCrmClueList(conCrmClue);
			if(clueList!=null && clueList.size()>0) {
				addMessage(redirectAttributes, "您已经提交过了");
				return "modules/hd/fail";
			}
			
			crmClueService.save(crmClue);//保存
			addMessage(redirectAttributes, "提交成功");
			return "modules/hd/success";
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "提交失败");
			return "modules/hd/fail";
		}
	}
}
