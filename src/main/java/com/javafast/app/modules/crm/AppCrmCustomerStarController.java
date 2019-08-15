package com.javafast.app.modules.crm;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.javafast.modules.crm.entity.CrmCustomerStar;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.sys.entity.SysBrowseLog;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysBrowseLogService;
import com.javafast.modules.sys.utils.DictUtils;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 我关注的客户 API Controller
 * @author javafast
 * @version 2017-08-10
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmCustomerStar")
public class AppCrmCustomerStarController extends BaseController {

	@Autowired
	private CrmCustomerStarService crmCustomerStarService;
	
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
			System.out.println(userId);
			CrmCustomerStar crmCustomerStar = new CrmCustomerStar();
			crmCustomerStar.setOwnBy(userId);
			crmCustomerStar.setIsApi(true);
			crmCustomerStar.setAccountId(accountId);//企业账号
			crmCustomerStar.setCurrentUser(new User(userId));//当前用户
			Page<CrmCustomerStar> conPage = new Page<CrmCustomerStar>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmCustomerStar.setPage(conPage);

			
			Page<CrmCustomerStar> page = crmCustomerStarService.findPage(conPage, crmCustomerStar);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<CrmCustomerStar> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmCustomerStar obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("customerId", obj.getCustomer().getId());
				objJson.put("customerName", obj.getCustomer().getName());
				objJson.put("customerStatus", DictUtils.getDictLabel(obj.getCustomer().getCustomerStatus(), "customer_status", ""));
				objJson.put("customerLevel", DictUtils.getDictLabel(obj.getCustomer().getCustomerLevel(), "customer_level", ""));
				if(obj.getCustomer().getNextcontactDate() != null){
					objJson.put("nextcontactDate", DateUtils.formatDate(obj.getCustomer().getNextcontactDate(), "yyyy-MM-dd"));
				}
				if(obj.getCustomer().getOwnBy() != null && StringUtils.isNotBlank(obj.getCustomer().getOwnBy().getName())){
					objJson.put("ownBy", obj.getCustomer().getOwnBy().getName());
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