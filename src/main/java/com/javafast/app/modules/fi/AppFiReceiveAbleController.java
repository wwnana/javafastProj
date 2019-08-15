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
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 应收款 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/fi/fiReceiveAble")
public class AppFiReceiveAbleController {

	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
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
			
			FiReceiveAble fiReceiveAble = new FiReceiveAble();
			fiReceiveAble.setIsApi(true);
			fiReceiveAble.setAccountId(accountId);//企业账号
			fiReceiveAble.setCurrentUser(new User(userId));//当前用户
			Page<FiReceiveAble> conPage = new Page<FiReceiveAble>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			fiReceiveAble.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					fiReceiveAble.setNo(queryObj.getString("no"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					fiReceiveAble.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					fiReceiveAble.setCustomer(customer);
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					fiReceiveAble.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					fiReceiveAble.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					fiReceiveAble.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					fiReceiveAble.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					fiReceiveAble.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					fiReceiveAble.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<FiReceiveAble> page =fiReceiveAbleService.findPage(conPage, fiReceiveAble);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<FiReceiveAble> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				FiReceiveAble obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				if(obj.getCustomer() != null && StringUtils.isNotBlank(obj.getCustomer().getName()))
					objJson.put("customerName", obj.getCustomer().getName());
				objJson.put("status", DictUtils.getDictLabel(obj.getStatus(), "finish_status", ""));
				objJson.put("amount", obj.getAmount());
				objJson.put("realAmt", obj.getRealAmt());
				if(obj.getAbleDate() != null)
					objJson.put("ableDate", DateUtils.formatDate(obj.getAbleDate(), "yyyy-MM-dd"));
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
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
			
			FiReceiveAble entity = fiReceiveAbleService.get(id);
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
	public JSONObject save(String id, String customerId, String amount, String ableDate, String remarks, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			FiReceiveAble fiReceiveAble;
			
			//校验输入参数
			if(StringUtils.isBlank(amount)){
				json.put("msg", "amount参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				fiReceiveAble = fiReceiveAbleService.get(id);
				fiReceiveAble.setUpdateBy(new User(userId));
			}else{
				//新增
				fiReceiveAble = new FiReceiveAble();
				
				fiReceiveAble.setNo("YS"+IdUtils.getId());
				fiReceiveAble.setAccountId(accountId);
				fiReceiveAble.setCreateBy(new User(userId));
				fiReceiveAble.setUpdateBy(new User(userId));
				fiReceiveAble.setStatus("0");
			}
			
			if(StringUtils.isNotBlank(customerId)){
				CrmCustomer crmCustomer = crmCustomerService.get(customerId);
				fiReceiveAble.setCustomer(crmCustomer);
			}
			
			//应收款基本信息
			fiReceiveAble.setAmount(new BigDecimal(amount));
			fiReceiveAble.setAbleDate(DateUtils.parseDate(ableDate, "yyyy-MM-dd"));
			fiReceiveAble.setRemarks(remarks);
			fiReceiveAble.setOwnBy(new User(ownById));
			
			//保存应收款信息
			fiReceiveAbleService.save(fiReceiveAble);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_UPDATE, fiReceiveAble.getId(), fiReceiveAble.getNo(), fiReceiveAble.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_FI_TYPE_RECEIVABLE, Contants.ACTION_TYPE_ADD, fiReceiveAble.getId(), fiReceiveAble.getNo(), fiReceiveAble.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", fiReceiveAble.getId());
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
	public JSONObject delById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			fiReceiveAbleService.delete(new FiReceiveAble(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
