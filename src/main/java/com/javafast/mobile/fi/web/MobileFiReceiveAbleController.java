package com.javafast.mobile.fi.web;

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
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 应收款Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/fi/fiReceiveAble")
public class MobileFiReceiveAbleController extends BaseController {

	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@ModelAttribute
	public FiReceiveAble get(@RequestParam(required=false) String id) {
		FiReceiveAble entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = fiReceiveAbleService.get(id);
		}
		if (entity == null){
			entity = new FiReceiveAble();
		}
		return entity;
	}
	
	/**
	 * 应收款列表页面
	 * @param fiReceiveAble
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("fi:fiReceiveAble:list")
	@RequestMapping(value = {"list", ""})
	public String list(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/fi/fiReceiveAbleList";
	}
	
	/**
	 * 查询数据列表
	 * @param fiReceiveAble
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(FiReceiveAble fiReceiveAble, HttpServletRequest request, HttpServletResponse response, Model model) {
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			fiReceiveAble.setOwnBy(new User(ownById));
		Page<FiReceiveAble> page = fiReceiveAbleService.findPage(new Page<FiReceiveAble>(request, response), fiReceiveAble); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param fiReceiveAble
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(FiReceiveAble fiReceiveAble, Model model) {		
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		return "modules/fi/fiReceiveAbleSearch";
	}
	
	/**
	 * 应收款详情页面
	 * @param fiReceiveAble
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="fi:fiReceiveAble:view")
	@RequestMapping(value = "view")
	public String view(FiReceiveAble fiReceiveAble, Model model) {
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		
		return "modules/fi/fiReceiveAbleView";
	}
	
	/**
	 * 编辑应收款表单页面
	 */
	@RequiresPermissions(value={"fi:fiReceiveAble:view","fi:fiReceiveAble:add","fi:fiReceiveAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(FiReceiveAble fiReceiveAble, Model model) {

		if(fiReceiveAble.getOwnBy() == null){
			fiReceiveAble.setOwnBy(UserUtils.getUser());
		}
		
		if(fiReceiveAble.getIsNewRecord()){
			if(fiReceiveAble.getCustomer() != null && fiReceiveAble.getCustomer().getId() != null){
				CrmCustomer customer = crmCustomerService.get(fiReceiveAble.getCustomer().getId());
				fiReceiveAble.setCustomer(customer);
			}			
		}
		
		model.addAttribute("fiReceiveAble", fiReceiveAble);
		return "modules/fi/fiReceiveAbleForm";
	}
	
	/**
	 * 保存应收款
	 */
	@RequiresPermissions(value={"fi:fiReceiveAble:add","fi:fiReceiveAble:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(FiReceiveAble fiReceiveAble, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, fiReceiveAble)){
			return form(fiReceiveAble, model);
		}
		
		try{
		
			if(!fiReceiveAble.getIsNewRecord()){//编辑表单保存				
				FiReceiveAble t = fiReceiveAbleService.get(fiReceiveAble.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(fiReceiveAble, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				fiReceiveAbleService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), t.getCustomer().getId());
			}else{//新增表单保存
				fiReceiveAbleService.save(fiReceiveAble);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_ADD, fiReceiveAble.getId(), fiReceiveAble.getName(), fiReceiveAble.getCustomer().getId());
			}
			addMessage(redirectAttributes, "保存应收款成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveAble/view?id="+fiReceiveAble.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存应收款失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/fi/fiReceiveAble/?repage";
		}
	}
}
