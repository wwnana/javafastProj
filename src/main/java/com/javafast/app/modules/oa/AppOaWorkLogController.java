package com.javafast.app.modules.oa;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.google.common.collect.Lists;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.dao.OaWorkLogRecordDao;
import com.javafast.modules.oa.dao.OaWorkLogRuleDao;
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.oa.entity.OaWorkLogRecord;
import com.javafast.modules.oa.entity.OaWorkLogRule;
import com.javafast.modules.oa.service.OaWorkLogService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 工作日志 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaWorkLog")
public class AppOaWorkLogController {

	@Autowired
	private OaWorkLogService oaWorkLogService;
	
	@Autowired
	private OaWorkLogRecordDao oaWorkLogRecordDao;
	
	@Autowired
	OaWorkLogRuleDao oaWorkLogRuleDao;
	
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
			
			OaWorkLog oaWorkLog = new OaWorkLog();
			oaWorkLog.setIsApi(true);
			oaWorkLog.setAccountId(accountId);//企业账号
			oaWorkLog.setCurrentUser(new User(userId));//当前用户
			Page<OaWorkLog> conPage = new Page<OaWorkLog>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			oaWorkLog.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("title") && StringUtils.isNotBlank(queryObj.getString("title"))){					
					oaWorkLog.setTitle(queryObj.getString("title"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					oaWorkLog.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("auditById") && StringUtils.isNotBlank(queryObj.getString("auditById"))){					
					oaWorkLog.setAuditBy(new User(queryObj.getString("auditById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					oaWorkLog.setCreateBy(new User(queryObj.getString("createById")));
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<OaWorkLog> page =oaWorkLogService.findPage(conPage, oaWorkLog);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OaWorkLog> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OaWorkLog obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("title", obj.getTitle());
				objJson.put("createDate", DateUtils.formatDate(obj.getUpdateDate(), "yyyy-MM-dd"));
				objJson.put("createName", obj.getCreateBy().getName());
				
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
	public JSONObject getById(String id, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OaWorkLog entity = oaWorkLogService.get(id);
			if(entity != null){
				
				if(!userId.equals(entity.getCreateBy().getId())){
					
					//更新查阅信息
					oaWorkLogService.updateReadInfo(entity, new User(userId));
					
					//锁定，不能再修改
					entity.setStatus("1");
					oaWorkLogService.save(entity);//保存
				}	
				
				json.put("createDate", DateUtils.formatDate(entity.getUpdateDate(), "yyyy-MM-dd"));
				json.put("createName", entity.getCreateBy().getName());
				if("0".equals(entity.getStatus())){
					json.put("createBy", entity.getCreateBy().getId());
				}
				
				JSONObject oaWorkLogObj = new JSONObject();
				oaWorkLogObj.put("title", entity.getTitle());
				oaWorkLogObj.put("createDate", DateUtils.formatDate(entity.getUpdateDate(), "yyyy-MM-dd"));
				oaWorkLogObj.put("createName", entity.getCreateBy().getName());
				if("0".equals(entity.getStatus())){
					oaWorkLogObj.put("createBy", entity.getCreateBy().getId());
				}
				oaWorkLogObj.put("content", entity.getContent());
				
				json.put("entity", oaWorkLogObj);				
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
	 * @param title
	 * @param content
	 * @param accountId
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String workLogType, String content, String readUserIds, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OaWorkLog oaWorkLog;
			
			//校验输入参数
			if(StringUtils.isBlank(workLogType)){
				json.put("msg", "workLogType参数错误");
				return json;
			}
			
			String title = DictUtils.getDictLabel(workLogType, "work_log_type", "") +" "+ DateUtils.getDate() + " 工作汇报";
			
			
			if(StringUtils.isNotBlank(id)){
				
				oaWorkLog = oaWorkLogService.get(id);
				oaWorkLog.setTitle(title);
				oaWorkLog.setContent(content);
				oaWorkLog.setUpdateBy(new User(userId));
				oaWorkLogService.add(oaWorkLog);
			}else{
				
				oaWorkLog = new OaWorkLog();
				
				oaWorkLog.setTitle(title);
				oaWorkLog.setContent(content);
				oaWorkLog.setAccountId(accountId);
				oaWorkLog.setCreateBy(new User(userId));
				oaWorkLog.setUpdateBy(new User(userId));
				oaWorkLog.setStatus("0");
				oaWorkLogService.add(oaWorkLog);
				
				//添加查阅人
				Map<String, String> hashMap = new HashMap<String, String>();
				
				//汇报给
				if(StringUtils.isNotBlank(readUserIds)){
					
					String readUserIdArray[] = readUserIds.split(",");
					for(int i=0; i<readUserIdArray.length; i++){
						
						OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
						oaWorkLogRecord.setOaWorkLog(oaWorkLog);
						oaWorkLogRecord.setUser(new User(readUserIdArray[i]));
						oaWorkLogRecord.setOaWorkLog(oaWorkLog);
						oaWorkLogRecord.preInsert();
						oaWorkLogRecordDao.insert(oaWorkLogRecord);	
						
						hashMap.put(oaWorkLogRecord.getUser().getId(), oaWorkLogRecord.getUser().getId());
					}
				}
				
				//添加固定汇报对象
				OaWorkLogRule conOaWorkLogRule = new OaWorkLogRule();
				conOaWorkLogRule.getSqlMap().put("dsf", " AND a.account_id='"+accountId+"'");	
				List<OaWorkLogRule> oaWorkLogRuleList = oaWorkLogRuleDao.findList(conOaWorkLogRule);
				for(int i=0; i<oaWorkLogRuleList.size(); i++){
					OaWorkLogRule oaWorkLogRule = oaWorkLogRuleList.get(i);
					
					if(!hashMap.containsKey(oaWorkLogRule.getUser().getId())){
						
						OaWorkLogRecord oaWorkLogRecord = new OaWorkLogRecord();
						oaWorkLogRecord.setOaWorkLog(oaWorkLog);
						oaWorkLogRecord.setUser(oaWorkLogRule.getUser());
						oaWorkLogRecord.setOaWorkLog(oaWorkLog);
						oaWorkLogRecord.preInsert();
						oaWorkLogRecordDao.insert(oaWorkLogRecord);
					}
				}
			}
			
			json.put("id", oaWorkLog.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
