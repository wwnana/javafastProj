package com.javafast.modules.crm.api;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 客户 API Controller
 * @author javafast
 * @version 2017-08-10
 */
@Controller
@RequestMapping(value = "${adminPath}/api/crm/crmCustomer")
public class ApiCrmCustomerController extends BaseController {

	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	/**
	 * 分页查询列表
	 * @param pageNo 当前页码
	 * @param title
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String accountId, String pageNo, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {

			//校验输入参数
			if(StringUtils.isBlank(pageNo)){
				json.put("msg", "缺少参数pageNo");
				return json;
			}
			
			CrmCustomer crmCustomer = new CrmCustomer();
			crmCustomer.setIsApi(true);
			crmCustomer.setAccountId(accountId);
			Page<CrmCustomer> conPage = new Page<CrmCustomer>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmCustomer.setPage(conPage);
			Page<CrmCustomer> page = crmCustomerService.findPage(conPage, crmCustomer);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			json.put("list", page.getList());
			json.put("count", page.getCount());
			json.put("code", "1");
		} catch (Exception e) {
			json.put("error", "");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 根据ID查询
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmCustomer entity = crmCustomerService.get(id);
			if(entity != null){
				
				json.put("entity", entity);				
				json.put("code", "1");
			}			
		} catch (Exception e) {
			json.put("code", "404");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 保存(新增或修改)
	 * @param name
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String name, String contacterName, String mobile, String customerStatus, String customerLevel, String phone, String province, String city , String dict, String address, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmCustomer crmCustomer;
			
			if(StringUtils.isNotBlank(id)){
				
				//校验输入参数
				if(StringUtils.isBlank(id)){
					json.put("msg", "缺少参数id");
					return json;
				}
				
				crmCustomer = crmCustomerService.get(id);
				
				if(crmCustomer == null){
					json.put("msg", "id参数错误");
					return json;
				}
			}else{
				crmCustomer = new CrmCustomer();
			}
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(contacterName) && contacterName.length()>30){
				json.put("msg", "contacterName参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(mobile) && mobile.length()>11){
				json.put("msg", "mobile参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(customerStatus) && (customerStatus.length()>1 || !"0".equals(customerStatus) || !"1".equals(customerStatus) || !"2".equals(customerStatus) || !"3".equals(customerStatus))){
				json.put("msg", "customerStatus参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(customerLevel) && (customerLevel.length()>1 || !"0".equals(customerLevel) || !"1".equals(customerLevel) || !"2".equals(customerLevel))){
				json.put("msg", "customerLevel参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(phone) && phone.length()>20){
				json.put("msg", "phone参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(province) && province.length()>20){
				json.put("msg", "province参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(city) && city.length()>20){
				json.put("msg", "city参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(dict) && dict.length()>20){
				json.put("msg", "dict参数错误");
				return json;
			}
			if(StringUtils.isNotBlank(address) && address.length()>50){
				json.put("msg", "address参数错误");
				return json;
			}
			
			//客户基本信息
			crmCustomer.setName(name);
			crmCustomer.setContacterName(contacterName);
			crmCustomer.setMobile(mobile);
			crmCustomer.setCustomerStatus(customerStatus);
			crmCustomer.setCustomerLevel(customerLevel);
			crmCustomer.setAccountId(accountId);
			
			
			//保持客户信息
			crmCustomerService.save(crmCustomer);
			
			json.put("code", "1");
		} catch (Exception e) {
			json.put("code", "404");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 根据ID删除
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "delById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			crmCustomerService.delete(new CrmCustomer(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			json.put("code", "404");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}