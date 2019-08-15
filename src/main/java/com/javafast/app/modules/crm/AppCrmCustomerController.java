package com.javafast.app.modules.crm;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
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
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmContacter;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmChanceService;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmContacterService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.crm.service.CrmCustomerStarService;
import com.javafast.modules.crm.service.CrmDocumentService;
import com.javafast.modules.crm.service.CrmQuoteService;
import com.javafast.modules.fi.entity.FiReceiveAble;
import com.javafast.modules.fi.service.FiReceiveAbleService;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.om.entity.OmContract;
import com.javafast.modules.om.service.OmContractService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;
import com.javafast.modules.sys.utils.UserUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 客户 API Controller
 * @author javafast
 * @version 2017-08-10
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmCustomer")
public class AppCrmCustomerController extends BaseController {

	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
	@Autowired
	private CrmContacterService crmContacterService;
	
	@Autowired
	private CrmChanceService crmChanceService;
	
	@Autowired
	private CrmQuoteService crmQuoteService;
	
	@Autowired
	private FiReceiveAbleService fiReceiveAbleService;
	
	@Autowired
	private OmContractService omContractService;
	
	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private CrmCustomerStarService crmCustomerStarService;
	
	@Autowired
	private MyCalendarService myCalendarService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
	@Autowired
	private CrmDocumentService crmDocumentService;
	
	@Autowired
	private UserService userService;
	
	/**
	 * 分页查询列表
	 * @param pageNo 当前页码
	 * @param title
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String userId, String accountId, String pageNo, String isPool, String queryStr, String orderBy, HttpServletRequest request, HttpServletResponse response) {
		
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
			
			if(StringUtils.isNotBlank(isPool)){
				crmCustomer.setIsPool(isPool);
			}
			
			crmCustomer.setIsApi(true);
			crmCustomer.setAccountId(accountId);//企业账号
			crmCustomer.setCurrentUser(new User(userId));//当前用户
			Page<CrmCustomer> conPage = new Page<CrmCustomer>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmCustomer.setPage(conPage);
			
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					crmCustomer.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("customerLevel") && StringUtils.isNotBlank(queryObj.getString("customerLevel"))){					
					crmCustomer.setCustomerLevel(queryObj.getString("customerLevel"));
				}
				if(queryObj.containsKey("customerStatus") && StringUtils.isNotBlank(queryObj.getString("customerStatus"))){					
					crmCustomer.setCustomerStatus(queryObj.getString("customerStatus"));
				}
				if(queryObj.containsKey("contacterName") && StringUtils.isNotBlank(queryObj.getString("contacterName"))){					
					crmCustomer.setContacterName(queryObj.getString("contacterName"));
				}
				if(queryObj.containsKey("mobile") && StringUtils.isNotBlank(queryObj.getString("mobile"))){					
					crmCustomer.setMobile(queryObj.getString("mobile"));
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					crmCustomer.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					crmCustomer.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("isStar") && StringUtils.isNotBlank(queryObj.getString("isStar"))){					
					crmCustomer.setIsStar(queryObj.getString("isStar"));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					crmCustomer.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					crmCustomer.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					crmCustomer.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					crmCustomer.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
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
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
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
				
				entity.setCustomerLevel(DictUtils.getDictLabel(entity.getCustomerLevel(), "customer_level", ""));
				entity.setCustomerStatus(DictUtils.getDictLabel(entity.getCustomerStatus(), "customer_status", ""));
				entity.setIndustryType(DictUtils.getDictLabel(entity.getIndustryType(), "industry_type", ""));
				entity.setSourType(DictUtils.getDictLabel(entity.getSourType(), "sour_type", ""));
				entity.setNatureType(DictUtils.getDictLabel(entity.getNatureType(), "nature_type", ""));
				entity.setScaleType(DictUtils.getDictLabel(entity.getScaleType(), "scale_type", ""));
				if(entity.getNextcontactDate() != null){
					json.put("nextcontactDate", DateUtils.formatDate(entity.getNextcontactDate(), "yyyy-MM-dd"));
				}
				
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
	 * 根据ID查询客户主页信息
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getCustomerById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getCustomerById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			if(crmCustomer != null){
				
				json.put("entity", crmCustomer);
				if(crmCustomer.getNextcontactDate() != null){
					json.put("nextcontactDate", DateUtils.formatDate(crmCustomer.getNextcontactDate(), "yyyy-MM-dd"));
				}
				
				//查询联系人
				CrmContacter crmContacter = new CrmContacter();
				crmContacter.setCustomer(crmCustomer);
				List<CrmContacter> crmContacterList = crmContacterService.findListByCustomer(crmContacter);
				json.put("crmContacterList", crmContacterList);
				
				//查询商机
				CrmChance crmChance = new CrmChance();
				crmChance.setCustomer(crmCustomer);
				List<CrmChance> crmChanceList = crmChanceService.findListByCustomer(crmChance); 
				json.put("crmChanceList", crmChanceList);
				
				//查询跟进记录
				CrmContactRecord crmContactRecord = new CrmContactRecord();
				crmContactRecord.setTargetId(crmCustomer.getId());
				List<CrmContactRecord> crmContactRecordList = crmContactRecordService.findListByCustomer(crmContactRecord);
				json.put("crmContactRecordList", crmContactRecordList);
				
				//查询订单合同
				OmContract omContract = new OmContract();
				omContract.setCustomer(crmCustomer);
				List<OmContract> omContractList = omContractService.findListByCustomer(omContract);
				json.put("omContractList", omContractList);
				
				//查询应收款
				FiReceiveAble fiReceiveAble = new FiReceiveAble();
				fiReceiveAble.setCustomer(crmCustomer);
				List<FiReceiveAble> fiReceiveAbleList = fiReceiveAbleService.findListByCustomer(fiReceiveAble);
				json.put("fiReceiveAbleList", fiReceiveAbleList);
				
				//查询客户日志
				List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(crmCustomer.getId(), true));
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
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "form", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject form(String id) {
	
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

				json.put("customer_level_list", DictUtils.getDictList("customer_level"));
				json.put("customer_status", DictUtils.getDictList("customer_status"));
				json.put("industry_type", DictUtils.getDictList("industry_type"));
				json.put("sour_type", DictUtils.getDictList("sour_type"));
				json.put("nature_type", DictUtils.getDictList("nature_type"));
				json.put("scale_type", DictUtils.getDictList("scale_type"));
				if(entity.getNextcontactDate() != null){
					json.put("nextcontactDate", DateUtils.formatDate(entity.getNextcontactDate(), "yyyy-MM-dd"));
				}
				
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
	 * 保存(新增或修改)
	 * @param name
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String name, String contacterName, String contacterMobile, String customerStatus, 
			String customerLevel, String phone, String province, String city , String dict, String address, String remarks, 
			String nextcontactDate, String nextcontactNote, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmCustomer crmCustomer;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				crmCustomer = crmCustomerService.get(id);
				crmCustomer.setUpdateBy(new User(userId));
			}else{
				//新增
				crmCustomer = new CrmCustomer();
				
				//联系人
				if(StringUtils.isNotBlank(contacterName)){
					CrmContacter crmContacter = new CrmContacter();
					crmContacter.setName(contacterName);
					crmContacter.setMobile(contacterMobile);
					crmContacter.setAccountId(accountId);
					crmContacter.setOwnBy(new User(ownById));
					crmContacter.setCreateBy(new User(userId));
					crmContacter.setUpdateBy(new User(userId));
					
					crmCustomer.setCrmContacter(crmContacter);
				}
				
				crmCustomer.setAccountId(accountId);
				crmCustomer.setCreateBy(new User(userId));
				crmCustomer.setUpdateBy(new User(userId));
			}
			
			//客户基本信息
			crmCustomer.setName(name);
			crmCustomer.setCustomerStatus(customerStatus);
			crmCustomer.setCustomerLevel(customerLevel);
			crmCustomer.setPhone(phone);
			crmCustomer.setAddress(address);
			crmCustomer.setRemarks(remarks);
			crmCustomer.setCustomerType("0");
			crmCustomer.setOwnBy(new User(ownById));
			
			//下次联系提醒
			if(StringUtils.isNotBlank(nextcontactDate)){
				crmCustomer.setNextcontactDate(DateUtils.parseDate(nextcontactDate, "yyyy-MM-dd"));
				crmCustomer.setNextcontactNote(nextcontactNote);
			}
			
			//保存客户信息
			crmCustomerService.save(crmCustomer);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_UPDATE, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_ADD, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			}
			
			json.put("id", crmCustomer.getId());
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
			
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			if(crmCustomer != null){
				//下次联系提醒
				crmCustomer.setNextcontactDate(DateUtils.parseDate(nextcontactDate, "yyyy-MM-dd"));
				crmCustomer.setNextcontactNote(nextcontactNote);
				
				//保存客户信息
				crmCustomerService.save(crmCustomer);
				
				json.put("id", crmCustomer.getId());
				json.put("code", "1");
			}			
		} catch (Exception e) {
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
	@RequestMapping(value = "del", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject del(String id, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			crmCustomerService.delete(crmCustomer);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DEL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 领取客户
	 * @param id
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "receipt", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject receipt(String id, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			User user = userService.getUserByDb(userId);
			
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			crmCustomer.setOwnBy(user);
			crmCustomer.setOfficeId(user.getOfficeId());
			crmCustomerService.updateOwnBy(crmCustomer);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_DRAW, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 放入公海
	 * @param id
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "toPool", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject toPool(String id, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			crmCustomerService.throwToPool(crmCustomer);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_POOL, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 指派
	 * @param id
	 * @param ownById
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "share", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject share(String id, String ownById, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			User user = userService.getUserByDb(ownById);
			
			CrmCustomer crmCustomer = crmCustomerService.get(id);
			crmCustomer.setOwnBy(user);
			crmCustomer.setOfficeId(user.getOfficeId());
			crmCustomerService.updateOwnBy(crmCustomer);
			
			DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_CUSTOMER, Contants.ACTION_TYPE_APPOINT, crmCustomer.getId(), crmCustomer.getName(), crmCustomer.getId(), userId, accountId);
			
			json.put("code", "1");
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}