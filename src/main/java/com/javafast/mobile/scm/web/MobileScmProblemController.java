package com.javafast.mobile.scm.web;

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
import com.javafast.modules.scm.entity.ScmProblem;
import com.javafast.modules.scm.entity.ScmProblemType;
import com.javafast.modules.scm.service.ScmProblemService;
import com.javafast.modules.scm.service.ScmProblemTypeService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 知识Controller (手机端)
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/scm/scmProblem")
public class MobileScmProblemController extends BaseController {

	@Autowired
	private ScmProblemService scmProblemService;
	
	@Autowired
	private ScmProblemTypeService scmProblemTypeService;
	
	@ModelAttribute
	public ScmProblem get(@RequestParam(required=false) String id) {
		ScmProblem entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = scmProblemService.get(id);
		}
		if (entity == null){
			entity = new ScmProblem();
		}
		return entity;
	}
	
	/**
	 * 知识列表页面
	 * @param scmProblem
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("scm:scmProblem:list")
	@RequestMapping(value = {"list", ""})
	public String list(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/scm/scmProblemList";
	}
	
	/**
	 * 查询数据列表
	 * @param scmProblem
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(ScmProblem scmProblem, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ScmProblem> page = scmProblemService.findPage(new Page<ScmProblem>(request, response), scmProblem); 
		return JsonMapper.getInstance().toJson(page);
	}
	
	/**
	 * 查询页面
	 * @param scmProblem
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "search")
	public String search(ScmProblem scmProblem, Model model) {		
		model.addAttribute("scmProblem", scmProblem);
		List<ScmProblemType> scmProblemTypeList = scmProblemTypeService.findList(new ScmProblemType()); 
		model.addAttribute("scmProblemTypeList", scmProblemTypeList);
		return "modules/scm/scmProblemSearch";
	}
	
	/**
	 * 知识详情页面
	 * @param scmProblem
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value="scm:scmProblem:view")
	@RequestMapping(value = "view")
	public String view(ScmProblem scmProblem, Model model) {
		model.addAttribute("scmProblem", scmProblem);
		
		return "modules/scm/scmProblemView";
	}
	
	/**
	 * 编辑知识表单页面
	 */
	@RequiresPermissions(value={"scm:scmProblem:view","scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(ScmProblem scmProblem, Model model) {
		
		model.addAttribute("scmProblem", scmProblem);
		
		List<ScmProblemType> scmProblemTypeList = scmProblemTypeService.findList(new ScmProblemType()); 
		model.addAttribute("scmProblemTypeList", scmProblemTypeList);
		
		return "modules/scm/scmProblemForm";
	}
	
	/**
	 * 保存知识
	 */
	@RequiresPermissions(value={"scm:scmProblem:add","scm:scmProblem:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(ScmProblem scmProblem, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, scmProblem)){
			return form(scmProblem, model);
		}
		
		try{
		
			scmProblem.setStatus("1");
			if(!scmProblem.getIsNewRecord()){//编辑表单保存				
				ScmProblem t = scmProblemService.get(scmProblem.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(scmProblem, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				scmProblemService.save(t);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PROBLEM, Contants.ACTION_TYPE_UPDATE, t.getId(), t.getName(), null);
			}else{//新增表单保存
				scmProblemService.save(scmProblem);//保存
				
				DynamicUtils.addDynamic(Contants.OBJECT_WMS_TYPE_PROBLEM, Contants.ACTION_TYPE_ADD, scmProblem.getId(), scmProblem.getName(), null);
			}
			addMessage(redirectAttributes, "保存知识成功");
			return "redirect:"+Global.getAdminPath()+"/mobile/scm/scmProblem/view?id="+scmProblem.getId();
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存知识失败");
			return "redirect:"+Global.getAdminPath()+"/mobile/scm/scmProblem/?repage";
		}
	}
}
