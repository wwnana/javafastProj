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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 联系人 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmContacter")
public class AppCrmContacterController {

	@Autowired
	private CrmContacterService crmContacterService;
	
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
	public JSONObject getList(String userId, String accountId, String pageNo, String queryStr, String orderBy, HttpServletRequest request, HttpServletResponse response) {
		
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
			
			CrmContacter crmContacter = new CrmContacter();
			crmContacter.setIsApi(true);
			crmContacter.setAccountId(accountId);//企业账号
			crmContacter.setCurrentUser(new User(userId));//当前用户
			Page<CrmContacter> conPage = new Page<CrmContacter>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmContacter.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					crmContacter.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("mobile") && StringUtils.isNotBlank(queryObj.getString("mobile"))){					
					crmContacter.setMobile(queryObj.getString("mobile"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					crmContacter.setCustomer(customer);
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					crmContacter.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					crmContacter.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					crmContacter.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					crmContacter.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					crmContacter.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					crmContacter.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			
			Page<CrmContacter> page =crmContacterService.findPage(conPage, crmContacter);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<CrmContacter> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmContacter obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				objJson.put("mobile", obj.getMobile());
				if(obj.getCustomer() != null && StringUtils.isNotBlank(obj.getCustomer().getName()))
					objJson.put("customerNames", obj.getCustomer().getName());
				
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
			
			CrmContacter entity = crmContacterService.get(id);
			if(entity != null){
				
				json.put("entity", entity);
				json.put("createBy", entity.getCreateBy());
				json.put("ownBy", entity.getOwnBy());
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 保存
	 * @param id
	 * @param customerId
	 * @param name
	 * @param saleAmount
	 * @param periodType
	 * @param probability
	 * @param remarks
	 * @param accountId
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String customerId, String name, String sex, String jobType, String mobile, String tel, String qq, String email, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmContacter crmContacter;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			if(StringUtils.isBlank(customerId)){
				json.put("msg", "customerId参数错误");
				return json;
			}
			CrmCustomer crmCustomer = crmCustomerService.get(customerId);
			
			if(StringUtils.isNotBlank(id)){
				crmContacter = crmContacterService.get(id);
			}else{
				//新增
				crmContacter = new CrmContacter();
				
				crmContacter.setCustomer(crmCustomer);
				crmContacter.setAccountId(accountId);
				crmContacter.setOwnBy(new User(userId));
				crmContacter.setCreateBy(new User(userId));
				crmContacter.setUpdateBy(new User(userId));
			}
			
			//联系人基本信息
			crmContacter.setName(name);
			crmContacter.setSex(sex);
			crmContacter.setJobType(jobType);
			crmContacter.setMobile(mobile);
			crmContacter.setTel(tel);
			crmContacter.setQq(qq);
			crmContacter.setEmail(email);
			crmContacter.setRemarks(remarks);
			
			//保存联系人信息
			crmContacterService.save(crmContacter);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, Contants.ACTION_TYPE_UPDATE, crmContacter.getId(), crmContacter.getName(), crmContacter.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTACTER, Contants.ACTION_TYPE_ADD, crmContacter.getId(), crmContacter.getName(), crmContacter.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", crmContacter.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "del", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject del(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			crmContacterService.delete(new CrmContacter(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
