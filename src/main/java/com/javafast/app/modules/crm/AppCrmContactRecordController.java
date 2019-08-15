package com.javafast.app.modules.crm;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.javafast.modules.crm.entity.CrmContactRecord;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.crm.service.CrmContactRecordService;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 跟进记录 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/crm/crmContactRecord")
public class AppCrmContactRecordController {

	@Autowired
	private CrmContactRecordService crmContactRecordService;
	
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
			
			CrmContactRecord crmContactRecord = new CrmContactRecord();
			crmContactRecord.setIsApi(true);
			crmContactRecord.setAccountId(accountId);//企业账号
			crmContactRecord.setCurrentUser(new User(userId));//当前用户
			Page<CrmContactRecord> conPage = new Page<CrmContactRecord>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			crmContactRecord.setPage(conPage);
			Page<CrmContactRecord> page =crmContactRecordService.findPage(conPage, crmContactRecord);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<CrmContactRecord> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				CrmContactRecord obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getContent());
				
				
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
			
			CrmContactRecord entity = crmContactRecordService.get(id);
			if(entity != null){
				
				entity.setContactType(DictUtils.getDictLabel(entity.getContactType(), "contact_type", ""));
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
	public JSONObject save(String id, String customerId, String contactType, String content, String contactDate, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			CrmContactRecord crmContactRecord;
			
			//校验输入参数
			if(StringUtils.isBlank(content)){
				json.put("msg", "content参数错误");
				return json;
			}
			if(StringUtils.isBlank(customerId)){
				json.put("msg", "customerId参数错误");
				return json;
			}
			CrmCustomer crmCustomer = crmCustomerService.get(customerId);
			
			if(StringUtils.isNotBlank(id)){
				crmContactRecord = crmContactRecordService.get(id);
			}else{
				//新增
				crmContactRecord = new CrmContactRecord();
				crmContactRecord.setTargetType(Contants.OBJECT_CRM_TYPE_CUSTOMER);
				crmContactRecord.setTargetId(crmCustomer.getId());
				crmContactRecord.setTargetName(crmCustomer.getName());
				crmContactRecord.setAccountId(accountId);
				crmContactRecord.setCreateBy(new User(userId));
				crmContactRecord.setUpdateBy(new User(userId));
			}
			
			//跟进记录基本信息
			crmContactRecord.setContactType(contactType);
			crmContactRecord.setContent(content);
			if(StringUtils.isNotBlank(contactDate))
				crmContactRecord.setContactDate(DateUtils.parseDate(contactDate, "yyyy-MM-dd HH:mm:ss"));
			
			//保存跟进记录信息
			crmContactRecordService.save(crmContactRecord);
			
			content = crmContactRecord.getContent();
			if(content.length()>50){
				content = content.substring(0,45)+"...";
			}
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_UPDATE, crmContactRecord.getId(), content, crmContactRecord.getTargetId(), userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_CRM_TYPE_RECORD, Contants.ACTION_TYPE_ADD, crmContactRecord.getId(), content, crmContactRecord.getTargetId(), userId, accountId);
			}
			
			json.put("id", crmContactRecord.getId());
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
			
			crmContactRecordService.delete(new CrmContactRecord(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
