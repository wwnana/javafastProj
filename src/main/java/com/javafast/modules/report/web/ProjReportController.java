package com.javafast.modules.report.web;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.common.web.BaseController;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.report.entity.ProjReport;


@Controller
@RequestMapping(value = "${adminPath}/report/projReport")
public class ProjReportController extends BaseController {

	@Autowired
	private OaProjectService oaProjectService;

	/**
	 *产品销售统计
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("report:projReport:report")
	@RequestMapping(value = "list")
	public String report(ProjReport projReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		//已完成
		String finishNum = oaProjectService.getProjNum("2");
		//已开始
		String startNum = oaProjectService.getProjNum("1");
		//未开始
		String waitNum = oaProjectService.getProjNum("0");
		//已关闭
		String closedNum = oaProjectService.getProjNum("3");
		
		projReport.setFinishNum(finishNum);
		projReport.setStartNum(startNum);
		projReport.setWaitNum(waitNum);
		projReport.setClosedNum(closedNum);
		
		
		model.addAttribute("projReport", projReport);
				
		return "modules/report/projectReport";
	}
	
}