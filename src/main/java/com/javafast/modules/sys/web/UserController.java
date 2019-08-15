package com.javafast.modules.sys.web;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

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

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.beanvalidator.BeanValidators;
import com.javafast.common.config.Global;
import com.javafast.common.json.AjaxJson;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.FileUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.common.web.BaseController;
import com.javafast.modules.main.utils.InitDataUtils;
import com.javafast.modules.sys.dao.UserDao;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.Role;
import com.javafast.modules.sys.entity.SysSms;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.RoleService;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SysSmsService;
import com.javafast.modules.sys.service.SystemService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;
//import com.javafast.modules.tools.utils.TwoDimensionCode;

/**
 * 用户Controller
 * @author JavaFast
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	@Autowired
	private SysSmsService sysSmsService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	@Autowired
	private UserDao userDao;
	
	@Autowired
	private SystemService systemService;
	
	@ModelAttribute
	public User get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return userService.getUser(id);
		}else{
			return new User();
		}
	}

	@RequiresPermissions("sys:user:index")
	@RequestMapping(value = {"index"})
	public String index(User user, Model model) {
		return "modules/sys/userIndex";
	}

	@RequiresPermissions("sys:user:index")
	@RequestMapping(value = {"list", ""})
	public String list(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<User> page = userService.findPage(new Page<User>(request, response), user);
        model.addAttribute("page", page);
		return "modules/sys/userList";
	}
	
	@RequiresPermissions(value={"sys:user:view","sys:user:add","sys:user:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(User user, Model model) {
		
		long userCount = userService.findCount(user) + 1;
		if(user.getIsNewRecord()){
			user.setNo("" + userCount);
			user.setUserType("3");
		}
		if (user.getCompany()==null || user.getCompany().getId()==null){
			user.setCompany(UserUtils.getUser().getCompany());
		}
		if (user.getOffice()==null || user.getOffice().getId()==null){
			user.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("user", user);
				
		List<Role> roleList = roleService.findAllRole();
		model.addAttribute("allRoles", roleList);
		
		return "modules/sys/userForm";
	}
	
	@RequestMapping(value = "view")
	public String view(User user, Model model) {		
		model.addAttribute("user", user);
		return "modules/sys/userView";
	}

	@RequiresPermissions(value={"sys:user:add","sys:user:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		// 修正引用赋值问题，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
		user.setCompany(new Office(request.getParameter("company.id")));
		user.setOffice(new Office(request.getParameter("office.id")));
		
		// 如果新密码为空，则不更换密码
		if (StringUtils.isNotBlank(user.getNewPassword())) {
			user.setPassword(UserService.entryptPassword(user.getNewPassword()));
		}
		if (!beanValidator(model, user)){
			return form(user, model);
		}
		
		if (!"true".equals(checkLoginName(user.getOldLoginName(), user.getLoginName()))){
			addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
			return form(user, model);
		}
		
		// 角色数据有效性验证，过滤不在授权内的角色
		List<Role> roleList = Lists.newArrayList();
		List<String> roleIdList = user.getRoleIdList();
		for (Role r : roleService.findAllRole()){
			if (roleIdList.contains(r.getId())){
				roleList.add(r);
			}
		}
		
		user.setRoleList(roleList);
		
		// 获取到最大的数据权限范围
		String roleId = "";
		int dataScopeInteger = 8;//默认为本人数据
		for (Role r : user.getRoleList()){
			int ds = Integer.valueOf(r.getDataScope());
			if (ds == 9){
				roleId = r.getId();
				dataScopeInteger = ds;
				break;
			}else if (ds < dataScopeInteger){
				roleId = r.getId();
				dataScopeInteger = ds;
			}
		}
		String dataScope = String.valueOf(dataScopeInteger);
		user.setDataScope(dataScope);
				
//		//生成用户二维码，使用登录名
//		String realPath = Global.getUserfilesBaseDir() + Global.USERFILES_BASE_URL
//		+ user.getId() + "/qrcode/";
//		FileUtils.createDirectory(realPath);
//		String name= user.getId()+".png"; //encoderImgId此处二维码的图片名
//		String filePath = realPath + name;  //存放路径
//		//TwoDimensionCode.encoderQRCode(user.getLoginName(), filePath, "png");//执行生成二维码
//		//user.setQrCode(request.getContextPath()+Global.USERFILES_BASE_URL +  user.getId()  + "/qrcode/"+name);
//		if(StringUtils.isBlank(user.getPhoto())){
//			user.setPhoto("/static/images/user.jpg");
//		}
		
		// 保存用户信息
		userService.saveUser(user);
		
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())){
			UserUtils.clearCache();
		}
		
		addMessage(redirectAttributes, "保存用户'" + user.getLoginName() + "'成功");
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	@RequiresPermissions("sys:user:del")
	@RequestMapping(value = "delete")
	public String delete(User user, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		if (UserUtils.getUser().getId().equals(user.getId())){
			addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
		}else if (User.isAdmin(user.getId())){
			addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
		}else if (sysAccountService.findUniqueByProperty("admin_user_id", user.getId()) != null){
			addMessage(redirectAttributes, "删除用户失败, 不允许删除管理员用户");
		}else{
			userService.delete(user);
			addMessage(redirectAttributes, "删除用户成功");
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 批量删除用户
	 */
	@RequiresPermissions("sys:user:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			User user = userService.getUser(id);
			if(Global.isDemoMode()){
				addMessage(redirectAttributes, "演示模式，不允许操作！");
				return "redirect:" + adminPath + "/sys/user/list?repage";
			}
			if (UserUtils.getUser().getId().equals(user.getId())){
				addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
			}else if (User.isAdmin(user.getId())){
				addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
			}else if (sysAccountService.findUniqueByProperty("admin_user_id", user.getId()) != null){
				addMessage(redirectAttributes, "删除用户失败, 不允许删除管理员用户");
			}else{
				userService.delete(user);
				addMessage(redirectAttributes, "删除用户成功");
			}
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 批量启用
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:del")
	@RequestMapping(value = "useAll")
	public String useAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			User user = userService.getUser(id);
			if(Global.isDemoMode()){
				addMessage(redirectAttributes, "演示模式，不允许操作！");
				return "redirect:" + adminPath + "/sys/user/list?repage";
			}
			
			if("0".equals(user.getLoginFlag())){
				
				user.setLoginFlag("1");
				userService.updateLoginFlag(user);
				addMessage(redirectAttributes, "启用用户成功");
			}
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 批量禁用
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:del")
	@RequestMapping(value = "unUseAll")
	public String unUseAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			User user = userService.getUser(id);
			if(Global.isDemoMode()){
				addMessage(redirectAttributes, "演示模式，不允许操作！");
				return "redirect:" + adminPath + "/sys/user/list?repage";
			}
			
			if (UserUtils.getUser().getId().equals(user.getId())){
				addMessage(redirectAttributes, "禁用用户失败, 不允许禁用当前用户");
			}else if (User.isAdmin(user.getId())){
				addMessage(redirectAttributes, "禁用用户失败, 不允许禁用超级管理员用户");
			}else if (sysAccountService.findUniqueByProperty("admin_user_id", user.getId()) != null){
				addMessage(redirectAttributes, "禁用用户失败, 不允许禁用管理员用户");
			}else{
				
				if("1".equals(user.getLoginFlag())){
					
					user.setLoginFlag("0");
					userService.updateLoginFlag(user);
					addMessage(redirectAttributes, "禁用用户成功");
				}				
			}
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 导出用户数据
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(User user, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "用户数据"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<User> page = userService.findPage(new Page<User>(request, response, -1), user);
    		new ExportExcel("用户数据", User.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出用户失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }

	/**
	 * 导入用户数据
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<User> list = ei.getDataList(User.class);
			for (User user : list){
				try{
					if ("true".equals(checkLoginName("", user.getLoginName()))){
						user.setPassword(UserService.entryptPassword("123456"));
						BeanValidators.validateWithException(validator, user);
						userService.saveUser(user);
						successNum++;
					}else{
						failureMsg.append("<br/>登录名 "+user.getLoginName()+" 已存在; ");
						failureNum++;
					}
				}catch(ConstraintViolationException ex){
					failureMsg.append("<br/>登录名 "+user.getLoginName()+" 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList){
						failureMsg.append(message+"; ");
						failureNum++;
					}
				}catch (Exception ex) {
					failureMsg.append("<br/>登录名 "+user.getLoginName()+" 导入失败："+ex.getMessage());
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条用户，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条用户"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }
	
	/**
	 * 下载导入用户数据模板
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "用户数据导入模板.xlsx";
    		List<User> list = Lists.newArrayList(); list.add(UserUtils.getUser());
    		new ExportExcel("用户数据", User.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }

	/**
	 * 验证登录名是否有效(登录名是否被占用)
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName !=null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName !=null && userService.getUserByLoginName(loginName) == null) {
			return "true";
		}
		return "false";
	}
	
	/**
	 * 校验手机号码是否被占用
	 * @param mobile
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkMobile")
	public String checkMobile(String oldMobile, String mobile) {
		try{
			
			if (mobile !=null && oldMobile !=null && mobile.equals(oldMobile)) {
				return "true";
			} else if (mobile !=null && userDao.findUniqueByProperty("mobile", mobile) == null) {
				return "true";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "false";
	}

	/**
	 * 用户信息显示
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "info")
	public String info(HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "modules/sys/userInfo";
	}
	
	/**
	 * 用户信息显示编辑
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "infoEdit")
	public String infoEdit(User user, boolean __ajax, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();		
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "modules/sys/userInfoEdit";
	}

	/**
	 * 用户信息保存
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "saveUserInfo")
	public String saveUserInfo(User user, boolean __ajax, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())){
			if(Global.isDemoMode()){
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userInfo";
			}
			if(user.getName() !=null )
				currentUser.setName(user.getName());
			if(user.getEmail() !=null )
				currentUser.setEmail(user.getEmail());
			if(user.getPhone() !=null )
				currentUser.setPhone(user.getPhone());
			if(user.getMobile() !=null )
				currentUser.setMobile(user.getMobile());
			if(user.getRemarks() !=null )
				currentUser.setRemarks(user.getRemarks());
//			if(user.getPhoto() !=null )
//				currentUser.setPhoto(user.getPhoto());
			userService.updateUserInfo(currentUser);
			if(__ajax){//手机访问
				AjaxJson j = new AjaxJson();
				j.setSuccess(true);
				j.setMsg("修改个人资料成功!");
				return renderString(response, j);
			}
			model.addAttribute("user", currentUser);
			model.addAttribute("Global", new Global());
			model.addAttribute("message", "保存用户信息成功");
			return "modules/sys/userInfo";
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "redirect:" + adminPath + "/sys/user/info?repage";
	}
	
	/**
	 * 用户头像显示编辑保存
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "imageEdit")
	public String imageEdit(User user, boolean __ajax, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())){
			if(Global.isDemoMode()){
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userInfo";
			}
			if(user.getPhoto() !=null )
				currentUser.setPhoto(user.getPhoto());
			userService.updateUserInfo(currentUser);
			if(__ajax){//手机访问
				AjaxJson j = new AjaxJson();
				j.setSuccess(true);
				j.setMsg("修改个人头像成功!");
				return renderString(response, j);
			}
			model.addAttribute("message", "保存用户信息成功");
			return "modules/sys/userInfo";
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "modules/sys/userImageEdit";
	}
	
	/**
	 * 用户头像显示编辑保存
	 * @param user
	 * @param model
	 * @return
	 * @throws IOException 
	 * @throws IllegalStateException 
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "imageUpload")
	public String imageUpload( HttpServletRequest request, HttpServletResponse response, Model model, MultipartFile file) throws IllegalStateException, IOException {
		User currentUser = UserUtils.getUser();
		
		if(Global.isDemoMode()){
			model.addAttribute("message", "演示模式，不允许操作！");
			return "modules/sys/userImageEdit";
		}
		
		// 判断文件是否为空  
        if (!file.isEmpty()) {  
                // 文件保存路径  
            	String realPath = Global.USERFILES_BASE_URL
        		+ UserUtils.getPrincipal() + "/images/" ;
                // 转存文件  
            	FileUtils.createDirectory(Global.getUserfilesBaseDir()+realPath);
            	file.transferTo(new File( Global.getUserfilesBaseDir() +realPath +  file.getOriginalFilename()));  
            	currentUser.setPhoto(request.getContextPath()+realPath + file.getOriginalFilename());
            	userService.updateUserInfo(currentUser);
        }  

		return "modules/sys/userImageEdit";
	}

	/**
	 * 返回用户信息
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "infoData")
	public AjaxJson infoData() {
		AjaxJson j = new AjaxJson();
		j.setSuccess(true);
		j.setErrorCode("-1");
		j.setMsg("获取个人信息成功!");
		j.put("data", UserUtils.getUser());
		return j;
	}
	
	/**
	 * 修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd")
	public String modifyPwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)){
			if(Global.isDemoMode()){
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userModifyPwd";
			}
			if (UserService.validatePassword(oldPassword, user.getPassword())){
				userService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				model.addAttribute("message", "修改密码成功");
			}else{
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
			return "modules/sys/userModifyPwd";
		}
		model.addAttribute("user", user);
		return "modules/sys/userModifyPwd";
	}
	
	/**
	 * 保存签名
	 */
	@ResponseBody
	@RequestMapping(value = "saveSign")
	public AjaxJson saveSign(User user, boolean __ajax, HttpServletResponse response, Model model) throws Exception{
		AjaxJson j = new AjaxJson();
		User currentUser = UserUtils.getUser();
		currentUser.setSign(user.getSign());
		userService.updateUserInfo(currentUser);
		j.setMsg("设置签名成功");
		return j;
	}
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = userService.findUserByOfficeId(officeId);
		for (int i=0; i<list.size(); i++){
			User e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "u_"+e.getId());
			map.put("pId", officeId);
			map.put("name", StringUtils.replace(e.getName(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}
    
	/**
	 * web端ajax验证用户名是否可用
	 * @param loginName
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "validateLoginName")
	public boolean validateLoginName(String loginName, HttpServletResponse response) {
		
	    User user =  userDao.findUniqueByProperty("login_name", loginName);
	    if(user == null){
	    	return true;
	    }else{
		    return false;
	    }
	    
	}
	
	/**
	 * web端ajax验证手机号是否可以注册（数据库中不存在）
	 */
	@ResponseBody
	@RequestMapping(value = "validateMobile")
	public boolean validateMobile(String mobile, HttpServletResponse response, Model model) {
		  User user =  userDao.findUniqueByProperty("mobile", mobile);
		    if(user == null){
		    	return true;
		    }else{
			    return false;
		    }
	}
	
	/**
	 * web端ajax验证手机号是否已经注册（数据库中已存在）
	 */
	@ResponseBody
	@RequestMapping(value = "validateMobileExist")
	public boolean validateMobileExist(String mobile, HttpServletResponse response, Model model) {
		  User user =  userDao.findUniqueByProperty("mobile", mobile);
		    if(user != null){
		    	return true;
		    }else{
			    return false;
		    }
	}
	
	/**
	 * 密码重置
	 * @param mobile
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "resetPassword")
	public AjaxJson resetPassword(String mobile, HttpServletResponse response, Model model) {
				
		AjaxJson j = new AjaxJson();
		
		try {
			
			if(userDao.findUniqueByProperty("mobile", mobile) == null){
				j.setSuccess(false);
				j.setMsg("手机号不存在!");
				j.setErrorCode("1");
				return j;
			}
			
			User user =  userDao.findUniqueByProperty("mobile", mobile);
			
			//创建新密码，随机数
			String newPassword = String.valueOf((int) (Math.random() * 900000 + 100000));

			boolean flag = SmsUtils.sendResetPwdSms(mobile, user.getAccountId(), user.getLoginName(), newPassword);
			if(flag){
				
				//重置密码
				userService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				
				j.setSuccess(true);
				j.setErrorCode("-1");
				j.setMsg("短信发送成功!");
				//request.getSession().getServletContext().setAttribute(mobile, randomCode);
				
				//记录短信
				SysSms sysSms = new SysSms();
				sysSms.setSmsType("4"); //短信类型 0注册验证码， 1注册成功通知， 3密码找回验证码，4，密码重置成功通知
				sysSms.setMobile(mobile);
				sysSms.setIp("");
				sysSms.setStatus("1");
				sysSms.setContent("密码重置成功！您的登录账号："+user.getLoginName()+"，登录密码："+newPassword+"，请妥善保管。");
				sysSmsService.save(sysSms);
			}else{
				
				j.setSuccess(false);
				j.setErrorCode("2");
				j.setMsg("短信发送失败，请联系管理员。");
			}
		} catch (Exception e) {
			j.setSuccess(false);
			j.setErrorCode("3");
			j.setMsg("因未知原因导致短信发送失败，请联系管理员。");
		}
		return j;
	}

//	/**
//	 * 批量同步到企业微信
//	 * @param ids
//	 * @param redirectAttributes
//	 * @return
//	 */
//	@RequiresPermissions(value={"sys:user:add","sys:user:edit"},logical=Logical.OR)
//	@RequestMapping(value = "synQywxAll")
//	public String synQywxAll(String ids, RedirectAttributes redirectAttributes) {
//		String idArray[] =ids.split(",");
//		for(String id : idArray){
//			
//			User user = userService.getUser(id);
//			if(Global.isDemoMode()){
//				addMessage(redirectAttributes, "演示模式，不允许操作！");
//				return "redirect:" + adminPath + "/sys/user/list?repage";
//			}
//			
//			if("1".equals(user.getLoginFlag())){
//				
//				
//				addMessage(redirectAttributes, "同步到企业微信成功");
//			}
//		}
//		return "redirect:" + adminPath + "/sys/user/list?repage";
//	}
	
	/**
	 * 同步企业微信
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:user:add","sys:user:edit"},logical=Logical.OR)
	@RequestMapping(value = "loadQywxSystem")
	public String loadQywxSystem(RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		
		try {
			if(systemService.loadWechatDepart(UserUtils.getUser().getAccountId())){
				addMessage(redirectAttributes, "同步企业微信成功");
			}else{
				addMessage(redirectAttributes, "同步企业微信失败，请到确认是否已连接企业微信");
			}
		}catch(Exception e){
			e.printStackTrace();
		}		
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 用户交接页面
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "overForm")
	public String overForm(User user, Model model) {
		model.addAttribute("user", user);
		return "modules/sys/userOverForm";
	}
	
	/**
	 * 用户交接处理
	 * @param user
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:del")
	@RequestMapping(value = "saveOver")
	public String saveOver(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		
		try{

			//1校验
			if(user.getId().equals(user.getOwnBy().getId())){
				addMessage(redirectAttributes, "接收人不能为交接人！");
				return "redirect:" + adminPath + "/sys/user/list?repage";
			}
			
			User ownBy = userService.get(user.getOwnBy().getId());
			
			if(ownBy.getOffice() == null){
				addMessage(redirectAttributes, "用户"+ownBy.getName()+"未设置归属部门，请设置归属部门后再移交");
				return "redirect:" + adminPath + "/sys/user/list?repage";
			}
			
			//2工作交接
			InitDataUtils.workOverData(user, ownBy);
			addMessage(redirectAttributes, "工作交接成功，"+user.getName()+"的数据已经移交给"+ownBy.getName());
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "工作交接失败");
		}finally {
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
	}
}
