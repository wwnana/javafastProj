package com.javafast.app.modules.fi;

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
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.entity.FiReceiveBill;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.fi.service.FiReceiveBillService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 收款单 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/fi/fiReceiveBill")
public class AppFiReceiveBillController {

	@Autowired
	private FiReceiveBillService fiReceiveBillService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
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
			
			FiReceiveBill fiReceiveBill = new FiReceiveBill();
			fiReceiveBill.setIsApi(true);
			fiReceiveBill.setAccountId(accountId);//企业账号
			fiReceiveBill.setCurrentUser(new User(userId));//当前用户
			Page<FiReceiveBill> conPage = new Page<FiReceiveBill>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			fiReceiveBill.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					fiReceiveBill.setNo(queryObj.getString("no"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					fiReceiveBill.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					fiReceiveBill.setCustomer(customer);
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					fiReceiveBill.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					fiReceiveBill.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					fiReceiveBill.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					fiReceiveBill.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					fiReceiveBill.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					fiReceiveBill.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<FiReceiveBill> page =fiReceiveBillService.findPage(conPage, fiReceiveBill);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<FiReceiveBill> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				FiReceiveBill obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("customerName", obj.getCustomer().getName());
				objJson.put("status", DictUtils.getDictLabel(obj.getStatus(), "audit_status", ""));
				objJson.put("amount", obj.getAmount());
				objJson.put("dealDate", DateUtils.formatDate(obj.getDealDate(), "yyyy-MM-dd"));
				if(obj.getOwnBy() != null && StringUtils.isNotBlank(obj.getOwnBy().getName()))
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
			
			FiReceiveBill entity = fiReceiveBillService.get(id);
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
	public JSONObject save(String id, String receiveAbleId, String amount, String dealDate, String fiAccountId, String invoiceAmt, String remarks, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			FiReceiveBill fiReceiveBill;
			
			//校验输入参数
			if(StringUtils.isBlank(amount)){
				json.put("msg", "amount参数错误");
				return json;
			}
			
			FiReceiveAble fiReceiveAble = fiReceiveAbleService.get(receiveAbleId);
			
			if(StringUtils.isNotBlank(id)){
				fiReceiveBill = fiReceiveBillService.get(id);
				
				if("1".equals(fiReceiveBill.getStatus())){
					json.put("code", "1");
					return json;
				}
				
			}else{
				//新增
				fiReceiveBill = new FiReceiveBill();
				fiReceiveBill.setNo("SK"+IdUtils.getId());
				
				fiReceiveBill.setAccountId(accountId);
				fiReceiveBill.setCreateBy(new User(userId));
				fiReceiveBill.setUpdateBy(new User(userId));
			}
			
			if(fiReceiveAble.getCustomer() != null){
				fiReceiveBill.setCustomer(fiReceiveAble.getCustomer());
			}
			
			//收款单基本信息
			fiReceiveBill.setFiReceiveAble(fiReceiveAble);
			fiReceiveBill.setAmount(new BigDecimal(amount));
			fiReceiveBill.setDealDate(DateUtils.parseDate(dealDate, "yyyy-MM-dd"));
			fiReceiveBill.setOwnBy(new User(ownById));
			fiReceiveBill.setRemarks(remarks);
			
			fiReceiveBill.setFiAccount(new FiFinanceAccount(fiAccountId));
			if(StringUtils.isNotBlank(invoiceAmt)){
				fiReceiveBill.setIsInvoice("1");
				fiReceiveBill.setInvoiceAmt(new BigDecimal(invoiceAmt));
			}
			
			//保存收款单信息
			fiReceiveBill.setStatus("0");
			fiReceiveBillService.save(fiReceiveBill);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_UPDATE, fiReceiveBill.getId(), fiReceiveBill.getNo(), fiReceiveBill.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_ADD, fiReceiveBill.getId(), fiReceiveBill.getNo(), fiReceiveBill.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", fiReceiveBill.getId());
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
			
			FiReceiveBill fiReceiveBill = fiReceiveBillService.get(id);
			if("0".equals(fiReceiveBill.getStatus())){
				
				fiReceiveBillService.delete(new FiReceiveBill(id));
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
	 * @param userId
	 * @param accountId
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
			
			FiReceiveBill fiReceiveBill = fiReceiveBillService.get(id);
			if("0".equals(fiReceiveBill.getStatus())){
				
				fiReceiveBill.setAuditBy(new User(userId));
				fiReceiveBillService.audit(fiReceiveBill);
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVEBILL, Contants.ACTION_TYPE_AUDIT, fiReceiveBill.getId(), fiReceiveBill.getNo(), fiReceiveBill.getCustomer().getId(), userId, accountId);
			}
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
