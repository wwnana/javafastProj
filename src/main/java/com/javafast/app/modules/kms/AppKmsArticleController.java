package com.javafast.app.modules.kms;

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
import com.javafast.modules.kms.entity.KmsArticle;
import com.javafast.modules.kms.entity.KmsArticleData;
import com.javafast.modules.kms.service.KmsArticleService;
import com.javafast.modules.kms.service.KmsCategoryService;
import com.javafast.modules.sys.entity.User;

/**
 * 知识 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/kms/kmsArticle")
public class AppKmsArticleController {

	@Autowired
	private KmsArticleService kmsArticleService;
	
	@Autowired
	private KmsCategoryService kmsCategoryService;
	
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
			
			KmsArticle kmsArticle = new KmsArticle();
			kmsArticle.setIsApi(true);
			kmsArticle.setAccountId(accountId);//企业账号
			kmsArticle.setCurrentUser(new User(userId));//当前用户
			Page<KmsArticle> conPage = new Page<KmsArticle>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			kmsArticle.setPage(conPage);
			Page<KmsArticle> page =kmsArticleService.findPage(conPage, kmsArticle);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<KmsArticle> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				KmsArticle obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("title", obj.getTitle());
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
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
	public JSONObject getById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			KmsArticle entity = kmsArticleService.get(id);
			if(entity != null){

				json.put("entity", entity);	
				json.put("content", entity.getArticleData().getContent());
				
				json.put("createDate", DateUtils.formatDate(entity.getCreateDate(), "yyyy-MM-dd"));
				json.put("createName", entity.getCreateBy().getName());
				json.put("createBy", entity.getCreateBy().getId());
				
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
	public JSONObject save(String id, String title, String content, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			KmsArticle kmsArticle;
			KmsArticleData articleData;
			
			//校验输入参数
			if(StringUtils.isBlank(title) || title.length()>50){
				json.put("msg", "title参数错误");
				return json;
			}
			
			
			if(StringUtils.isNotBlank(id)){
				kmsArticle = kmsArticleService.get(id);
				articleData = kmsArticle.getArticleData();
				kmsArticle.setUpdateBy(new User(userId));
			}else{
				//新增
				kmsArticle = new KmsArticle();
				articleData = new KmsArticleData();
				
				kmsArticle.setAccountId(accountId);
				kmsArticle.setCreateBy(new User(userId));
				kmsArticle.setUpdateBy(new User(userId));
			}
			
			//知识基本信息
			kmsArticle.setTitle(title);
			articleData.setContent(content);
			kmsArticle.setArticleData(articleData);
			kmsArticle.setStatus("1");
			
			//保存知识信息
			kmsArticleService.save(kmsArticle);
			
			json.put("id", kmsArticle.getId());
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
			
			kmsArticleService.delete(new KmsArticle(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
