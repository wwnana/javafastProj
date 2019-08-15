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
import com.javafast.modules.oa.entity.OaProject;
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
 * 项目 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaProject")
public class AppOaProjectController {

	@Autowired
	private OaProjectService oaProjectService;
	
	@Autowired
	private OaTaskService oaTaskService;
	
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
			
			OaProject oaProject = new OaProject();
			oaProject.setIsApi(true);
			oaProject.setAccountId(accountId);//企业账号
			oaProject.setCurrentUser(new User(userId));//当前用户
			Page<OaProject> conPage = new Page<OaProject>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			oaProject.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					oaProject.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					oaProject.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("ownById") && StringUtils.isNotBlank(queryObj.getString("ownById"))){					
					oaProject.setOwnBy(new User(queryObj.getString("ownById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					oaProject.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					oaProject.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					oaProject.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					oaProject.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					oaProject.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<OaProject> page =oaProjectService.findPage(conPage, oaProject);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OaProject> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OaProject obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("name", obj.getName());
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
			
			OaProject entity = oaProjectService.get(id);
			if(entity != null){
				
				entity.setStatus(DictUtils.getDictLabel(entity.getStatus(), "task_status", ""));
				
				json.put("entity", entity);				
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "getProjectById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getProjectById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OaProject oaProject = oaProjectService.get(id);
			if(oaProject != null){
				
				oaProject.setStatus(DictUtils.getDictLabel(oaProject.getStatus(), "task_status", ""));				
				json.put("entity", oaProject);				
				if(oaProject.getStartDate() != null)
					json.put("startDate", DateUtils.formatDate(oaProject.getStartDate(), "yyyy-MM-dd"));
				if(oaProject.getEndDate() != null)
					json.put("endDate", DateUtils.formatDate(oaProject.getEndDate(), "yyyy-MM-dd"));
						
				
				//任务
				OaTask conOaTask = new OaTask();
				conOaTask.setRelationId(oaProject.getId());
				List<OaTask> oaTaskList = oaTaskService.findListFor(conOaTask);
				JSONArray taskJsonArray = new JSONArray();
				for(int i=0;i<oaTaskList.size();i++){			
					OaTask obj = oaTaskList.get(i);
					
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
					
					taskJsonArray.add(objJson);
				}				
				json.put("oaTaskList", taskJsonArray);
				
				//查询里程
				List<SysDynamic> sysDynamicList = sysDynamicService.findList(new SysDynamic(Contants.OBJECT_OA_TYPE_PROJECT, oaProject.getId()));
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
	public JSONObject save(String id, String no, String name, String content, String startDate,  String endDate, String ownById, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OaProject oaProject;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				oaProject = oaProjectService.get(id);
				oaProject.setUpdateBy(new User(userId));
			}else{
				//新增
				oaProject = new OaProject();
				
				oaProject.setAccountId(accountId);
				oaProject.setCreateBy(new User(userId));
				oaProject.setUpdateBy(new User(userId));
				oaProject.setStatus("0");
			}
			
			//项目基本信息
			oaProject.setName(name);
			oaProject.setNo(no);
			//oaProject.setEndDate(new Date(endDate));
			oaProject.setContent(content);
			oaProject.setOwnBy(new User(ownById));
			
			if(StringUtils.isNotBlank(startDate)){
				oaProject.setStartDate(DateUtils.parseDate(startDate, "yyyy-MM-dd"));
			}
			if(StringUtils.isNotBlank(endDate)){
				oaProject.setEndDate(DateUtils.parseDate(endDate, "yyyy-MM-dd"));
			}
			
			//保存项目信息
			oaProjectService.save(oaProject);
			
			if(StringUtils.isNotBlank(id)){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_UPDATE, oaProject.getId(), oaProject.getName(), null, userId, accountId);
			}else{
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_TASK, Contants.ACTION_TYPE_ADD, oaProject.getId(), oaProject.getName(), null, userId, accountId);
			}
			
			json.put("id", oaProject.getId());
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
			
			oaProjectService.delete(new OaProject(id));
			
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
			
			OaProject oaProject = oaProjectService.get(id);//从数据库取出记录的值
			oaProject.setStatus(status);
			
			if("2".equals(oaProject.getStatus()))
				oaProject.setSchedule(100);
			
			if("1".equals(oaProject.getStatus()) && oaProject.getStartDate() == null){
				oaProject.setStartDate(new Date());
			}
			
			oaProject.setUpdateBy(new User(userId));
			oaProjectService.save(oaProject);
			
			if("1".equals(oaProject.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_START, oaProject.getId(), oaProject.getName(), null, userId, accountId);
			}
			if("2".equals(oaProject.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_END, oaProject.getId(), oaProject.getName(), null, userId, accountId);
			}
			if("3".equals(oaProject.getStatus())){
				DynamicUtils.addDynamic(Contants.OBJECT_OA_TYPE_PROJECT, Contants.ACTION_TYPE_CLOSE, oaProject.getId(), oaProject.getName(), null, userId, accountId);
			}
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
