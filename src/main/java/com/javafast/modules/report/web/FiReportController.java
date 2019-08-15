package com.javafast.modules.report.web;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.service.CrmReportService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 财务统计报表Controller
 * @author shi
 * @version 2016-06-28
 */
@Controller
@RequestMapping(value = "${adminPath}/report/fiReport")
public class FiReportController extends BaseController {

	@Autowired
	private CrmReportService crmReportService;

	/**
	 *财务统计
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("report:fiReport:report")
	@RequestMapping(value = "list")
	public String achReport(CrmReport crmReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		// 设置默认时间范围，默认当前月
		if (crmReport.getStartDate() == null){
			crmReport.setStartDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
		}
		if (crmReport.getEndDate() == null){
			crmReport.setEndDate(DateUtils.addMonths(crmReport.getStartDate(), 1));
		}
		
		crmReport.setAccountId(UserUtils.getUser().getAccountId());
		if(crmReport.getEndDate() != null)
			crmReport.setEndDate(DateUtils.parseDate(DateUtils.formatDate(crmReport.getEndDate())+" 23:59:59"));
		
		List<CrmReport> crmReportList = crmReportService.findFiReportList(crmReport);
		model.addAttribute("crmReportList", crmReportList);
				
		return "modules/report/fiReport";
	}
	
}