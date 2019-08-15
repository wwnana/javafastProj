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
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.entity.CrmQuote;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
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
 * 商机 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmChance")
public class AppCrmChanceController {

	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
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
			
			CrmChance crmChance = new CrmChance();
			crmChance.setIsApi(true);
			crmChance.setAccountId(accountId);//企业账号
			crmChance.setCurrentUser(new User(userId));//当前用户
			Page<CrmChance> conPage = new Page<CrmChance>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmChance.setPage(conPage);
			
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					crmChance.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("periodType") && StringUtils.isNotBlank(queryObj.getString("periodType"))){					
					crmChance.setPeriodType(queryObj.getString("periodType"));
				}
				if(queryObj.containsKey("customerName") && StringUtils.isNotBlank(queryObj.getString("customerName"))){		
					CrmCustomer customer = new CrmCustomer();
					customer.setName(queryObj.getString("customerName"));
					crmChance.setCustomer(customer);
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					crmChance.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					crmChance.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					crmChance.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					crmChance.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					crmChance.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					crmChance.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			
			Page<CrmChance> page =crmChanceService.findPage(conPage, crmChance);
			
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
				objJson.put("periodType", DictUtils.getDictLabel(obj.getPeriodType(), "period_type", ""));
				objJson.put("saleAmount", obj.getSaleAmount());
				objJson.put("probability", obj.getProbability());
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
				if(obj.getOwnBy() != null)
					objJson.put("ownBy", obj.getOwnBy().getName());
				objJson.put("customerName", obj.getCustomer().getName());
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
			
			CrmChance entity = crmChanceService.get(id);
			if(entity != null){

				json.put("entity", entity);		
				if(entity.getNextcontactDate() != null){
					json.put("nextcontactDate", DateUtils.formatDate(entity.getNextcontactDate(), "yyyy-MM-dd"));
				}
				
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
	@RequestMapping(value = "getChanceById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getChanceById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmChance crmChance = crmChanceService.get(id);
			if(crmChance != null){
				
				json.put("entity", crmChance);
				if(crmChance.getNextcontactDate() != null){
					json.put("nextcontactDate", DateUtils.formatDate(crmChance.getNextcontactDate(), "yyyy-MM-dd"));
				}
				
				//所属客户
				CrmCustomer crmCustomer = crmCustomerService.get(crmChance.getCustomer().getId());
				
				//商机跟进记录
				CrmContactRecord conCrmContactRecord = new CrmContactRecord();
				conCrmContactRecord.setTargetId(crmChance.getId());
				List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByTargetId(conCrmContactRecord);
				json.put("crmChanceRecordList", crmContactRecordList);
				
				//查询联系人
				CrmContacter crmContacter = new CrmContacter();
				crmContacter.setCustomer(crmCustomer);
				List<CrmContacter> crmContacterList = crmContacterService.findListByCustomer(crmContacter);
				json.put("crmContacterList", crmContacterList);
				
				//查询关联报价单
				CrmQuote crmQuote = new CrmQuote();
				crmQuote.setChance(crmChance);
				List<CrmQuote> quoteList = crmQuoteService.findListByCustomer(crmQuote);
				json.put("crmQuoteList", quoteList);
				
				//查询关联订单合同
				OmContract conOmContract = new OmContract();
				conOmContract.setChance(crmChance);
				List<OmContract> omContractList = omContractService.findListByCustomer(conOmContract);
				json.put("omContractList", omContractList);
				
				//查询操作记录
				List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, crmChance.getId()));
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
	public JSONObject save(String id, String customerId, String name, String saleAmount, String periodType, String probability, String remarks, 
			String nextcontactDate, String nextcontactNote, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmChance crmChance;
			
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
				crmChance = crmChanceService.get(id);
				crmChance.setUpdateBy(new User(userId));
			}else{
				//新增
				crmChance = new CrmChance();
				
				crmChance.setCustomer(crmCustomer);
				crmChance.setAccountId(accountId);
				crmChance.setCreateBy(new User(userId));
				crmChance.setUpdateBy(new User(userId));
				
			}
			
			//商机基本信息
			crmChance.setName(name);
			crmChance.setSaleAmount(saleAmount);
			crmChance.setPeriodType(periodType);
			crmChance.setProbability(Integer.parseInt(probability));
			crmChance.setRemarks(remarks);
			crmChance.setOwnBy(new User(ownById));
			
			//下次联系提醒
			if(StringUtils.isNotBlank(nextcontactDate)){
				crmChance.setNextcontactDate(DateUtils.parseDate(nextcontactDate, "yyyy-MM-dd"));
				crmChance.setNextcontactNote(nextcontactNote);
			}
			
			//保存商机信息
			crmChanceService.save(crmChance);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_UPDATE, crmChance.getId(), crmChance.getName(), crmChance.getCustomer().getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CHANCE, Contants.ACTION_TYPE_ADD, crmChance.getId(), crmChance.getName(), crmChance.getCustomer().getId(), userId, accountId);
			}
			
			json.put("id", crmChance.getId());
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
			
			crmChanceService.delete(new CrmChance(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 下次联系提醒
	 * @param name
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "saveRemind", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject saveRemind(String id, String nextcontactDate, String nextcontactNote, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "id参数错误");
				return json;
			}
			if(StringUtils.isBlank(nextcontactDate) || nextcontactDate.length()>50){
				json.put("msg", "nextcontactDate参数错误");
				return json;
			}
			if(StringUtils.isBlank(nextcontactNote) || nextcontactNote.length()>50){
				json.put("msg", "nextcontactNote参数错误");
				return json;
			}
			
			CrmChance crmChance = crmChanceService.get(id);
			if(crmChance != null){
				//下次联系提醒
				crmChance.setNextcontactDate(DateUtils.parseDate(nextcontactDate, "yyyy-MM-dd"));
				crmChance.setNextcontactNote(nextcontactNote);
				
				//保存客户信息
				crmChanceService.save(crmChance);
				
				json.put("id", crmChance.getId());
				json.put("code", "1");
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
