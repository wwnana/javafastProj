package com.javafast.modules.sys.web;

import java.util.List;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.common.config.Global;
import com.javafast.common.mail.MailSendUtils;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.qw.utils.WorkWeixinUtils;
import com.javafast.modules.sys.entity.SysConfig;
import com.javafast.modules.sys.service.SysConfigService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 系统配置Controller
 * @author javafast
 * @version 2018-05-24
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysConfig")
public class SysConfigController extends BaseController {

	@Autowired
	private SysConfigService sysConfigService;
	
	@ModelAttribute
	public SysConfig get(@RequestParam(required=false) String id) {
		SysConfig entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysConfigService.get(id);
		}
		if (entity == null){
			entity = new SysConfig();
		}
		return entity;
	}

	
	
	/**
	 * 系统配置
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = {"index", ""})
	public String index(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		SysConfig sysConfig = sysConfigService.get(UserUtils.getUser().getAccountId());
		if(sysConfig == null)
			sysConfig = new SysConfig();
		
		model.addAttribute("sysConfig", sysConfig);
		return "modules/sys/sysConfigForm";
	}
	
	/**
	 * 系统配置列表页面
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = "list")
	public String list(SysConfig sysConfig, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysConfig> page = sysConfigService.findPage(new Page<SysConfig>(request, response), sysConfig); 
		model.addAttribute("page", page);
		return "modules/sys/sysConfigList";
	}

	/**
	 * 编辑系统配置表单页面
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = "form")
	public String form(SysConfig sysConfig, Model model) {
		model.addAttribute("sysConfig", sysConfig);
		return "modules/sys/sysConfigForm";
	}
	
	/**
	 * 查看系统配置页面
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = "view")
	public String view(SysConfig sysConfig, Model model) {
		model.addAttribute("sysConfig", sysConfig);
		return "modules/sys/sysConfigView";
	}

	/**
	 * 保存系统配置
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = "save")
	public String save(SysConfig sysConfig, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysConfig)){
			return form(sysConfig, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/sys/sysConfig/?repage";
		}
		
		try{
		
			if(!sysConfig.getIsNewRecord()){//编辑表单保存				
				SysConfig t = sysConfigService.get(sysConfig.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysConfig, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysConfigService.save(t);//保存
			}else{//新增表单保存
				sysConfigService.save(sysConfig);//保存
			}
			
			//测试企业微信
			WorkWeixinUtils.getAccessToken(UserUtils.getUser().getAccountId());
			
			addMessage(redirectAttributes, "保存系统配置成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存系统配置失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/sys/sysConfig/?repage";
		}
	}
	
	//测试邮件页面
	@RequestMapping(value = "testMailForm")
	public String testMailForm(RedirectAttributes redirectAttributes) {
		return "modules/sys/testMailForm";
	}
	
	//测试邮件
	@RequestMapping(value = "testMail")
	public String testMail(String toMail, RedirectAttributes redirectAttributes) {
		
		SysConfig sysConfig = sysConfigService.get(UserUtils.getUser().getAccountId());
		
		//构建邮件发送参数
		String smtp = sysConfig.getMailSmtp();//邮件服务器
		String port = sysConfig.getMailPort();// 端口
		String email = sysConfig.getMailName();//本邮箱账号
		String paw = sysConfig.getMailPassword();//本邮箱账号
		//String toMail = sysConfig.getMailName();//收件方邮箱号 测试的时候，自己发给自己
		String title = "这是一份测试邮件";//标题
		String content = "这是一份测试邮件";//内容
		String type = "2";//1：文本格式;2：HTML格式

		//发送邮件
		if(MailSendUtils.sendEmail(smtp, port, email, paw, toMail, title, content, type)){
			addMessage(redirectAttributes, "邮件发送成功，请查看邮箱是否收到邮件?");
		}else{
			addMessage(redirectAttributes, "邮件发送失败");
		}
		
		return "redirect:"+Global.getAdminPath()+"/sys/sysConfig/?repage";
	}
	
	@RequestMapping(value = "secret")
	public String secret(HttpServletRequest request, HttpServletResponse response, Model model) {
		SysConfig sysConfig = sysConfigService.get(UserUtils.getUser().getAccountId());
		if(sysConfig == null){
			sysConfig = new SysConfig();
			
			String wxCorpid = UserUtils.getSysAccount().getCorpid();
			sysConfig.setWxCorpid(wxCorpid);
		}
		model.addAttribute("sysConfig", sysConfig);
		return "modules/sys/sysConfigSecretForm";
	}
	
	/**
	 * 保存系统配置
	 */
	@RequiresPermissions("sys:sysConfig:list")
	@RequestMapping(value = "saveSecret")
	public String saveSecret(SysConfig sysConfig, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysConfig)){
			return form(sysConfig, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/sys/sysConfig/secret?repage";
		}
		addMessage(redirectAttributes, "配置失败");
		
		try{

			if(!sysConfig.getIsNewRecord()){//编辑表单保存				
				SysConfig t = sysConfigService.get(sysConfig.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysConfig, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysConfigService.save(t);//保存
			}else{//新增表单保存
				sysConfigService.save(sysConfig);//保存
			}
			
			//测试企业微信
			if(sysConfig != null && StringUtils.isNotBlank(sysConfig.getWxCorpid()) && StringUtils.isNotBlank(sysConfig.getCheckinSecret())){
    			
    			//通过打卡应用的Secret获取token
    			AccessToken accessToken = WxAccessTokenAPI.getAccessToken(sysConfig.getWxCorpid(), sysConfig.getCheckinSecret());
    			if(accessToken != null){
    				
    				addMessage(redirectAttributes, "配置成功");
    			}
			}
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存系统配置失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/sys/sysConfig/secret";
		}
	}
}