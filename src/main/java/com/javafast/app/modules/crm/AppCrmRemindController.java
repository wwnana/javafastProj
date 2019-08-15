package com.javafast.app.modules.crm;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.utils.DictUtils;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 联系提醒 API Controller
 * @author javafast
 * @version 2017-08-10
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmRemind")
public class AppCrmRemindController extends BaseController {

	@Autowired
	private CrmCustomerService crmCustomerService;
	
	/**
	 * 分页查询列表
	 * @param pageNo 当前页码
	 * @param title
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String userId, String accountId, String pageNo, HttpServletRequest request, HttpServletResponse response) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {

			//校验输入参数
			if(StringUtils.isBlank(pageNo)){
				json.put("msg", "缺少参数pageNo");
				return json;
			}
			if(StringUtils.isBlank(accountId)){
				json.put("msg", "缺少参数accountId");
				return json;
			}
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			CrmCustomer crmCustomer = new CrmCustomer();
			crmCustomer.setBeginNextcontactDate(DateUtils.getEndDayOfYesterDay());
			crmCustomer.setEndNextcontactDate(DateUtils.getDayAfterN(30));
			
			crmCustomer.setIsApi(true);
			crmCustomer.setAccountId(accountId);//企业账号
			crmCustomer.setCurrentUser(new User(userId));//当前用户
			Page<CrmCustomer> conPage = new Page<CrmCustomer>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmCustomer.setPage(conPage);

			
			Page<CrmCustomer> page = crmCustomerService.findPage(conPage, crmCustomer);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<CrmCustomer> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmCustomer obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				objJson.put("customerStatus", DictUtils.getDictLabel(obj.getCustomerStatus(), "customer_status", ""));
				objJson.put("customerLevel", DictUtils.getDictLabel(obj.getCustomerLevel(), "customer_level", ""));
				if(obj.getNextcontactDate() != null){
					objJson.put("nextcontactDate", DateUtils.formatDate(obj.getNextcontactDate(), "yyyy-MM-dd"));
				}
				if(obj.getOwnBy() != null && StringUtils.isNotBlank(obj.getOwnBy().getName())){
					objJson.put("ownBy", obj.getOwnBy().getName());
				}
				
				jsonArray.add(objJson);
			}
			
			json.put("list", jsonArray);
			json.put("lastPage", page.isLastPage());
			json.put("count", page.getCount());
			json.put("code", "1");
		} catch (Exception e) {
			json.put("error", "");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
}