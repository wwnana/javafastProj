package com.javafast.modules.main.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.modules.report.entity.SysSearch;
import com.javafast.modules.report.service.SysSearchService;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 全局搜索
 * @author syh
 *
 */
@Controller
public class SearchController extends BaseController{

	@Autowired
	private SysSearchService sysSearchService;
	
	@Autowired
	private SysBrowseLogService sysBrowseLogService;
	
	/**
	 * 全局搜索 支持搜索客户、联系人、商机、合同、项目、任务
	 * @param sysSearch
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "${adminPath}/search")
	public String search(SysSearch sysSearch, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		String keyWords = request.getParameter("keyWords");
		if(StringUtils.isNotBlank(keyWords)){
			
			sysSearch.setAccountId(UserUtils.getUser().getAccountId());
			Page<SysSearch> page = sysSearchService.findPage(new Page<SysSearch>(request, response), sysSearch);
			
			List<SysSearch> list = new ArrayList<SysSearch>();
			
			for(int i=0;i<page.getList().size();i++){
				
				SysSearch entity = page.getList().get(i);
				
				String name = entity.getName().replace(keyWords, "<span style=\"color:#ed5565;\">"+keyWords+"</span>");
				
				entity.setName(name);
				list.add(entity);
			}
			
			page.setList(list);
			model.addAttribute("page", page);
			model.addAttribute("keyWords", keyWords);
		}

		//浏览足迹
	    Page<SysBrowseLog> browseLogPage = sysBrowseLogService.findPage(new Page<SysBrowseLog>(request, response), new SysBrowseLog());
	    model.addAttribute("browseLogPage", browseLogPage);
	    
		return "modules/main/sysSearch";
	}
}
