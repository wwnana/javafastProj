package com.javafast.app.modules.crm;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.report.entity.CrmReport;
import com.javafast.modules.report.utils.ReportUtils;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 统计 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmReport")
public class AppCrmReportController {

	@Autowired
	private CrmChanceService crmChanceService;
	
	/**
	 * 
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getCrmReport", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getCrmReport(String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			User user = new User();
			user.setId(userId);
			user.setAccountId(accountId);
			
			
			//查询销售数据总览
			String dateType = "M";// 设置默认时间范围，默认当前月
			CrmReport myCrmReport = ReportUtils.getCrmReport(user, dateType, accountId);
			json.put("entity", myCrmReport);
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 
	 * @param userId
	 * @param accountId
	 * @param pageNo
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getCustomerList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getCustomerList(String userId, String accountId, String pageNo, HttpServletRequest request, HttpServletResponse response) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			CrmChance crmChance = new CrmChance();
			crmChance.setIsApi(true);
			crmChance.setAccountId(accountId);//企业账号
			crmChance.setCurrentUser(new User(userId));//当前用户
			Page<CrmChance> conPage = new Page<CrmChance>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmChance.setPage(conPage);
			Page<CrmChance> page = crmChanceService.findPage(conPage, crmChance);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			List<CrmChance> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmChance obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				objJson.put("customerName", obj.getCustomer().getName());
				objJson.put("periodType", DictUtils.getDictLabel(obj.getPeriodType(), "period_type", ""));
				objJson.put("saleAmount", obj.getSaleAmount());
				objJson.put("probability", obj.getProbability());
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
				if(obj.getOwnBy() != null)
					objJson.put("ownBy", obj.getOwnBy().getName());
				
				jsonArray.add(objJson);
			}
			
			json.put("list", jsonArray);
			json.put("lastPage", page.isLastPage());
			json.put("count", page.getCount());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
