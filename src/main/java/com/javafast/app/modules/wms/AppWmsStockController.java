package com.javafast.app.modules.wms;

import java.math.BigDecimal;
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
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.entity.WmsStock;
import com.javafast.modules.wms.service.WmsStockService;

/**
 * 产品库存 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/wms/wmsStock")
public class AppWmsStockController {

	@Autowired
	private WmsStockService wmsStockService;
	
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
			
			WmsStock wmsStock = new WmsStock();
			wmsStock.setIsApi(true);
			wmsStock.setAccountId(accountId);//企业账号
			wmsStock.setCurrentUser(new User(userId));//当前用户
			Page<WmsStock> conPage = new Page<WmsStock>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			wmsStock.setPage(conPage);
			
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				
				WmsProduct product = new WmsProduct();
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){			
					product.setName(queryObj.getString("name"));
					wmsStock.setProduct(product);
				}
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					product.setName(queryObj.getString("no"));
					wmsStock.setProduct(product);
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<WmsStock> page =wmsStockService.findPage(conPage, wmsStock);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<WmsStock> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				WmsStock obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("productNo", obj.getProduct().getNo());
				objJson.put("productName", obj.getProduct().getName());
				objJson.put("warehouseName", obj.getWarehouse().getName());
				objJson.put("stockNum", obj.getStockNum());
				objJson.put("warnNum", obj.getWarnNum());
				
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
			
			WmsStock entity = wmsStockService.get(id);
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
	public JSONObject save(String id, String no, String name, String code, String productType, String unitType, String spec, String salePrice, String status, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			WmsStock wmsStock;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				wmsStock = wmsStockService.get(id);
				wmsStock.setUpdateBy(new User(userId));
			}else{
				//新增
				wmsStock = new WmsStock();
				
				wmsStock.setAccountId(accountId);
				wmsStock.setCreateBy(new User(userId));
				wmsStock.setUpdateBy(new User(userId));
			}
			
			
			
			//保存产品信息
			wmsStockService.save(wmsStock);
			
			json.put("id", wmsStock.getId());
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
			
			wmsStockService.delete(new WmsStock(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
