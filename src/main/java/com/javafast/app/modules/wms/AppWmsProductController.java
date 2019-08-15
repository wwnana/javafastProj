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
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsProductData;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.service.WmsProductService;
import com.javafast.modules.wms.service.WmsProductTypeService;

/**
 * 产品 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/wms/wmsProduct")
public class AppWmsProductController {

	@Autowired
	private WmsProductService wmsProductService;
	
	@Autowired
	private WmsProductTypeService wmsProductTypeService;
	
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
			
			WmsProduct wmsProduct = new WmsProduct();
			wmsProduct.setIsApi(true);
			wmsProduct.setAccountId(accountId);//企业账号
			wmsProduct.setCurrentUser(new User(userId));//当前用户
			Page<WmsProduct> conPage = new Page<WmsProduct>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			wmsProduct.setPage(conPage);
			
			
			//组装查询条件
			if(StringUtils.isNotBlank(queryStr)){
				
				queryStr = StringEscapeUtils.unescapeHtml4(queryStr);
				System.out.println(queryStr);
				JSONObject queryObj = JSONObject.parseObject(queryStr);
				if(queryObj.containsKey("name") && StringUtils.isNotBlank(queryObj.getString("name"))){					
					wmsProduct.setName(queryObj.getString("name"));
				}
				if(queryObj.containsKey("no") && StringUtils.isNotBlank(queryObj.getString("no"))){					
					wmsProduct.setNo(queryObj.getString("no"));
				}
				if(queryObj.containsKey("productTypeId") && StringUtils.isNotBlank(queryObj.getString("productTypeId"))){					
					wmsProduct.setProductType(new WmsProductType(queryObj.getString("productTypeId")));
				}
				if(queryObj.containsKey("status") && StringUtils.isNotBlank(queryObj.getString("status"))){					
					wmsProduct.setStatus(queryObj.getString("status"));
				}
				if(queryObj.containsKey("createById") && StringUtils.isNotBlank(queryObj.getString("createById"))){					
					wmsProduct.setCreateBy(new User(queryObj.getString("createById")));
				}
				if(queryObj.containsKey("createdThisWeek") && StringUtils.isNotBlank(queryObj.getString("createdThisWeek"))){					
					wmsProduct.setBeginCreateDate(DateUtils.getBeginDayOfWeek());
					wmsProduct.setEndCreateDate(DateUtils.getEndDayOfWeek());
				}
				if(queryObj.containsKey("createdThisMonth") && StringUtils.isNotBlank(queryObj.getString("createdThisMonth"))){					
					wmsProduct.setBeginCreateDate(DateUtils.getBeginDayOfMonth());
					wmsProduct.setEndCreateDate(DateUtils.getEndDayOfMonth());
				}
			}
			
			//组装排序条件
			if(StringUtils.isNotBlank(orderBy)){
				conPage.setOrderBy(orderBy);
			}
			
			Page<WmsProduct> page =wmsProductService.findPage(conPage, wmsProduct);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<WmsProduct> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				WmsProduct obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("no", obj.getNo());
				objJson.put("name", obj.getName());
				objJson.put("type", obj.getProductType().getName());
				objJson.put("unitType", DictUtils.getDictLabel(obj.getUnitType(), "unit_type", ""));
				objJson.put("spec", obj.getSpec());
				objJson.put("salePrice", obj.getSalePrice());
				objJson.put("batchPrice", obj.getBatchPrice());
				objJson.put("createDate", DateUtils.formatDate(obj.getCreateDate(), "yyyy-MM-dd"));
				objJson.put("status", obj.getStatus());
				
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
			
			WmsProduct entity = wmsProductService.get(id);
			if(entity != null){
				
				json.put("entity", entity);	
				json.put("unitType", DictUtils.getDictLabel(entity.getUnitType(), "unit_type", ""));	
				json.put("createBy", entity.getCreateBy());
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
	public JSONObject save(String id, String productTypeId, String no, String name, String code, String unitType, String spec, String salePrice, String status, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			WmsProduct wmsProduct;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				wmsProduct = wmsProductService.get(id);
				wmsProduct.setUpdateBy(new User(userId));
			}else{
				//新增
				wmsProduct = new WmsProduct();
				
				wmsProduct.setAccountId(accountId);
				wmsProduct.setCreateBy(new User(userId));
				wmsProduct.setUpdateBy(new User(userId));
				
				WmsProductData wmsProductData = new WmsProductData();
				wmsProduct.setWmsProductData(wmsProductData);
			}
			
			//产品基本信息
			wmsProduct.setName(name);
			wmsProduct.setNo(no);
			wmsProduct.setCode(code);
			wmsProduct.setProductType(new WmsProductType(productTypeId));
			wmsProduct.setUnitType(unitType);
			wmsProduct.setSpec(spec);
			if(StringUtils.isNotBlank(salePrice))
				wmsProduct.setSalePrice(new BigDecimal(salePrice));
			wmsProduct.setStatus(status);
			wmsProduct.setRemarks(remarks);
			
			//保存产品信息
			wmsProductService.save(wmsProduct);
			
			json.put("id", wmsProduct.getId());
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
			
			wmsProductService.delete(new WmsProduct(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
