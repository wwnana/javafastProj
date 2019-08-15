package com.javafast.app.modules.om;

import java.math.BigDecimal;
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
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.wms.entity.WmsOutstock;
import com.javafast.modules.wms.service.WmsOutstockService;

/**
 * 合同 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/om/omContract")
public class AppOmContractController {

	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private WmsOutstockService wmsOutstockService;
	
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
			
			OmContract omContract = new OmContract();
			omContract.setIsApi(true);
			omContract.setAccountId(accountId);//企业账号
			omContract.setCurrentUser(new User(userId));//当前用户
			Page<OmContract> conPage = new Page<OmContract>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			omContract.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					omContract.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					omContract.setNo(queryObj.getString("no"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					omContract.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					omContract.setCustomer(customer);
				}
				if(queryObj.containsKey("auditById") && StringUtils.isNotBlank(queryObj.getString("auditById"))){					
					omContract.setAuditBy(new User(queryObj.getString("auditById")));
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					omContract.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					omContract.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					omContract.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					omContract.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					omContract.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					omContract.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<OmContract> page =omContractService.findPage(conPage, omContract);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OmContract> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OmContract obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("name", obj.getName());
				objJson.put("amount", obj.getAmount());
				objJson.put("status", obj.getStatus());
				objJson.put("customer", obj.getCustomer().getName());
				objJson.put("dealDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
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
			
			OmContract entity = omContractService.get(id);
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
	@RequestMapping(value = "getContractById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getContractById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OmContract omContract = omContractService.get(id);
			if(omContract != null){
				
				json.put("entity", omContract);
				
				//如果是已经审核的合同，还需要查询关联的应收款、出库单
				
				//查询应收款
				FiReceiveAble fiReceiveAble = new FiReceiveAble();
				fiReceiveAble.setOrder(omContract.getOrder());
				List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findFiReceiveAbleList(fiReceiveAble);
				json.put("fiReceiveAbleList", fiReceiveAbleList);
				
				//查询出库单
				WmsOutstock conWmsOutstock = new WmsOutstock();
				conWmsOutstock.setOrder(omContract.getOrder());
				List<WmsOutstock> wmsOutstockList = wmsOutstockService.findList(conWmsOutstock);
				json.put("wmsOutstockList", wmsOutstockList);
				
				//查询日志
				SysDynamic conSysDynamic = new SysDynamic();
				conSysDynamic.setTargetId(omContract.getId());
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
	public JSONObject save(String id, String customerId, String name, String amount, String dealDate, String endDate, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OmContract omContract;
			
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
				omContract = omContractService.get(id);
				omContract.setUpdateBy(new User(userId));
			}else{
				//新增
				omContract = new OmContract();
				omContract.setNo("DD"+IdUtils.getId());
				
				omContract.setCustomer(crmCustomer);
				omContract.setAccountId(accountId);
				omContract.setOwnBy(new User(userId));
				omContract.setCreateBy(new User(userId));
				omContract.setUpdateBy(new User(userId));
			}
			
			//合同基本信息
			omContract.setNo(IdUtils.getId());
			omContract.setName(name);
			omContract.setAmount(new BigDecimal(amount));
			omContract.setDealDate(DateUtils.parseDate(dealDate));
			omContract.setEndDate(DateUtils.parseDate(endDate));
			omContract.setRemarks(remarks);
			
			//保存合同信息
			omContract.setStatus("0");
			omContractService.save(omContract);
			
			if(StringUtils.isBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_UPDATE, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_ADD, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", omContract.getId());
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
			
			OmContract omContract = omContractService.get(id);
			if("0".equals(omContract)){
				
				omContractService.delete(omContract);
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
			
			OmContract omContract = omContractService.get(id);
			if("0".equals(omContract)){
				
				omContract.setAuditBy(new User(userId));
				omContractService.audit(omContract);
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CONTRACT_ORDER, Contants.ACTION_TYPE_AUDIT, omContract.getId(), omContract.getNo(), omContract.getCustomer().getId(), userId, accountId);
				json.put("code", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
