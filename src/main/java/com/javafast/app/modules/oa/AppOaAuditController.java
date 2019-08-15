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
import com.google.common.collect.Lists;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaCommonAudit;
import com.javafast.modules.oa.entity.OaCommonAuditRecord;
import com.javafast.modules.oa.service.OaCommonAuditService;
import com.javafast.modules.oa.service.OaCommonBorrowService;
import com.javafast.modules.oa.service.OaCommonExpenseService;
import com.javafast.modules.oa.service.OaCommonExtraService;
import com.javafast.modules.oa.service.OaCommonFlowService;
import com.javafast.modules.oa.service.OaCommonLeaveService;
import com.javafast.modules.oa.service.OaCommonTravelService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.DictUtils;

/**
 * 审批 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaAudit")
public class AppOaAuditController {

	@Autowired
	private OaCommonAuditService oaCommonAuditService;
	
	@Autowired
	private OaCommonFlowService oaCommonFlowService;
	
	@Autowired
	private OaCommonBorrowService oaCommonBorrowService;
	
	@Autowired
	private OaCommonExpenseService oaCommonExpenseService;
	
	@Autowired
	private OaCommonLeaveService oaCommonLeaveService;
	
	@Autowired
	private OaCommonTravelService oaCommonTravelService;
	
	@Autowired
	private OaCommonExtraService oaCommonExtraService;
	
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
			
			OaCommonAudit oaCommonAudit = new OaCommonAudit();
			oaCommonAudit.setIsApi(true);
			oaCommonAudit.setAccountId(accountId);//企业账号
			oaCommonAudit.setCurrentUser(new User(userId));//当前用户
			Page<OaCommonAudit> conPage = new Page<OaCommonAudit>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			oaCommonAudit.setPage(conPage);
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("title") && StringUtils.isNotBlank(queryObj.getString("title"))){					
					oaCommonAudit.setTitle(queryObj.getString("title"));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					oaCommonAudit.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("currentById") && StringUtils.isNotBlank(queryObj.getString("currentById"))){					
					oaCommonAudit.setCurrentBy(new User(queryObj.getString("currentById")));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					oaCommonAudit.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					oaCommonAudit.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					oaCommonAudit.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					oaCommonAudit.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					oaCommonAudit.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<OaCommonAudit> page =oaCommonAuditService.findPage(conPage, oaCommonAudit);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OaCommonAudit> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OaCommonAudit obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("title", obj.getTitle());
				objJson.put("createDate", DateUtils.formatDate(obj.getUpdateDate(), "yyyy-MM-dd"));
				objJson.put("createName", obj.getCreateBy().getName());
				objJson.put("status", DictUtils.getDictLabel(obj.getStatus(), "common_audit_status", ""));
				
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
			
			OaCommonAudit entity = oaCommonAuditService.get(id);
			if(entity != null){
				
				oaCommonAuditService.updateReadFlag(id, new User(userId));
				
				json.put("createDate", DateUtils.formatDate(entity.getUpdateDate(), "yyyy-MM-dd"));
				json.put("createName", entity.getCreateBy().getName());
				json.put("createBy", entity.getCreateBy().getId());
				
				List<OaCommonAuditRecord> oaCommonAuditRecordList = Lists.newArrayList();		// 审批列表
				List<OaCommonAuditRecord> oaCommonReadRecordList = Lists.newArrayList();//抄送列表
				
				for(OaCommonAuditRecord oaCommonAuditRecord : entity.getOaCommonAuditRecordList()){
					
					if("0".equals(oaCommonAuditRecord.getDealType())){
						oaCommonAuditRecordList.add(oaCommonAuditRecord);
					}
					if("1".equals(oaCommonAuditRecord.getDealType())){
						System.out.println("=============getDealType===========");
						oaCommonReadRecordList.add(oaCommonAuditRecord);
					}
				}
				
				entity.setOaCommonAuditRecordList(null);
				entity.setOaCommonReadRecordList(null);
				json.put("entity", entity);				
				json.put("oaCommonAuditRecordList", oaCommonAuditRecordList);		
				json.put("oaCommonReadRecordList", oaCommonReadRecordList);		
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
	 * @param type审批类型   审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单, 5加班单
	 * @param title
	 * @param content
	 * @param auditUserIds
	 * @param readUserIds
	 * @param accountId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String type, String title, String content, String auditUserIds, String readUserIds, String accountId, String userId, HttpServletRequest request) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OaCommonAudit oaCommonAudit = new OaCommonAudit();
			
			//校验输入参数
			if(StringUtils.isBlank(title) || title.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			User applyUser = userService.get(userId);
			
			oaCommonAudit.setTitle(title);
			oaCommonAudit.setContent(content);
			oaCommonAudit.setAccountId(accountId);
			oaCommonAudit.setOffice(applyUser.getOffice());
			oaCommonAudit.setCreateBy(new User(userId));
			oaCommonAudit.setUpdateBy(new User(userId));
			oaCommonAudit.setType(type);// 审批类型   审批类型 0普通审批，1请假单，2报销单，3差旅单，4借款单, 5加班单
			oaCommonAudit.setStatus("1");//状态 0草稿，1审批中，2已通过，3不通过
			
			// 审批人 抄送人
			List<OaCommonAuditRecord> oaCommonAuditRecordList = Lists.newArrayList();		
			String auditUserIdArray[] = auditUserIds.split(",");
			for(int i=0; i<auditUserIdArray.length; i++){
				
				User auditUser = userService.get(auditUserIdArray[i]);
				
				OaCommonAuditRecord oaCommonAuditRecord = new OaCommonAuditRecord();
				oaCommonAuditRecord.setDealType("0");//执行类型 0 审批，1查阅
				oaCommonAuditRecord.setUser(auditUser);
				
				oaCommonAuditRecordList.add(oaCommonAuditRecord);
			}
			
			String readUserIdArray[] = readUserIds.split(",");
			for(int i=0; i<readUserIdArray.length; i++){
				
				User readUser = userService.get(readUserIdArray[i]);
				
				OaCommonAuditRecord oaCommonReadRecord = new OaCommonAuditRecord();
				oaCommonReadRecord.setDealType("1");//执行类型 0 审批，1查阅
				oaCommonReadRecord.setUser(readUser);
				
				oaCommonAuditRecordList.add(oaCommonReadRecord);
			}
			
			oaCommonAudit.setOaCommonAuditRecordList(oaCommonAuditRecordList);
			
			oaCommonAuditService.crateCommonAudit(oaCommonAudit);//提交
			
			json.put("id", oaCommonAudit.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 审批
	 * @param id
	 * @param auditStatus
	 * @param auditNote
	 * @param accountId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "audit", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject audit(String id, String auditStatus, String auditNote, String auditUserIds, String accountId, String userId, HttpServletRequest request) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "id参数错误");
				return json;
			}
			OaCommonAudit oaCommonAudit = oaCommonAuditService.get(id);
			
			if(oaCommonAudit != null){
				
				//是否继续审批
				if(StringUtils.isNotBlank(auditUserIds)){
					
					User auditUser = userService.get(auditUserIds);
					
					OaCommonAuditRecord oaCommonAuditRecord = new OaCommonAuditRecord();
					oaCommonAuditRecord.setDealType("0");//执行类型 0 审批，1查阅
					oaCommonAuditRecord.setUser(auditUser);
					oaCommonAuditRecord.setCommonAudit(oaCommonAudit);
					oaCommonAuditRecord.setAuditOrder(oaCommonAudit.getOaCommonAuditRecordList().size()+2);
					oaCommonAuditRecord.setReadFlag("0");
					oaCommonAuditService.addCommonAuditRecord(oaCommonAuditRecord);
				}
				
				User auditUser = userService.get(userId);
				if(auditUser != null){
					
					//审批
					oaCommonAuditService.audit(oaCommonAudit.getId(), auditStatus, auditNote, auditUser);
				}
			}
			
			json.put("id", oaCommonAudit.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 撤销
	 * @param id
	 * @param accountId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "del", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject del(String id, String accountId, String userId, HttpServletRequest request) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "id参数错误");
				return json;
			}
			
			OaCommonAudit oaCommonAudit = oaCommonAuditService.get(id);
			
			//状态 0草稿，1审批中，2已通过，3不通过
			if(oaCommonAudit != null){
				if("0".equals(oaCommonAudit.getStatus()) || "1".equals(oaCommonAudit.getStatus())){
					oaCommonAuditService.delete(oaCommonAudit);
					
					json.put("code", "1");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
