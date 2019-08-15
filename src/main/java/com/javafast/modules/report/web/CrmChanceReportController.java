package com.javafast.modules.report.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.modules.report.entity.CrmChanceReport;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.service.CrmChanceReportService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 销售漏斗分析
 * @author GuJianfeng
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/report/crmChanceReport")
public class CrmChanceReportController {

	@Autowired
	CrmChanceReportService crmChanceReportService;
	
	/**
	 * 销售漏斗分析
	 * @param crmChanceReport
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "list")
	public String chanceReport(CrmChanceReport crmChanceReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		// 设置默认时间范围，默认当前月
		if (crmChanceReport.getStartDate() == null){
			crmChanceReport.setStartDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
		}
		if (crmChanceReport.getEndDate() == null){
			crmChanceReport.setEndDate(DateUtils.addMonths(crmChanceReport.getStartDate(), 1));
		}
				
		crmChanceReport.setAccountId(UserUtils.getUser().getAccountId());
		//crmChanceReport.setUser(UserUtils.getUser());
		if(crmChanceReport.getEndDate() != null) {
			crmChanceReport.setEndDate(DateUtils.parseDate(DateUtils.formatDate(crmChanceReport.getEndDate())+" 23:59:59"));
		}
		
		CrmChanceReport chanceReport = crmChanceReportService.findChanceReport(crmChanceReport);
	
		Map<String,Object> orientData = new HashMap<String,Object>();
		if(chanceReport != null && chanceReport.getTotalChanceNum() > 0) {
			orientData.put("1.初步恰接", chanceReport.getPurposeCustomerNum()*100/chanceReport.getTotalChanceNum());
			orientData.put("2.需求确定", chanceReport.getDemandCustomerNum()*100/chanceReport.getTotalChanceNum());
			orientData.put("3.方案报价", chanceReport.getQuoteCustomerNum()*100/chanceReport.getTotalChanceNum());
			orientData.put("4.合同签订", chanceReport.getDealOrderNum()*100/chanceReport.getTotalChanceNum());
			orientData.put("5.赢单", chanceReport.getCompleteOrderNum()*100/chanceReport.getTotalChanceNum());
		}
		
		request.setAttribute("orientData", orientData);
		return "modules/report/chanceReport";
	}
	
}
