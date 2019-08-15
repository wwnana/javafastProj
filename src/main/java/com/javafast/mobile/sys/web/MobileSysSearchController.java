package com.javafast.mobile.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.modules.report.entity.SysSearch;
import com.javafast.modules.report.service.SysSearchService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 全局搜索
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/mobile/sys/sysSearch")
public class MobileSysSearchController extends BaseController{

	@Autowired
	private SysSearchService sysSearchService;
	
	/**
	 * 全局搜索 支持搜索客户、联系人、商机、合同、项目、任务
	 * @param sysSearch
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = {"list", ""})
	public String search(SysSearch sysSearch, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//查询搜索历史
		
		System.out.println("查询搜索历史");
		return "modules/sys/sysSearch";
	}
	
	/**
	 * 加载搜索结果数据
	 * @param sysSearch
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "listData")
	public String listData(SysSearch sysSearch, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		String keyWords = request.getParameter("keyWords");
		if(StringUtils.isNotBlank(keyWords)){
			
			sysSearch.setAccountId(UserUtils.getUser().getAccountId());
			Page<SysSearch> page = sysSearchService.findPage(new Page<SysSearch>(request, response), sysSearch);
			return JsonMapper.getInstance().toJson(page);
		}
		return null;
	}
}
