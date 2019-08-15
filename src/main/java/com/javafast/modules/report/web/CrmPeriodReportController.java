package com.javafast.modules.report.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.web.BaseController;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.service.CrmReportService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 销售阶段统计报表Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/report/periodReport")
public class CrmPeriodReportController extends BaseController {
	
	@Autowired
	private CrmReportService crmReportService;

	/**
	 * 销售阶段统计
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("report:periodReport:report")
	@RequestMapping(value = "list")
	public String customerReport(CrmReport crmReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		
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
		
		List<CrmReport> periodReportList = crmReportService.findReportList(crmReport);
		model.addAttribute("periodReportList", periodReportList);
		
		return "modules/report/periodReport";
	}
	
	/**
	 * 导出
	 * @param crmReport
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("report:crmReport:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String export(CrmReport crmReport, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "客户统计"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
           
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
    		
    		List<CrmReport> crmReportList = crmReportService.findReportList(crmReport);
    		
    		new ExportExcel("客户统计", CrmReport.class).setDataList(crmReportList).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出客户统计失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/report/crmReport/customerReport?repage";
    }
}