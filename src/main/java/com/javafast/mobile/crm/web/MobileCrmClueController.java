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
import com.javafast.modules.crm.entity.CrmClue;
import com.javafast.modules.crm.entity.CrmMarket;
import com.javafast.modules.crm.service.CrmClueService;
import com.javafast.modules.crm.service.CrmMarketService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 线索Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/crm/crmClue")
public class MobileCrmClueController extends BaseController {

	@Autowired
	private CrmClueService crmClueService;
	
	@Autowired
	private CrmMarketService crmMarketService;
	
	@ModelAttribute
	public CrmClue get(@RequestParam(required=false) String id) {
		CrmClue entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = crmClueService.get(id);
		}
		if (entity == null){
			entity = new CrmClue();
		}
		return entity;
	}
	
	/**
	 * 线索列表页面
	 * @param crmClue
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("crm:crmClue:list")
	@RequestMapping(value = {"list", ""})
	public String list(CrmClue crmClue, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/crm/crmClueList";
	}
	
	/**
	 * 查询数据列表
	 * @param crmClue
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(CrmClue crmClue, HttpServletRequest request, HttpServletResponse response, Model model) {
		crmClue.setIsPool("0");
		String ownById = request.getParameter("ownById");
		if(StringUtils.isNotBlank(ownById))
			crmClue.setOwnBy(new User(ownById));
		Page<CrmClue> page = crmClueService.findPage(new Page<CrmClue>(request, response), crmClue); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param crmClue
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(CrmClue crmClue, Model model) {		
		model.addAttribute("crmClue", crmClue);
		return "modules/crm/crmClueSearch";
	}
	
	/**
	 * 线索详情页面
	 * @param crmClue
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmClue:view")
	@RequestMapping(value = "view")
	public String view(CrmClue crmClue, Model model) {
		model.addAttribute("crmClue", crmClue);
		
		return "modules/crm/crmClueView";
	}
	
	/**
	 * 线索主页
	 * @param crmClue
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="crm:crmClue:view")
	@RequestMapping(value = "index")
	public String index(CrmClue crmClue, Model model) {
		model.addAttribute("crmClue", crmClue);
		
		return "modules/crm/crmClueIndex";
	}
	
	/**
	 * 编辑线索表单页面
	 */
	@RequiresPermissions(value={"crm:crmClue:view","crm:crmClue:add","crm:crmClue:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(CrmClue crmClue, Model model) {

		if(crmClue.getOwnBy() == null){
			crmClue.setOwnBy(UserUtils.getUser());
		}
		
		if(crmClue.getIsNewRecord()){
						
		}
		
		model.addAttribute("crmClue", crmClue);
		
		CrmMarket conCrmMarket = new CrmMarket();
		List<CrmMarket> crmMarketList = crmMarketService.findList(conCrmMarket);
		model.addAttribute("crmMarketList", crmMarketList);
		
		return "modules/crm/crmClueForm";
	}
	
	/**
	 * 保存线索
	 */
	@RequiresPermissions(value={"crm:crmClue:add","crm:crmClue:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(CrmClue crmClue, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, crmClue)){
			return form(crmClue, model);
		}
		
		try{
		
			if(!crmClue.getIsNewRecord()){//编辑表单保存				
				CrmClue t = crmClueService.get(crmClue.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(crmClue, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				crmClueService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CLUE, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				crmClueService.save(crmClue);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CLUE, Contants.ACTION_TYPE_ADD, crmClue.getId(), crmClue.getName(), null);
			}
			addMessage(redirectAttributes, "保存线索成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmClue/index?id="+crmClue.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存线索失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/crm/crmClue/?repage";
		}
	}
}
