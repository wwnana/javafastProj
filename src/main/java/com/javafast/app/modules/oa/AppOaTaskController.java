package com.javafast.app.modules.oa;

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
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaProjectService;
import com.javafast.modules.oa.service.OaTaskService;
import com.javafast.modules.sys.entity.SysDynamic;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysDynamicService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.DynamicUtils;

/**
 * 任务 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaTask")
public class AppOaTaskController {

	@Autowired
	private OaTaskService oaTaskService;
	
	@Autowired
	private OaProjectService oaProjectService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	@Autowired
	private SysDynamicService sysDynamicService;
	
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
			
			OaTask oaTask = new OaTask();
			oaTask.setIsApi(true);
			oaTask.setAccountId(accountId);//企业账号
			oaTask.setCurrentUser(new User(userId));//当前用户
			Page<OaTask> conPage = new Page<OaTask>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			oaTask.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					oaTask.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("levelType") && StringUtils.isNotBlank(queryObj.getString("levelType"))){					
					oaTask.setLevelType(queryObj.getString("levelType"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					oaTask.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					oaTask.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					oaTask.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					oaTask.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					oaTask.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					oaTask.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					oaTask.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<OaTask> page =oaTaskService.findPage(conPage, oaTask);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OaTask> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OaTask obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("name", obj.getName());
				objJson.put("relationType", DictUtils.getDictLabel(obj.getRelationType(), "relation_type", ""));
				objJson.put("levelType", DictUtils.getDictLabel(obj.getLevelType(), "level_type", ""));
				objJson.put("schedule", obj.getSchedule());
				objJson.put("endDate", DateUtils.formatDate(obj.getEndDate(), "yyyy-MM-dd"));
				objJson.put("ownBy", obj.getOwnBy().getName());
				objJson.put("status", DictUtils.getDictLabel(obj.getStatus(), "task_status", ""));
				
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
			
			OaTask entity = oaTaskService.get(id);
			if(entity != null){
				entity.setLevelType(DictUtils.getDictLabel(entity.getLevelType(), "level_type", ""));
				entity.setRelationType(DictUtils.getDictLabel(entity.getRelationType(), "relation_type", ""));
				entity.setStatus(DictUtils.getDictLabel(entity.getStatus(), "task_status", ""));
				
				json.put("entity", entity);	
				if(entity.getStartDate() != null)
					json.put("startDate", DateUtils.formatDate(entity.getStartDate(), "yyyy-MM-dd"));
				if(entity.getEndDate() != null)
					json.put("endDate", DateUtils.formatDate(entity.getEndDate(), "yyyy-MM-dd"));
				
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "getTaskById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getTaskById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OaTask entity = oaTaskService.get(id);
			if(entity != null){
				entity.setLevelType(DictUtils.getDictLabel(entity.getLevelType(), "level_type", ""));
				entity.setRelationType(DictUtils.getDictLabel(entity.getRelationType(), "relation_type", ""));
				entity.setStatus(DictUtils.getDictLabel(entity.getStatus(), "task_status", ""));
				if(entity.getStartDate() != null)
					json.put("startDate", DateUtils.formatDate(entity.getStartDate(), "yyyy-MM-dd"));
				if(entity.getEndDate() != null)
					json.put("endDate", DateUtils.formatDate(entity.getEndDate(), "yyyy-MM-dd"));
				json.put("entity", entity);				
				
				//查询里程
				List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_OA_TYPE_TASK, entity.getId()));
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
			
			OaTask entity = oaTaskService.get(id);
			if(entity != null){
				json.put("entity", entity);		
				if(entity.getStartDate() != null)
					json.put("startDate", DateUtils.formatDate(entity.getStartDate(), "yyyy-MM-dd"));
				if(entity.getEndDate() != null)
					json.put("endDate", DateUtils.formatDate(entity.getEndDate(), "yyyy-MM-dd"));
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
	public JSONObject save(String id, String no, String name, String levelType, String content, String startDate, String endDate, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OaTask oaTask;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				oaTask = oaTaskService.get(id);
				oaTask.setUpdateBy(new User(userId));
			}else{
				//新增
				oaTask = new OaTask();
				
				oaTask.setAccountId(accountId);
				oaTask.setCreateBy(new User(userId));
				oaTask.setUpdateBy(new User(userId));
				oaTask.setStatus("0");
			}
			
			//任务基本信息
			oaTask.setName(name);
			oaTask.setNo(no);
			//oaTask.setEndDate(new Date(endDate));
			oaTask.setLevelType(levelType);
			oaTask.setContent(content);
			oaTask.setOwnBy(new User(ownById));
			
			if(StringUtils.isNotBlank(startDate)){
				oaTask.setStartDate(DateUtils.parseDate(startDate, "yyyy-MM-dd"));
			}
			if(StringUtils.isNotBlank(endDate)){
				oaTask.setEndDate(DateUtils.parseDate(endDate, "yyyy-MM-dd"));
			}
			
			//保存任务信息
			oaTaskService.save(oaTask);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_UPDATE, oaTask.getId(), oaTask.getName(), null, userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_ADD, oaTask.getId(), oaTask.getName(), null, userId, accountId);
			}
			
			json.put("id", oaTask.getId());
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
			
			oaTaskService.delete(new OaTask(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 执行
	 * @param id
	 * @param status
	 * @param userId
	 * @param accountId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "deal", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject deal(String id, String status, String userId, String accountId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OaTask oaTask = oaTaskService.get(id);//从数据库取出记录的值
			oaTask.setStatus(status);
			
			if("2".equals(oaTask.getStatus()))
				oaTask.setSchedule(100);
			
			oaTask.setUpdateBy(new User(userId));
			
			if("1".equals(oaTask.getStatus()) && oaTask.getStartDate() == null){
				oaTask.setStartDate(new Date());
			}
			oaTaskService.update(oaTask);
			
			if("1".equals(oaTask.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_START, oaTask.getId(), oaTask.getName(), null, userId, accountId);
			}
			if("2".equals(oaTask.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_END, oaTask.getId(), oaTask.getName(), null, userId, accountId);
			}
			if("3".equals(oaTask.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_CLOSE, oaTask.getId(), oaTask.getName(), null, userId, accountId);
			}
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
