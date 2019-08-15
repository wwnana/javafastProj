package com.javafast.modules.tools.web;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.common.web.BaseController;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.utils.UserUtils;
import com.javafast.modules.tools.entity.TestInterface;
import com.javafast.modules.tools.service.TestInterfaceService;
import com.javafast.modules.tools.utils.HttpPostTest;

/**
 * 接口Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/tools/testInterface")
public class TestInterfaceController extends BaseController {

	@Autowired
	private TestInterfaceService testInterfaceService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	@ModelAttribute
	public TestInterface get(@RequestParam(required=false) String id) {
		TestInterface entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = testInterfaceService.get(id);
		}
		if (entity == null){
			entity = new TestInterface();
		}
		return entity;
	}
	
	/**
	 * 接口列表页面
	 */
	@RequiresPermissions("tools:testInterface:list")
	@RequestMapping(value = {"list", ""})
	public String list(TestInterface testInterface, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TestInterface> page = testInterfaceService.findPage(new Page<TestInterface>(request, response), testInterface); 
		model.addAttribute("page", page);
		
		//查询企业账户
		SysAccount sysAccount = sysAccountService.get(UserUtils.getUser().getAccountId());		
		if(StringUtils.isNotBlank(sysAccount.getApiSecret()))
			model.addAttribute("params", "&accountId="+sysAccount.getId()+"&apiSecret="+sysAccount.getApiSecret() + testInterface.getBody());
				
		return "modules/tools/testInterfaceList";
	}

	/**
	 * 查看，增加，编辑接口表单页面
	 */
	@RequiresPermissions(value={"tools:testInterface:view","tools:testInterface:add","tools:testInterface:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TestInterface testInterface, Model model) {
		model.addAttribute("testInterface", testInterface);
		return "modules/tools/testInterfaceForm";
	}
	
	/**
	 * 查看
	 * @param testInterface
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "view")
	public String view(TestInterface testInterface, Model model) {
		
		//查询企业账户
		SysAccount sysAccount = sysAccountService.get(UserUtils.getUser().getAccountId());		
		testInterface.setBody("&accountId="+sysAccount.getId()+"&apiSecret="+sysAccount.getApiSecret() + testInterface.getBody());
		
		model.addAttribute("testInterface", testInterface);
		return "modules/tools/testInterfaceView";
	}

	/**
	 * 保存接口
	 */
	@RequiresPermissions(value={"tools:testInterface:add","tools:testInterface:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(TestInterface testInterface, Model model, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
		}
		
		if (!beanValidator(model, testInterface)){
			return form(testInterface, model);
		}
		testInterfaceService.save(testInterface);
		addMessage(redirectAttributes, "保存接口成功");
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
	}
	
	/**
	 * 删除接口
	 */
	@RequiresPermissions("tools:testInterface:del")
	@RequestMapping(value = "delete")
	public String delete(TestInterface testInterface, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
		}
		
		testInterfaceService.delete(testInterface);
		addMessage(redirectAttributes, "删除接口成功");
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
	}
	
	/**
	 * 批量删除接口
	 */
	@RequiresPermissions("tools:testInterface:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
		}
		
		String idArray[] =ids.split(",");
		for(String id : idArray){
			testInterfaceService.delete(testInterfaceService.get(id));
		}
		addMessage(redirectAttributes, "删除接口成功");
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("tools:testInterface:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(TestInterface testInterface, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "接口"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TestInterface> page = testInterfaceService.findPage(new Page<TestInterface>(request, response, -1), testInterface);
    		new ExportExcel("接口", TestInterface.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出接口记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("tools:testInterface:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
		}
		try {
			int successNum = 0;
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TestInterface> list = ei.getDataList(TestInterface.class);
			for (TestInterface testInterface : list){
				testInterfaceService.save(testInterface);
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条接口记录");
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入接口失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
    }
	
	/**
	 * 下载导入接口数据模板
	 */
	@RequiresPermissions("tools:testInterface:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "接口数据导入模板.xlsx";
    		List<TestInterface> list = Lists.newArrayList(); 
    		new ExportExcel("接口数据", TestInterface.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/tools/testInterface/?repage";
    }
	

	@RequiresPermissions("tools:testInterface:test")
	@RequestMapping(value="/test")
	public String form(String id, HttpServletRequest request, HttpServletResponse response, Model model) {
		TestInterface testInterface = testInterfaceService.get(id);
		
		SysAccount sysAccount = sysAccountService.get(UserUtils.getUser().getAccountId());		
		testInterface.setBody("&accountId="+sysAccount.getId()+"&apiSecret="+sysAccount.getApiSecret() + testInterface.getBody());
		
		model.addAttribute("testInterface", testInterface);
		return "modules/tools/interfaceTest";
	}

	/**
	 *	接口内部请求
	 * @param 
	 * @throws Exception
	 */
	@RequestMapping(value="/severTest")
	@ResponseBody
	public Object severTest(HttpServletRequest request, HttpServletResponse response, Model model){
		Map<String,String> map = new HashMap<String,String>();
		String errInfo = "success",str = "",rTime="";
		try{
			long startTime = System.currentTimeMillis(); 	
			String s_url = request.getParameter("serverUrl");//请求起始时间_毫秒
			String type = request.getParameter("requestMethod");
			String requestBody = request.getParameter("requestBody");
			URL url;		
			if(type.equals("POST")){//请求类型  POST or GET	
				Map<String, String> params = new HashMap<String, String>();
				
				if(requestBody!=null && !requestBody.equals("")){
				    String[] paramList = requestBody.split("&");
				    
				    for(String param : paramList){
				    	if(param.split("=").length == 2){
				    		params.put(param.split("=")[0], param.split("=")[1]);
				    	}else{
				    		params.put(param.split("=")[0], "");
				    	}
				    }
				}
			    HttpPostTest test = new HttpPostTest(s_url, params);
			    
			    str=  test.post();
			}else{
				url = new URL(s_url);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("GET");
				BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
									//请求结束时间_毫秒
				String temp = "";
				while((temp = in.readLine()) != null){ 
					str = str + temp;
				}
				
			}
			
			long endTime = System.currentTimeMillis(); 	
			rTime = String.valueOf(endTime - startTime); 
		}
		catch(Exception e){
			errInfo = "error";
			str = e.getMessage();
		}
		map.put("errInfo", errInfo);	//状态信息
		map.put("result", str);			//返回结果
		map.put("rTime", rTime);		//服务器请求时间 毫秒
		
		return map;
	}
	
	/**
	 * 获取新闻头条，测试
	 */
	public void getTopNews(){
		
		Map<String,String> map = new HashMap<String,String>();
		String errInfo = "success",str = "",rTime="";
		
		try{
			long startTime = System.currentTimeMillis(); 	
			String s_url = "http://v.juhe.cn/toutiao/index?type=top&key=a3adf0b6963c22375b3a60d94071efe1";
			String type = "POST";
			String requestBody = "";
			URL url;		
			if(type.equals("POST")){//请求类型  POST or GET	
				Map<String, String> params = new HashMap<String, String>();
				
				if(requestBody!=null && !requestBody.equals("")){
				    String[] paramList = requestBody.split("&");
				    
				    for(String param : paramList){
				    	if(param.split("=").length == 2){
				    		params.put(param.split("=")[0], param.split("=")[1]);
				    	}else{
				    		params.put(param.split("=")[0], "");
				    	}
				    }
				}
			    HttpPostTest test = new HttpPostTest(s_url, params);
			    
			    str=  test.post();
			}else{
				url = new URL(s_url);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("GET");
				BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
									//请求结束时间_毫秒
				String temp = "";
				while((temp = in.readLine()) != null){ 
					str = str + temp;
				}
				
			}
			
			//解析例子
			 JSONObject json = JSONObject.parseObject(str);
			 JSONObject resultJson = json.getJSONObject("result");
			 JSONArray dataJsonA = resultJson.getJSONArray("data");
			 for (int i = 0; i < dataJsonA.size(); i++) {
				 
				 JSONObject data = dataJsonA.getJSONObject(i);
				 
				 String title = data.getString("title");//标题
				 String author_name = data.getString("author_name");//作者
				 String xwurl = data.getString("url");//URL
				 System.out.println(title);
			 }
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	 public static byte[] readInputStream(InputStream inStream) throws Exception{
	        ByteArrayOutputStream outStream = new ByteArrayOutputStream();
	        byte[] buffer = new byte[1024];
	        int len = 0;
	        while( (len = inStream.read(buffer)) !=-1 ){
	            outStream.write(buffer, 0, len);
	        }
	        byte[] data = outStream.toByteArray();//网页的二进制数据
	        outStream.close();
	        inStream.close();
	        return data;
	    }

}