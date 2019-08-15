package com.javafast.app.modules.crm;

import java.math.BigDecimal;
import java.util.Date;
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
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 报价单API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmQuote")
public class AppCrmQuoteController {

	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private OmContractService omContractService;
	
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
			
			CrmQuote crmQuote = new CrmQuote();
			crmQuote.setIsApi(true);
			crmQuote.setAccountId(accountId);//企业账号
			crmQuote.setCurrentUser(new User(userId));//当前用户
			Page<CrmQuote> conPage = new Page<CrmQuote>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmQuote.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					crmQuote.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					crmQuote.setNo(queryObj.getString("no"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					crmQuote.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					crmQuote.setCustomer(customer);
				}
				if(queryObj.containsKey("auditById") && StringUtils.isNotBlank(queryObj.getString("auditById"))){					
					crmQuote.setAuditBy(new User(queryObj.getString("auditById")));
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					crmQuote.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					crmQuote.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					crmQuote.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					crmQuote.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					crmQuote.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					crmQuote.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<CrmQuote> page =crmQuoteService.findPage(conPage, crmQuote);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<CrmQuote> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmQuote obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("amount", obj.getAmount());
				objJson.put("status", obj.getStatus());
				objJson.put("customer", obj.getCustomer().getName());
				objJson.put("startDate", DateUtils.formatDate(obj.getStartdate(), "yyyy-MM-dd"));
				objJson.put("endDate", DateUtils.formatDate(obj.getEnddate(), "yyyy-MM-dd"));
				objJson.put("ownBy", obj.getOwnBy().getName());
				
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
			
			CrmQuote entity = crmQuoteService.get(id);
			if(entity != null){
				json.put("entity", entity);				
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getQuoteById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getQuoteById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmQuote crmQuote = crmQuoteService.get(id);
			if(crmQuote != null){
				
				json.put("entity", crmQuote);
				
				System.out.println(crmQuote.getAccountId());
				//查询关联合同
				OmContract conOmContract = new OmContract();
				conOmContract.setIsApi(true);
				conOmContract.setAccountId(crmQuote.getAccountId());
				conOmContract.setQuote(crmQuote);
				List<OmContract> omContractList = omContractService.findList(conOmContract);
				json.put("omContractList", omContractList);
				
				//查询日志
				SysDynamic conSysDynamic = new SysDynamic();
				conSysDynamic.setTargetId(crmQuote.getId());
				List<SysDynamic> sysDynamicList = sysDynamicService.findList(conSysDynamic);
				JSONArray jsonArray = new JSONArray();
				for(int i=0;i<sysDynamicList.size();i++){			
					
					SysDynamic obj = sysDynamicList.get(i);
					
					JSONObject objJson = new JSONObject();
					objJson.put("userName", obj.getCreateBy().getName());
					objJson.put("content", DictUtils.getDictLabel(obj.getActionType(), "action_type", "")+"了"+DictUtils.getDictLabel(obj.getObjectType(), "object_type", ""));
					objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd HH:mm"));
					jsonArray.add(objJson);
				}
				json.put("sysDynamicList", jsonArray);
						
				
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
	 * @param amount
	 * @param startDate
	 * @param endDate
	 * @param remarks
	 * @param accountId
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String customerId, String amount, String startDate, String endDate, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmQuote crmQuote;
			
			//校验输入参数
			if(StringUtils.isBlank(amount)){
				json.put("msg", "amount参数错误");
				return json;
			}
			if(StringUtils.isBlank(customerId)){
				json.put("msg", "customerId参数错误");
				return json;
			}
			CrmCustomer crmCustomer = crmCustomerService.get(customerId);
			
			if(StringUtils.isNotBlank(id)){
				crmQuote = crmQuoteService.get(id);
				crmQuote.setUpdateBy(new User(userId));
			}else{
				//新增
				crmQuote = new CrmQuote();
				crmQuote.setNo("BJ"+IdUtils.getId());
				
				crmQuote.setCustomer(crmCustomer);
				crmQuote.setAccountId(accountId);
				crmQuote.setOwnBy(new User(userId));
				crmQuote.setCreateBy(new User(userId));
				crmQuote.setUpdateBy(new User(userId));
			}
			
			//报价单基本信息
			crmQuote.setNo(IdUtils.getId());
			crmQuote.setAmount(new BigDecimal(amount));
			crmQuote.setStartdate(DateUtils.parseDate(startDate));
			crmQuote.setEnddate(DateUtils.parseDate(endDate));
			crmQuote.setRemarks(remarks);
			
			//保存报价单信息
			crmQuote.setStatus("0");
			crmQuoteService.save(crmQuote);
			
			if(StringUtils.isBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_UPDATE, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_ADD, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", crmQuote.getId());
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
	public JSONObject del(String id, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmQuote crmQuote = crmQuoteService.get(id);
			if("0".equals(crmQuote)){
				
				crmQuoteService.delete(crmQuote);
			}
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 审核
	 * @param id
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "audit", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject audit(String id, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmQuote crmQuote = crmQuoteService.get(id);
			if("0".equals(crmQuote)){
				
				crmQuote.setAuditBy(new User(userId));
				crmQuote.setAuditDate(new Date());
				crmQuoteService.audit(crmQuote);
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_QUOTE, Contants.ACTION_TYPE_AUDIT, crmQuote.getId(), crmQuote.getNo(), crmQuote.getCustomer().getId(), userId, accountId);
				json.put("code", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
